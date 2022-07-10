class ApiError {
  final String code;
  final String message;

  const ApiError({
    required this.code,
    required this.message,
  });

  factory ApiError.fromJson(dynamic json) => ApiError(
        code: json['errorCode'].toString(),
        message: json['errorMessage'].toString(),
      );

  factory ApiError.fromAuthJson(dynamic json) => ApiError(
        code: json['error'].toString(),
        message: json['error_description'].toString(),
      );

  static const ApiError unknown = const ApiError(
    code: 'unknown',
    message: 'Unexpected error.',
  );
}
