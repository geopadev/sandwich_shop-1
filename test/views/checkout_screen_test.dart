import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';

void main() {
  testWidgets('CheckoutScreen initializes correctly with a cart',
      (WidgetTester tester) async {
    final cart = Cart();

    // Pump the CheckoutScreen to ensure it renders without errors
    await tester.pumpWidget(MaterialApp(
      home: CheckoutScreen(cart: cart),
    ));

    // Verify the screen is present
    expect(find.byType(CheckoutScreen), findsOneWidget);
  });
}
