import 'package:cafe_app/core/auth/auth_session.dart';
import 'package:cafe_app/feature/auth/login.dart';
import 'package:cafe_app/navigation_bar.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Future<bool> _sessionFuture = AuthSession().isSignedIn();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _sessionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return snapshot.data == true
            ? const NavigationMenu()
            : const LoginScreen();
      },
    );
  }
}
