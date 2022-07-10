import 'package:flutter/material.dart' show debugPrint;
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:notification_app/services/authentication_storage_service.dart';

class AuthenticatedHttpClient extends IOClient {
  final AuthenticationStorage _authenticationStorage = AuthenticationStorage();

  /// Default content-type in case no custom content-type header provided from
  /// related provider.
  static const String defaultContentType = 'application/json';

  @override
  Future<IOStreamedResponse> send(BaseRequest request) async {
    String? accessToken = await _authenticationStorage.getToken();

    /// Set default content-type for communication with api if not provided
    final BaseRequest mutableRequest = request
      ..headers.putIfAbsent('content-type', () => defaultContentType);

    /// Inject accessToken only if it's exists.
    if ((accessToken ?? '').isNotEmpty) {
      mutableRequest
        ..headers.putIfAbsent('Authorization', () => 'Bearer $accessToken');
    }

    debugPrint('[HTTP_REQUEST] => ' +
        'method : ${mutableRequest.toString()} :: ' +
        'headers : ${mutableRequest.headers.toString()}');

    return super.send(mutableRequest);
  }
}
