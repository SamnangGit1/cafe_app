import 'package:flutter/foundation.dart';

class Api {
  Api._();

  static const String _envUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_envUrl.isNotEmpty && !_envUrl.toLowerCase().contains('your_local_ip')) {
      return _envUrl;
    }
    if (kIsWeb) return 'http://localhost:3000';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:3000';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      default:
        return 'http://localhost:3000';
    }
  }

  static Uri uri(String path) => Uri.parse('$baseUrl$path');
}


