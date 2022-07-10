import 'package:notification_app/extensions/extensions.dart' show Trimmer;

class OneTimePassword {
  String? message;
  int? numberOfRetriesLeft;
  String? userId;
  int? validityDuration;
  bool success;
  String? errorMessage;

  OneTimePassword({
    String? this.message,
    int? this.numberOfRetriesLeft,
    bool this.success = false,
    String? this.userId,
    String? this.errorMessage,
    int? this.validityDuration,
  });

  factory OneTimePassword.fromJson(dynamic json) {
    return OneTimePassword(
      message: json?['message'] as String?,
      numberOfRetriesLeft: json?['numberOfRetriesLeft'] as int?,
      success: json?['success'] as bool,
      userId: json?['userId']?.toString(),
      validityDuration: json?['validityDuration'] as int?,
      errorMessage: json?['errorMessage'] as String?,
    );
  }

  String? interpolated(String? value) {
    return value == null ? null : '\"$value\"';
  }

  @override
  String toString() {
    return '''
      {
        "message": "$message",
        "numberOfRetriesLeft": $numberOfRetriesLeft,
        "success": $success,
        "userId": ${interpolated(userId)},
        "validityDuration": $validityDuration,
        "errorMessage": ${interpolated(errorMessage)}
      }
     '''
        .toSingleLine()
        .reduceSpaces();
  }
}
