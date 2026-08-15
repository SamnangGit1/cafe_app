import 'dart:convert';
import 'package:cafe_app/core/api/api.dart';
import 'package:http/http.dart' as http;
class AuthService {
  Future<http.Response> post(String path, Map<String, dynamic> body, {String? token}) {
    return http.post(
      Api.uri(path),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> get(String path, {String? token}) {
    return http.get(
      Api.uri(path),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }
}