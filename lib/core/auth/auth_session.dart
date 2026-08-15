import 'package:shared_preferences/shared_preferences.dart';

class AuthSession {
  static const _signedInKey = 'signed_in';

  Future<bool> isSignedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_signedInKey) ?? false;
  }

  Future<void> save() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_signedInKey, true);
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_signedInKey);
  }
}
