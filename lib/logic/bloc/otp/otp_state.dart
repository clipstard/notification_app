part of 'otp_bloc.dart';

@immutable
abstract class OtpState extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class OtpInit extends OtpState {}

class OtpEmpty extends OtpState {}

class OtpRequested extends OtpState {
  final OTPData otpData;
  final OtpType otpType;

  OtpRequested(
    this.otpData,
    this.otpType,
  );
}

class OtpRequestErrored extends OtpState {
  final String? message;
  OtpRequestErrored([this.message]);
  List<Object> get props => <Object>[Object()];
}

class OtpRequestNegative extends OtpState {
  final String? message;
  OtpRequestNegative([this.message]);
  List<Object> get props => <Object>[Object()];
}

class OtpAttemptsExceeded extends OtpState {
  final DateTime dueDate;
  final String msisdn;
  OtpAttemptsExceeded(this.dueDate, this.msisdn);

  List<Object> get props => <Object>[Object()];
}

class OtpRejected extends OtpState {
  List<Object> get props => <Object>[Object()];
}

class OtpValidated extends OtpState {
  final OTPData otpData;
  final String otpCode;
  final OtpType otpType;

  OtpValidated({
    required this.otpData,
    required this.otpCode,
    required this.otpType,
  });

  String toJson() {
    return json.encode(<String, String>{
      'otpCode': this.otpCode,
      'otpType': describeEnum(this.otpType),
      'userId': msisdnToCustomerId(this.otpData.msisdn),
    });
  }

  String toToken() {
    String otpToken = base64.encode(
      json.encode(<String, String>{
        'otpCode': this.otpCode,
        'otpType': describeEnum(this.otpType),
        'userId': msisdnToCustomerId(this.otpData.msisdn),
      }).codeUnits,
    );
    return otpToken;
  }
}

class OtpValidateAttempt extends OtpState {
  final OTPData otpData;

  OtpValidateAttempt({required this.otpData});
}
