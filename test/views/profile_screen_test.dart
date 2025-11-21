import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/profile_screen.dart';

void main() {
  group('ProfileScreen Tests', () {
    testWidgets('renders all UI components correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

      // Check for title
      expect(find.text('My Profile'), findsOneWidget);

      // Check for input fields
      expect(find.widgetWithText(TextFormField, 'Full Name'), findsOneWidget);
      expect(
          find.widgetWithText(TextFormField, 'Email Address'), findsOneWidget);
      expect(
          find.widgetWithText(TextFormField, 'Phone Number'), findsOneWidget);

      // Check for Save button
      expect(
          find.widgetWithText(ElevatedButton, 'Save Details'), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

      // Tap Save button without entering text
      await tester.tap(find.text('Save Details'));
      await tester.pump();

      // Check for validation messages
      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your phone number'), findsOneWidget);
    });

    testWidgets('shows success snackbar when valid data is entered',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

      // Enter text into fields
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Full Name'), 'John Doe');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email Address'),
          'john@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Phone Number'), '1234567890');

      // Tap Save button
      await tester.tap(find.text('Save Details'));
      await tester.pump();

      // Check for success snackbar
      expect(find.text('Profile details saved (Mock)'), findsOneWidget);
    });
  });
}
