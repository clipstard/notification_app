import 'dart:convert' show json;

import 'package:http/http.dart';

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  factory HttpException.fromResponse(Response response) {
    dynamic content = json.decode(response.body);
    if (content is Map && content['errorMessage'] != null) {
      throw HttpException(content['errorMessage'] as String);
    }

    return HttpException('Unknown message');
  }

  @override
  String toString() {
    return message;
  }
}
