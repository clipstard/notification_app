part of 'otp_bloc.dart';

@immutable
abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object> get props => <Object>[];
}

class OtpInitEvent extends OtpEvent {}

class OtpRequestedEvent extends OtpEvent {
  final String msisdn;
  final OtpType otpType;

  OtpRequestedEvent(
    this.msisdn, {
    required this.otpType,
  });
}

class OtpRejectedEvent extends OtpEvent {
  final OTPData otpData;

  OtpRejectedEvent(this.otpData);
}

class OtpRequestErrorEvent extends OtpEvent {
  final String? message;

  OtpRequestErrorEvent([this.message]);
}

class OtpRequestNegativeEvent extends OtpEvent {
  final String? message;

  OtpRequestNegativeEvent([this.message]);
}

class OtpUndefinedEvent extends OtpEvent {
  @override
  List<Object> get props => <Object>[Object()];
}

class OtpValidatedEvent extends OtpEvent {
  final OTPData otpData;
  final String otpCode;
  final OtpType otpType;

  OtpValidatedEvent({
    required this.otpData,
    required this.otpCode,
    required this.otpType,
  });
}

class OtpValidateAttemptEvent extends OtpEvent {
  final OTPData otpData;
  final String otpCode;
  final OtpType otpType;

  OtpValidateAttemptEvent({
    required this.otpData,
    required this.otpCode,
    required this.otpType,
  });
}
