import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/cart_screen.dart';

void main() {
  group('CartScreen Tests', () {
    testWidgets('Displays empty state when cart is empty',
        (WidgetTester tester) async {
      final cart = Cart();
      await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));

      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
      expect(find.text('Back to Order'), findsOneWidget);
    });

    testWidgets('Displays items and allows quantity adjustment',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(isFootlong: false);
      cart.add(sandwich);

      await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));

      expect(find.text('Sandwich (6-inch)'), findsOneWidget);
      expect(find.text('Quantity: 1'), findsOneWidget);

      // Test Increment
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('Quantity: 2'), findsOneWidget);
      expect(cart.getQuantity(sandwich), 2);

      // Test Decrement
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('Quantity: 1'), findsOneWidget);
      expect(cart.getQuantity(sandwich), 1);
    });

    testWidgets('Remove button deletes item completely',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(isFootlong: true);
      cart.add(sandwich, quantity: 3);

      await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));

      expect(find.text('Sandwich (Footlong)'), findsOneWidget);
      expect(find.text('Quantity: 3'), findsOneWidget);

      // Tap the delete (trash) icon
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      // Verify item is gone
      expect(find.text('Sandwich (Footlong)'), findsNothing);
      expect(cart.items.isEmpty, true);

      // Verify snackbar feedback
      expect(find.text('Item removed from cart'), findsOneWidget);
    });
  });
}
