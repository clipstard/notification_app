import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:notification_app/data/exceptions/network_exceptions.dart';
import 'package:notification_app/data/exceptions/otp_attempts_error.dart';
import 'package:notification_app/data/models/otp.dart';
import 'package:notification_app/data/models/otp_data.dart';
import 'package:notification_app/data/providers/otp_provider.dart';
import 'package:notification_app/data/repositories/otp_repository.dart';
import 'package:notification_app/utils/convert_util.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  static const int maxAttempts = 6;
  static const Duration _attemptsFailureWait = const Duration(hours: 1);

  final OtpRepository _otpRepository;

  OtpBloc({required OtpRepository otpRepository})
      : _otpRepository = otpRepository,
        super(OtpInit());

  OtpRepository get otpRepository => _otpRepository;

  @override
  Stream<OtpState> mapEventToState(OtpEvent event) async* {
    if (event is OtpInitEvent) {
      yield OtpInit();
    } else if (event is OtpRequestNegativeEvent) {
      yield OtpRequestNegative(event.message);
    } else if (event is OtpRequestErrorEvent) {
      yield OtpRequestErrored(event.message);
    } else if (event is OtpRequestedEvent) {
      yield* _mapOtpRequestToState(event);
    } else if (event is OtpRejectedEvent) {
      yield* _mapOtpRejectedToState(event.otpData);
    } else if (event is OtpValidateAttemptEvent) {
      yield* _mapOtpValidateAttempt(event);
    } else if (event is OtpValidatedEvent) {
      _otpRepository.clearAttempts(event.otpData.msisdn);
      yield OtpValidated(
        otpData: event.otpData,
        otpType: event.otpType,
        otpCode: event.otpCode,
      );
    } else {
      yield* _mapOtpEmptyToState();
    }
  }

  Stream<OtpState> _mapOtpRequestToState(OtpRequestedEvent event) async* {
    OneTimePassword? _result;
    try {
      _result = await requestOtpValidation(
        msisdn: event.msisdn,
        otpType: event.otpType,
      );
    } on OtpAttemptsError catch (error) {
      yield OtpAttemptsExceeded(
        error.dueDate,
        event.msisdn,
      );
      return;
    }

    if (_result == null) {
      yield OtpRequestErrored();
    } else if (_result.success) {
      yield OtpRequested(
        OTPData(
          msisdn: _result.userId!,
          retriesLeft: _result.numberOfRetriesLeft!,
          duration: _result.validityDuration!,
        ),
        event.otpType,
      );
    } else {
      yield OtpRequestNegative(
        _result.errorMessage,
      );
    }
  }

  Stream<OtpState> _mapOtpValidateAttempt(
      OtpValidateAttemptEvent event) async* {
    yield OtpValidateAttempt(otpData: event.otpData);

    try {
      bool validated = await validateOtp(
        otpCode: event.otpCode,
        otpData: event.otpData,
        otpType: event.otpType,
      );

      if (!validated) {
        yield OtpRejected();
      } else {
        this.add(
          OtpValidatedEvent(
            otpData: event.otpData,
            otpCode: event.otpCode,
            otpType: event.otpType,
          ),
        );
      }
    } on OtpAttemptsError catch (e) {
      yield OtpAttemptsExceeded(
        e.dueDate,
        event.otpData.msisdn,
      );
    } on UnauthorizedException catch (e) {
      yield OtpRequestErrored(e.toString());
    }
  }

  Future<OneTimePassword?> requestOtpValidation({
    required String msisdn,
    required OtpType otpType,
  }) async {
    try {
      OneTimePassword result = await _otpRepository.requestOtpValidation(
        msisdn: msisdn,
        otpType: otpType,
      );

      List<OTPData> otpAttempts =
          await _otpRepository.retrieveOtpAttempts(msisdn);

      if ((result.numberOfRetriesLeft ?? 1) <= 0 ||
          otpAttemptsExceeded(otpAttempts)) {
        throwAttemptsError(otpAttempts);
      }

      if (result.success) {
        await _otpRepository.storeOTPData(OTPData(
          msisdn: msisdn,
          retriesLeft: result.numberOfRetriesLeft!,
          duration: result.validityDuration!,
        ));
      }

      return result;
    } on OtpAttemptsError catch (e) {
      throw e;
    } catch (exception) {
      return null;
    }
  }

  Future<bool> validateOtp({
    required String otpCode,
    required OTPData otpData,
    required OtpType otpType,
  }) async {
    List<OTPData> otpAttempts =
        await _otpRepository.retrieveOtpAttempts(otpData.msisdn);

    if (otpAttemptsExceeded(otpAttempts)) {
      throwAttemptsError(otpAttempts);
    }

    await _otpRepository.storeOtpAttempt(otpData);

    bool _response = await _otpRepository.validateOtp(
      otpCode: otpCode,
      msisdn: otpData.msisdn,
      otpType: otpType,
    );
    if (!_response && otpAttempts.length == OtpBloc.maxAttempts - 1) {
      throwAttemptsError(otpAttempts);
    }

    return _response;
  }

  void throwAttemptsError(List<OTPData> otpAttempts) {
    DateTime _requestTime = otpAttempts.isNotEmpty
        ? otpAttempts.first.requestTime.add(_attemptsFailureWait)
        : DateTime.now().add(_attemptsFailureWait);
    throw OtpAttemptsError(_requestTime);
  }

  bool otpAttemptsExceeded(List<OTPData> otpAttempts) {
    return otpAttempts.length >= maxAttempts &&
        otpAttempts.first.requestTime.isAfter(
          DateTime.now().subtract(
            _attemptsFailureWait,
          ),
        );
  }

  Stream<OtpState> _mapOtpRejectedToState(OTPData otpData) async* {
    yield OtpRejected();
  }

  Stream<OtpState> _mapOtpEmptyToState() async* {
    await _otpRepository.clear();
    yield OtpEmpty();
  }
}
