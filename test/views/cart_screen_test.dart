import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('CartScreen', () {
    testWidgets('displays empty cart message when cart is empty',
        (WidgetTester tester) async {
      final Cart emptyCart = Cart();
      final CartScreen cartScreen = CartScreen(cart: emptyCart);
      final MaterialApp app = MaterialApp(home: cartScreen);

      await tester.pumpWidget(app);

      expect(find.text('Cart View'), findsOneWidget);
      expect(find.text('Your cart is empty.'), findsOneWidget);
    });

    testWidgets('displays cart items with controls',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 2);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(home: cartScreen);

      await tester.pumpWidget(app);

      expect(find.text('Veggie Delight · Footlong'), findsOneWidget);
      expect(find.text('white · Unit: £11.00 · £22.00'), findsOneWidget);

      // Check for buttons
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('allows incrementing quantity', (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));

      expect(find.text('1'), findsOneWidget);
      expect(find.text('Total: £7.00'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('Total: £14.00'), findsOneWidget);
    });

    testWidgets('allows removing item via delete button',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle(); // SnackBar animation

      expect(find.text('Your cart is empty.'), findsOneWidget);
      expect(find.text('Removed 1 × Veggie Delight'), findsOneWidget);
    });

    testWidgets('allows editing item', (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false, // Six-inch
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      await tester.pumpWidget(MaterialApp(home: CartScreen(cart: cart)));

      // Open edit modal
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      expect(find.text('Edit Item'), findsOneWidget);

      // Change to Footlong
      await tester.tap(find.text('Six-inch')); // SwitchListTile
      await tester.pump();

      // Save
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();

      // Verify change
      expect(find.text('Veggie Delight · Footlong'), findsOneWidget);
      expect(find.text('Total: £11.00'), findsOneWidget);
    });

    testWidgets('back button navigates back', (WidgetTester tester) async {
      final Cart cart = Cart();
      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(home: cartScreen);

      await tester.pumpWidget(app);

      final Finder backButtonFinder =
          find.widgetWithText(ElevatedButton, 'Back to Order');
      expect(backButtonFinder, findsOneWidget);

      final ElevatedButton backButton =
          tester.widget<ElevatedButton>(backButtonFinder);
      expect(backButton.onPressed, isNotNull);
    });

    testWidgets('displays logo in app bar', (WidgetTester tester) async {
      final Cart cart = Cart();
      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(home: cartScreen);

      await tester.pumpWidget(app);

      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      final appBarImagesFinder = find.descendant(
        of: appBarFinder,
        matching: find.byType(Image),
      );
      expect(appBarImagesFinder, findsOneWidget);

      final Image logoImage = tester.widget(appBarImagesFinder);
      expect(
          (logoImage.image as AssetImage).assetName, 'assets/images/logo.png');
    });
  });
}
