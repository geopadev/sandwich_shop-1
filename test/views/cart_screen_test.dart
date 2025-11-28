import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/cart_screen.dart';

void main() {
  group('CartScreen', () {
    testWidgets('displays cart items and total price',
        (WidgetTester tester) async {
      final cart = Cart();
      cart.addItem(
        Sandwich(
            type: SandwichType.chickenTeriyaki,
            isFootlong: true,
            breadType: BreadType.white),
        quantity: 2,
      );
      cart.addItem(
        Sandwich(
            type: SandwichType.tunaMelt,
            isFootlong: false,
            breadType: BreadType.wheat),
        quantity: 1,
      );

      await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));

      // Verify sandwich names are displayed
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Tuna Melt'), findsOneWidget);

      // Verify quantities are displayed
      expect(find.text('Quantity: 2'), findsOneWidget);
      expect(find.text('Quantity: 1'), findsOneWidget);

      // Verify footlong label is displayed
      expect(find.text('Footlong'), findsOneWidget);

      // Verify total price is displayed
      expect(find.text('Total Price: £'), findsOneWidget);
    });

    testWidgets('updates quantity and total price when item is added',
        (WidgetTester tester) async {
      final cart = Cart();
      cart.addItem(
        Sandwich(
            type: SandwichType.chickenTeriyaki,
            isFootlong: true,
            breadType: BreadType.white),
        quantity: 2,
      );

      await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));

      // Initial quantity and total price
      expect(find.text('Quantity: 2'), findsOneWidget);
      expect(find.text('Total Price: £22.00'), findsOneWidget);

      // Increase quantity
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify quantity and total price updated
      expect(find.text('Quantity: 3'), findsOneWidget);
      expect(find.text('Total Price: £33.00'), findsOneWidget);
    });

    testWidgets('updates quantity and total price when item is removed',
        (WidgetTester tester) async {
      final cart = Cart();
      cart.addItem(
        Sandwich(
            type: SandwichType.chickenTeriyaki,
            isFootlong: true,
            breadType: BreadType.white),
        quantity: 2,
      );

      await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));

      // Initial quantity and total price
      expect(find.text('Quantity: 2'), findsOneWidget);
      expect(find.text('Total Price: £22.00'), findsOneWidget);

      // Decrease quantity to 1
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      // Verify quantity and total price updated
      expect(find.text('Quantity: 1'), findsOneWidget);
      expect(find.text('Total Price: £11.00'), findsOneWidget);
    });

    testWidgets('Remove button deletes item completely',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.addItem(sandwich, quantity: 3);

      await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));

      expect(find.text('Sandwich (Footlong)'), findsOneWidget);
      expect(find.text('Quantity: 3'), findsOneWidget);

      // Tap the delete (trash) icon
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      // Verify item is gone
      expect(find.text('Sandwich (Footlong)'), findsNothing);
      expect(cart.isEmpty, true);

      // Verify snackbar feedback
      expect(find.text('Item removed from cart'), findsOneWidget);
    });

    testWidgets('SnackBar appears when removing item with trash icon',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.addItem(sandwich, quantity: 2);

      await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));

      // Tap delete icon
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify SnackBar appears
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Item removed from cart'), findsOneWidget);
    });

    testWidgets('SnackBar appears when quantity reaches zero via decrement',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white,
      );
      cart.addItem(sandwich, quantity: 1);

      await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));

      expect(find.text('Quantity: 1'), findsOneWidget);

      // Decrement to zero (which removes the item)
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify SnackBar appears
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Item removed from cart'), findsOneWidget);

      // Verify item is removed
      expect(cart.isEmpty, true);
    });

    testWidgets('SnackBar dismisses after duration',
        (WidgetTester tester) async {
      final cart = Cart();
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.addItem(sandwich);

      await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));

      // Remove item
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      // SnackBar should be visible
      expect(find.byType(SnackBar), findsOneWidget);

      // Wait for SnackBar duration (1 second) + animation
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // SnackBar should be dismissed
      expect(find.byType(SnackBar), findsNothing);
    });
  });
}
