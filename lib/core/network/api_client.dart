import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

// ─── Domain error model ─────────────────────────────────────────────────────

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? body;

  const ApiException({required this.message, this.statusCode, this.body});

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => (statusCode ?? 0) >= 500;
  bool get isNetworkError => statusCode == null;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

// ─── Client ─────────────────────────────────────────────────────────────────

class ApiClient {
  final http.Client _http;
  final Duration _timeout;
  final int _maxRetries;

  ApiClient({
    http.Client? client,
    Duration timeout = const Duration(seconds: 20),
    int maxRetries = 1,
  }) : _http = client ?? http.Client(),
       _timeout = timeout,
       _maxRetries = maxRetries;

  // ── Public methods ────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> get(
    String url, {
    String? token,
    Map<String, String>? queryParams,
  }) async {
    final uri = _buildUri(url, queryParams);
    return _send(() => _http.get(uri, headers: _headers(token: token)));
  }

  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
    String? token,
  }) async => _send(
    () => _http.post(
      Uri.parse(url),
      headers: _jsonHeaders(token: token),
      body: jsonEncode(body ?? {}),
    ),
  );

  Future<Map<String, dynamic>> put(
    String url, {
    Map<String, dynamic>? body,
    String? token,
  }) async => _send(
    () => _http.put(
      Uri.parse(url),
      headers: _jsonHeaders(token: token),
      body: jsonEncode(body ?? {}),
    ),
  );

  Future<Map<String, dynamic>> patch(
    String url, {
    Map<String, dynamic>? body,
    String? token,
  }) async => _send(
    () => _http.patch(
      Uri.parse(url),
      headers: _jsonHeaders(token: token),
      body: jsonEncode(body ?? {}),
    ),
  );

  Future<Map<String, dynamic>> delete(
    String url, {
    String? token,
    Map<String, dynamic>? body,
  }) async => _send(
    () => _http.delete(
      Uri.parse(url),
      headers: _jsonHeaders(token: token),
      body: body != null ? jsonEncode(body) : null,
    ),
  );

  void dispose() => _http.close();

  // ── Internal helpers ──────────────────────────────────────────────────────

  Uri _buildUri(String url, Map<String, String>? params) {
    final base = Uri.parse(url);
    if (params == null || params.isEmpty) return base;
    return base.replace(queryParameters: {...base.queryParameters, ...params});
  }

  Map<String, String> _headers({String? token}) => {
    'Accept': 'application/json',
    if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
  };

  Map<String, String> _jsonHeaders({String? token}) => {
    ..._headers(token: token),
    'Content-Type': 'application/json',
  };

  Future<Map<String, dynamic>> _send(
    Future<http.Response> Function() request, {
    int attempt = 0,
  }) async {
    try {
      final response = await request().timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw const ApiException(message: 'No internet connection.');
    } on TimeoutException {
      if (attempt < _maxRetries) {
        await Future.delayed(Duration(milliseconds: 400 * (attempt + 1)));
        return _send(request, attempt: attempt + 1);
      }
      throw const ApiException(message: 'Request timed out. Please try again.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final Map<String, dynamic> decoded;

    try {
      decoded = response.body.trim().isEmpty
          ? {}
          : jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException(
        message: 'Invalid server response.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    final message =
        decoded['message'] as String? ??
        decoded['error'] as String? ??
        _defaultMessage(response.statusCode);

    throw ApiException(
      message: message,
      statusCode: response.statusCode,
      body: decoded,
    );
  }

  String _defaultMessage(int code) {
    return switch (code) {
      400 => 'Bad request.',
      401 => 'Session expired. Please log in again.',
      403 => 'You don\'t have permission to do that.',
      404 => 'Resource not found.',
      422 => 'Validation failed.',
      429 => 'Too many requests. Please slow down.',
      500 => 'Server error. Please try again later.',
      503 => 'Service unavailable.',
      _ => 'Something went wrong (HTTP $code).',
    };
  }
}
