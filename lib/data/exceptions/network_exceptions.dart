import 'package:notification_app/data/models/api_error.dart';

class NetworkException implements Exception {
  NetworkException([this._message, this._prefix]);

  final String? _message;
  final String? _prefix;

  String toString() {
    return '$_prefix$_message';
  }
}

class BadRequestException extends NetworkException {
  BadRequestException([String? message]) : super(message, 'Invalid Request: ');
}

class ForbiddenException extends NetworkException {
  ForbiddenException([String? message]) : super(message, 'Forbiden: ');
}

class RetryWithException extends NetworkException {
  RetryWithException([String? message]) : super(message, 'Retry With: ');
}

class FetchDataException extends NetworkException {
  FetchDataException([String? message]) : super(message, 'Fetch Error: ');
}

class ServiceUnavailalbeException extends NetworkException {
  ServiceUnavailalbeException([String? message])
      : super(message, 'Service Unavailable: ');
}

class UnauthorizedException {
  late UnauthorizedReason reason;

  final ApiError _error;

  String toString() {
    return '${_error.message}';
  }

  UnauthorizedException(this._error) {
    reason = _mapUnauthorizedToEnum(_error);
  }

  UnauthorizedReason _mapUnauthorizedToEnum(ApiError error) {
    switch (error.message) {
      case 'OTP_REQUIRED':
        return UnauthorizedReason.OTP_NEEDED;
      case 'BAD_CREDENTIALS':
        return UnauthorizedReason.BAD_CREDENTIALS;
      case 'NOT_ALLOWED_FRAUD':
        return UnauthorizedReason.NOT_ALLOWED_FRAUD;
      case 'NOT_ALLOWED_NOTPAYBILL':
        return UnauthorizedReason.NOT_ALLOWED_NOTPAYBILL;
      case 'NOT_ALLOWED_COLLECTIONS':
        return UnauthorizedReason.NOT_ALLOWED_COLLECTIONS;
      case 'NOT_ALLOWED_LEFT':
        return UnauthorizedReason.NOT_ALLOWED_LEFT;
      case 'NOT_ALLOWED_OWNERSHIP':
        return UnauthorizedReason.NOT_ALLOWED_OWNERSHIP;
      case 'NOT_ALLOWED_CHANGEMSISDN':
        return UnauthorizedReason.NOT_ALLOWED_CHANGEMSISDN;
      default:
        return UnauthorizedReason.UNKNOWN;
    }
  }
}

enum UnauthorizedReason {
  NOT_ALLOWED_FRAUD,
  NOT_ALLOWED_NOTPAYBILL,
  NOT_ALLOWED_COLLECTIONS,
  NOT_ALLOWED_LEFT,
  NOT_ALLOWED_OWNERSHIP,
  NOT_ALLOWED_CHANGEMSISDN,
  OTP_NEEDED,
  BAD_CREDENTIALS,
  UNKNOWN,
}
