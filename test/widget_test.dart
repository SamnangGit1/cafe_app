// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/feature/auth/login.dart';
import 'package:cafe_app/main.dart';

void main() {
  testWidgets('App boots and shows login flow for signed-out users', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // AuthGate starts in loading state while session is resolved.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Once resolved, signed-out users are routed to login.
    await tester.pump();
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
