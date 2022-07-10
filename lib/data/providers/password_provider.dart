import 'dart:convert' show json;

import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:http/http.dart';
import 'package:http/src/response.dart';
import 'package:http/io_client.dart';

class PasswordProvider with ChangeNotifier {
  IOClient _httpClient = IOClient();

  /// Guessable Passwords deny list includes top 100k pwned passwords.
  /// https://www.ncsc.gov.uk/blog-post/passwords-passwords-everywhere
  Future<List<String>> getGuessablePasswords() async {
    try {
      final Uri uri = Uri.parse(
        dotenv.env['GUESABLE_PASSWORDS_DICTIONARY_URL']!,
      );

      final Response response = await _httpClient.get(
        uri,
        headers: <String, String>{'content-type': 'application/json'},
      );

      List<String> data =
          (json.decode(response.body) as List<dynamic>).cast<String>();

      return data;
    } catch (e) {
      throw e;
    }
  }

  /// Pwned Passwords overview.
  /// https://haveibeenpwned.com/API/v3#SearchingPwnedPasswordsByRange
  Future<List<String>> getPwnedPasswordsByHash(String sha1) async {
    try {
      final Uri uri = Uri.https(
        dotenv.env['API_PWNED_PASSWORDS']!,
        'range/$sha1',
      );

      final Response response = await _httpClient.get(
        uri,
        headers: <String, String>{
          'content-type': 'text/plain',
          'Add-Padding': 'true',
        },
      );

      List<String> data = response.body
          .trim()
          .split('\n')
          .map((String e) => e.split(':')[0].toString().toLowerCase())
          .toList();

      return data;
    } catch (e) {
      throw e;
    }
  }
}
