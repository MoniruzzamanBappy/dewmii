import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(String url, {String? token}) async {
    final response = await _client.get(Uri.parse(url), headers: _getHeaders());

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final response = await _client.post(
      Uri.parse(url),
      headers: _jsonHeaders(token: token),
      body: jsonEncode(body ?? {}),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(
    String url, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final response = await _client.put(
      Uri.parse(url),
      headers: _jsonHeaders(token: token),
      body: jsonEncode(body ?? {}),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String url, {String? token}) async {
    final response = await _client.delete(
      Uri.parse(url),
      headers: _getHeaders(),
    );

    return _handleResponse(response);
  }

  Map<String, String> _getHeaders() {
    return {'Accept': 'application/json'};
  }

  Map<String, String> _jsonHeaders({String? token}) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final decodedBody = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decodedBody;
    }

    final message = decodedBody['message'] ?? 'Something went wrong';

    throw Exception(message);
  }
}
