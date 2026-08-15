import 'dart:convert';
import 'package:cafe_app/core/api/api.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthApiException implements Exception {
  const AuthApiException(this.message);
  final String message;
}


class AuthApi {
  AuthApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  String get _baseUrl => Api.baseUrl;

  Future<Map<String, dynamic>> login({required String email, required String password}) =>
      _post('/auth/login', {'Email': email, 'Password': password});

  Future<void> sendOtp(String phone) async {
    await _post('/auth/send-otp', {'Phone': phone});
  }

  Future<void> verifyOtp({required String phone, required String otp}) async {
    await _post('/auth/verify-otp', {'Phone': phone, 'OTP': otp});
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) => _post('/auth/register', {
    'Username': name,
    'Email': email,
    'Phone': phone,
    'Password': password,
  });

  Future<Map<String, dynamic>> google({required String idToken, String? phone, String? name}) =>
      _post('/auth/google', {
        'IDToken': idToken,
        'Phone': ?phone,
        'Name': ?name,
      });

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl$path'),
        headers: const {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 15));
      final data = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = data is Map<String, dynamic> ? data['message'] : null;
        throw AuthApiException(message is String ? message : 'Request failed. Please try again.');
      }
      return data is Map<String, dynamic> ? data : <String, dynamic>{};
    } on AuthApiException {
      rethrow;
    } catch (e) {
      debugPrint('[AuthApi] Network error: $e');
      throw const AuthApiException('Cannot reach the server. Check the API address and connection.');
    }
  }
}
