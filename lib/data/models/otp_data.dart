import 'package:equatable/equatable.dart';
import 'package:notification_app/data/providers/otp_provider.dart';
import 'package:notification_app/extensions/extensions.dart' show Trimmer;

class OTPData extends Equatable {
  final String msisdn;
  final bool validated;
  final Duration validity;
  final int retriesLeft;
  final DateTime requestTime;

  OTPData({
    required this.msisdn,
    required int duration,
    required this.retriesLeft,
    this.validated = false,
    DateTime? requestTime,
  })  : validity = Duration(seconds: duration),
        this.requestTime = requestTime ?? DateTime.now();

  factory OTPData.fromJson(Map<String, dynamic> data) {
    return OTPData(
      msisdn: data['msisdn'] as String,
      validated: data['validated'] as bool,
      duration: data['validityDuration'] as int,
      retriesLeft: data['numberOfRetriesLeft'] as int,
      requestTime: data['requestTime'] != null
          ? DateTime.parse(data['requestTime'] as String)
          : null,
    );
  }

  OTPData copyWith({
    String? msisdn,
    OtpType? type,
    int? duration,
    int? retriesLeft,
    bool? validated,
    DateTime? requestTime,
  }) {
    return OTPData(
      msisdn: msisdn ?? this.msisdn,
      duration: duration ?? this.validity.inSeconds,
      retriesLeft: retriesLeft ?? this.retriesLeft,
      validated: validated ?? this.validated,
      requestTime: requestTime ?? this.requestTime,
    );
  }

  @override
  String toString() {
    return '''
    {
      "msisdn": "$msisdn",
      "validated": $validated,
      "validityDuration": ${validity.inSeconds},
      "numberOfRetriesLeft": $retriesLeft,
      "requestTime": "${requestTime.toString()}"
    }
    '''
        .toSingleLine()
        .reduceSpaces();
  }

  @override
  List<Object> get props => <Object>[msisdn, validated, validity, requestTime];
}
