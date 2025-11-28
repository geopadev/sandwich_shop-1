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

      // Verify total price is displayed (appears in both item card and footer)
      expect(find.textContaining('£'), findsWidgets);
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
      expect(find.text('£22.00'), findsWidgets);

      // Increase quantity
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify quantity and total price updated
      expect(find.text('Quantity: 3'), findsOneWidget);
      expect(find.text('£33.00'), findsWidgets);
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
      expect(find.text('£22.00'), findsWidgets);

      // Decrease quantity to 1
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      // Verify quantity and total price updated
      expect(find.text('Quantity: 1'), findsOneWidget);
      expect(find.text('£11.00'), findsWidgets);
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

      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Quantity: 3'), findsOneWidget);

      // Tap the delete (trash) icon
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      // Verify item is gone
      expect(find.text('Veggie Delight'), findsNothing);
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

    testWidgets('SnackBar appears with correct message when item removed',
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
      await tester.pump(const Duration(milliseconds: 100));

      // SnackBar should be visible with correct message
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Item removed from cart'), findsOneWidget);
    });
  });
}
