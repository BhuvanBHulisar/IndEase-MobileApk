import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api.dart';

class ApiService {
  static const String _tokenKey = 'indease_token';

  // ── TOKEN MANAGEMENT ──────────────────────────────────────
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ── HEADERS ───────────────────────────────────────────────
  static Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await getToken();
      if (token != null) {
        final backendToken = (token == 'demo-token-consumer-google')
            ? 'demo-token-consumer'
            : token;
        headers['Authorization'] = 'Bearer $backendToken';
      }
    }
    return headers;
  }

  // ── GET ───────────────────────────────────────────────────
  static Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final response = await http
        .get(uri, headers: await _headers())
        .timeout(const Duration(seconds: 5));
    return _handle(response);
  }

  // ── POST ──────────────────────────────────────────────────
  static Future<dynamic> post(String endpoint, Map<String, dynamic> body,
      {bool auth = true}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final response = await http
        .post(
          uri,
          headers: await _headers(auth: auth),
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 5));
    return _handle(response);
  }

  // ── PUT ───────────────────────────────────────────────────
  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final response = await http
        .put(
          uri,
          headers: await _headers(),
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 5));
    return _handle(response);
  }

  // ── PATCH ─────────────────────────────────────────────────
  static Future<dynamic> patch(String endpoint,
      [Map<String, dynamic>? body]) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final response = await http
        .patch(
          uri,
          headers: await _headers(),
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(const Duration(seconds: 5));
    return _handle(response);
  }

  // ── DELETE ────────────────────────────────────────────────
  static Future<dynamic> delete(String endpoint) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final response = await http
        .delete(uri, headers: await _headers())
        .timeout(const Duration(seconds: 5));
    return _handle(response);
  }

  // ── MULTIPART (file upload) ───────────────────────────────
  static Future<dynamic> uploadFile(
      String endpoint, File file, String fieldName,
      {Map<String, String>? fields}) async {
    final token = await getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final request = http.MultipartRequest('POST', uri);

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.files.add(await http.MultipartFile.fromPath(fieldName, file.path));

    if (fields != null) request.fields.addAll(fields);

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return _handle(response);
  }

  // ── RESPONSE HANDLER ──────────────────────────────────────
  static dynamic _handle(http.Response response) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      throw ApiException(
        'Server returned an invalid response (HTTP ${response.statusCode}).',
        response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }
    if (response.statusCode == 401) {
      clearToken();
      throw ApiException('Session expired. Please login again.', 401);
    }
    final message = body is Map
        ? (body['message'] ?? body['error'] ?? 'Something went wrong')
        : 'Something went wrong';
    throw ApiException(message, response.statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}
