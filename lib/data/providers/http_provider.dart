import 'dart:async';
import 'dart:convert' show json;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:notification_app/data/exceptions/network_exceptions.dart';
import 'package:notification_app/data/models/api_error.dart';
import 'package:notification_app/http_client.dart';
import 'package:notification_app/mock_client.dart' show mockClient;
import 'package:notification_app/presentation/router/app_router.dart';
import 'package:notification_app/services/authentication_storage_service.dart';
import 'package:notification_app/services/navigation_service.dart';

class HttpProvider {
  final NavigationService _navService = NavigationService();
  final AuthenticationStorage _authenticationStorage = AuthenticationStorage();
  final bool useMock;

  HttpProvider({this.useMock = false});

  /// Get appropriate http client to go through
  Client get _httpClient =>
      this.useMock ? mockClient : AuthenticatedHttpClient();

  /// Build API Uri based on arguments provided
  /// [path] represents endpoint path with leading slash
  /// [apiVersion] provides ability to use different api version for any request
  /// [purePath] used to make calls to the base api url without prefixing
  /// the paths with /api/<api-version>
  /// [queryParameters] url query paraemters
  Uri _getApiUri(
    String path, {
    bool purePath = false,
    String? apiVersion,
    Map<String, dynamic>? queryParameters,
  }) {
    final String version = apiVersion ?? dotenv.env['API_VERSION']!;

    return Uri(
      host: dotenv.env['API_HOST'],
      path: purePath ? path : '/api/$version$path',
      scheme: dotenv.env['API_SCHEME'],
      queryParameters: queryParameters,
    );
  }

  /// Get response error message depending on response type.
  ApiError _getErrorFromJsonResponse(Map<String, dynamic> jsonResponse) {
    ApiError error = ApiError.unknown;

    try {
      if (jsonResponse.containsKey('errorCode')) {
        error = ApiError.fromJson(jsonResponse);
      } else if (jsonResponse.containsKey('error')) {
        error = ApiError.fromAuthJson(jsonResponse);
      }
    } catch (e) {
      throw FetchDataException(
          'Unable to decode error message from response $jsonResponse');
    }

    return error;
  }

  /// Intercept resposne redirections
  Response _interceptRedirections(Response response) {
    switch (response.statusCode) {
      case 401:
        if (!<String>[
          '/api/v1/otp',
          '/api/v1/otp/send',
          '/oauth/token',
        ].contains(response.request!.url.path)) {
          _logout();
        }
        break;
      case 503:
        _navigateMaintenance();
        break;
      default:
    }

    return response;
  }

  /// Http Response interceptor
  /// Important: always return original response object so that http can
  /// continue the execute.
  Future<dynamic> _interceptedResponse(Response data) async {
    dynamic parsed;

    final Response response = _interceptRedirections(data);

    debugPrint('[RESPONSE] => ' +
        'code : ${response.statusCode.toString()} :: ' +
        'body : ${response.body.toString()}');

    try {
      parsed = json.decode(response.body.toString());
    } catch (e) {
      parsed = '';
    }

    switch (response.statusCode) {
      case 200:
        return parsed;
      case 400:
        final ApiError error =
            _getErrorFromJsonResponse(parsed as Map<String, dynamic>);
        throw BadRequestException(error.message);
      case 401:
        final ApiError error =
            _getErrorFromJsonResponse(parsed as Map<String, dynamic>);
        throw UnauthorizedException(error);
      case 403:
        final ApiError error =
            _getErrorFromJsonResponse(parsed as Map<String, dynamic>);
        throw ForbiddenException(error.message);
      case 449:
        final ApiError error =
            _getErrorFromJsonResponse(parsed as Map<String, dynamic>);
        throw RetryWithException(error.message);
      case 503:
        throw ServiceUnavailalbeException();
      case 500:
        throw FetchDataException(response.statusCode.toString());
      default:
        final ApiError error =
            _getErrorFromJsonResponse(parsed as Map<String, dynamic>);
        throw FetchDataException(error.message);
    }
  }

  Future<dynamic> get(
    String url, {
    Map<String, String> parameters = const <String, String>{},
    Map<String, String> headers = const <String, String>{},
    bool purePath = false,
    bool triggerLoader = false,
    String? apiVersion,
  }) async {
    Response response;
    Uri uri = _getApiUri(
      url,
      purePath: purePath,
      apiVersion: apiVersion,
      queryParameters: parameters,
    );

    try {
      response = await _httpClient.get(
        uri,
        headers: headers,
      );
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return _interceptedResponse(response);
  }

  Future<dynamic> post(
    String url, {
    required Object body,
    Map<String, String> headers = const <String, String>{},
    Map<String, String> parameters = const <String, String>{},
    bool purePath = false,
    bool triggerLoader = false,
    String? apiVersion,
  }) async {
    Response response;
    Uri uri = _getApiUri(
      url,
      purePath: purePath,
      apiVersion: apiVersion,
      queryParameters: parameters,
    );

    try {
      response = await _httpClient.post(
        uri,
        body: body,
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        }..addAll(headers),
      );
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return _interceptedResponse(response);
  }

  Future<dynamic> put(
    String url, {
    required Object body,
    Map<String, String> headers = const <String, String>{},
    Map<String, String> parameters = const <String, String>{},
    bool purePath = false,
    bool triggerLoader = false,
    String? apiVersion,
  }) async {
    Response response;
    Uri uri = _getApiUri(
      url,
      purePath: purePath,
      apiVersion: apiVersion,
      queryParameters: parameters,
    );

    try {
      response = await _httpClient.put(
        uri,
        body: body,
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        }..addAll(headers),
      );
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return _interceptedResponse(response);
  }

  Future<dynamic> delete(
    String url, {
    Object body = const <Object>{},
    Map<String, String> headers = const <String, String>{},
    bool purePath = false,
    bool triggerLoader = false,
    String? apiVersion,
  }) async {
    Response response;
    Uri uri = _getApiUri(
      url,
      purePath: purePath,
      apiVersion: apiVersion,
    );

    try {
      response = await _httpClient.delete(
        uri,
        body: body,
        headers: headers,
      );
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return _interceptedResponse(response);
  }

  void _logout() {
    _authenticationStorage.deleteToken();
    _navService.pushNamedAndRemoveUntil(AppRouter.login);
  }

  void _navigateMaintenance() {
    _navService.pushNamedAndRemoveUntil(AppRouter.loyaltyUnreachable);
  }
}
