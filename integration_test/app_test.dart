import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sandwich_shop/main.dart' as app;
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite for testing
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Complete Order Flow - Happy Path', () {
    testWidgets('User can create and complete a full sandwich order',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify initial state on order screen
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsWidgets);

      // Verify cart is empty (look for "0" in cart indicator)
      final cartIndicator = find.descendant(
        of: find.byType(AppBar),
        matching: find.text('0'),
      );
      expect(cartIndicator, findsOneWidget);

      // Increase quantity to 2 (default sandwich is Veggie Delight, White bread, Footlong)
      final quantityAddButton =
          find.widgetWithIcon(IconButton, Icons.add).first;
      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();

      // Add to cart
      final addToCartButton = find.text('Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify cart updated to 2 items
      final updatedCartIndicator = find.descendant(
        of: find.byType(AppBar),
        matching: find.text('2'),
      );
      expect(updatedCartIndicator, findsOneWidget);

      // Navigate to cart
      final viewCartButton = find.text('View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Verify cart screen content (default is Veggie Delight, white bread, Footlong)
      expect(find.text('Cart'), findsAtLeastNWidgets(1));
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Footlong on white bread'), findsOneWidget);

      // Proceed to checkout
      final checkoutButton = find.text('Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      // Verify checkout screen
      expect(find.text('Checkout'), findsAtLeastNWidgets(1));
      expect(find.text('Order Summary'), findsOneWidget);

      // Confirm payment
      final confirmPaymentButton = find.text('Confirm Payment');
      await tester.tap(confirmPaymentButton);
      await tester.pumpAndSettle();

      // Wait for payment processing
      await tester.pump(const Duration(seconds: 3));

      // Verify order confirmation snackbar appeared
      expect(find.textContaining('confirmed'), findsOneWidget);

      // Should be back on order screen with empty cart
      expect(find.text('Sandwich Counter'), findsOneWidget);
      final emptyCartIndicator = find.descendant(
        of: find.byType(AppBar),
        matching: find.text('0'),
      );
      expect(emptyCartIndicator, findsOneWidget);
    });

    testWidgets('User can add multiple sandwiches to cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add first sandwich (default Veggie Delight)
      final addToCartButton = find.text('Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify cart has 1 item
      expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text('1'),
          ),
          findsOneWidget);

      // Add second sandwich (same configuration)
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify cart has 2 items
      expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text('2'),
          ),
          findsOneWidget);
    });
  });

  group('Profile Management', () {
    testWidgets('User can create profile and receive welcome message',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to profile
      final profileButton = find.text('Profile');
      await tester.ensureVisible(profileButton);
      await tester.tap(profileButton);
      await tester.pumpAndSettle();

      // Verify on profile screen
      expect(find.text('Profile'), findsAtLeastNWidgets(1));
      expect(find.text('Enter your details:'), findsOneWidget);

      // Enter profile data
      final nameField = find.byWidgetPredicate((widget) =>
          widget is TextField && widget.decoration?.labelText == 'Your Name');
      final locationField = find.byWidgetPredicate((widget) =>
          widget is TextField &&
          widget.decoration?.labelText == 'Preferred Location');

      await tester.enterText(nameField, 'John Doe');
      await tester.pumpAndSettle();

      await tester.enterText(locationField, 'London');
      await tester.pumpAndSettle();

      // Save profile
      final saveButton = find.text('Save Profile');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verify welcome message appears
      expect(find.textContaining('Welcome, John Doe!'), findsOneWidget);
      expect(find.textContaining('Ordering from London'), findsOneWidget);

      // Verify back on order screen
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('Profile validation - empty name shows error',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final profileButton = find.text('Profile');
      await tester.ensureVisible(profileButton);
      await tester.tap(profileButton);
      await tester.pumpAndSettle();

      // Enter only location, leave name empty
      final locationField = find.byWidgetPredicate((widget) =>
          widget is TextField &&
          widget.decoration?.labelText == 'Preferred Location');
      await tester.enterText(locationField, 'Manchester');
      await tester.pumpAndSettle();

      // Attempt to save
      final saveButton = find.text('Save Profile');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verify error message
      expect(find.text('Please fill in all fields'), findsOneWidget);

      // Verify still on profile screen
      expect(find.text('Profile'), findsAtLeastNWidgets(1));
    });

    testWidgets('Profile validation - empty location shows error',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final profileButton = find.text('Profile');
      await tester.ensureVisible(profileButton);
      await tester.tap(profileButton);
      await tester.pumpAndSettle();

      // Enter only name, leave location empty
      final nameField = find.byWidgetPredicate((widget) =>
          widget is TextField && widget.decoration?.labelText == 'Your Name');
      await tester.enterText(nameField, 'Jane Smith');
      await tester.pumpAndSettle();

      // Attempt to save
      final saveButton = find.text('Save Profile');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verify error message
      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('Profile validation - both fields empty shows error',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final profileButton = find.text('Profile');
      await tester.ensureVisible(profileButton);
      await tester.tap(profileButton);
      await tester.pumpAndSettle();

      // Don't enter anything, just try to save
      final saveButton = find.text('Save Profile');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verify error message
      expect(find.text('Please fill in all fields'), findsOneWidget);
    });
  });

  group('Cart Management', () {
    testWidgets('Cart persists when navigating to cart and back',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add item to cart
      final addToCartButton = find.text('Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Navigate to cart
      final viewCartButton = find.text('View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Verify cart indicator still shows 1 item on cart screen
      expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text('1'),
          ),
          findsOneWidget);

      // Go back to order screen using Back to Order button
      final backButton = find.text('Back to Order');
      await tester.ensureVisible(backButton);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Cart should still have 1 item on order screen
      expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text('1'),
          ),
          findsOneWidget);
    });

    testWidgets('Empty cart has no checkout button',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate directly to cart without adding anything
      final viewCartButton = find.text('View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Verify on cart screen
      expect(find.text('Cart'), findsAtLeastNWidgets(1));

      // Verify checkout button does not exist when cart is empty
      expect(find.text('Checkout'), findsNothing);

      // Verify cart total is £0.00
      expect(find.textContaining('£0.00'), findsOneWidget);
    });

    testWidgets('User can return to order screen from cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to cart
      final viewCartButton = find.text('View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart'), findsAtLeastNWidgets(1));

      // Use back to order button to return
      final backButton = find.text('Back to Order');
      await tester.ensureVisible(backButton);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify back on order screen
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });
  });

  group('Settings and Font Size', () {
    testWidgets('User can navigate to settings and change font size',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to settings
      final settingsButton = find.text('Settings');
      await tester.ensureVisible(settingsButton);
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      // Verify on settings screen
      expect(find.text('Settings'), findsAtLeastNWidgets(1));
      expect(find.text('Font Size'), findsOneWidget);

      // Find and drag slider to increase font size
      final slider = find.byType(Slider);
      expect(slider, findsOneWidget);

      // Drag slider to the right (increase font size)
      await tester.drag(slider, const Offset(100, 0));
      await tester.pumpAndSettle();

      // Verify font size changed (should show different value)
      expect(find.textContaining('px'), findsWidgets);

      // Navigate back using Back to Order button
      final backButton = find.text('Back to Order');
      await tester.ensureVisible(backButton);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify back on order screen
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });
  });

  group('Quantity Controls', () {
    testWidgets('User can increase quantity', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find quantity controls
      final addButton = find.widgetWithIcon(IconButton, Icons.add).first;

      // Increase quantity several times
      for (int i = 1; i < 5; i++) {
        await tester.tap(addButton);
        await tester.pumpAndSettle();
      }

      // Verify quantity increased to 5
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('User can decrease quantity to minimum',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Initially at quantity 1
      expect(find.text('1'), findsOneWidget);

      // Can decrease to 0
      final removeButton = find.widgetWithIcon(IconButton, Icons.remove).first;
      await tester.tap(removeButton);
      await tester.pumpAndSettle();

      // Now at quantity 0 - find the bold quantity text specifically
      final quantityText = find.byWidgetPredicate((widget) =>
          widget is Text &&
          widget.data == '0' &&
          widget.style?.fontWeight == FontWeight.bold);
      expect(quantityText, findsOneWidget);

      // Minus button should be disabled at 0
      final removeButtonWidget = tester.widget<IconButton>(removeButton);
      expect(removeButtonWidget.onPressed, isNull);
    });

    testWidgets('Quantity reflects in cart correctly',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Increase quantity to 5
      final addButton = find.widgetWithIcon(IconButton, Icons.add).first;
      for (int i = 1; i < 5; i++) {
        await tester.tap(addButton);
        await tester.pumpAndSettle();
      }

      // Add to cart
      final addToCartButton = find.text('Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify cart shows 5 items
      expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text('5'),
          ),
          findsOneWidget);
    });
  });

  group('Edge Cases and Complex Scenarios', () {
    testWidgets('Multiple additions of same sandwich configuration',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final addToCartButton = find.text('Add to Cart');

      // Add same sandwich twice
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Cart should show 2 items
      expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text('2'),
          ),
          findsOneWidget);
    });

    testWidgets('Checkout clears cart and resets to order screen',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add items
      final addToCartButton = find.text('Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Navigate to cart and checkout
      final viewCartButton = find.text('View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      final checkoutButton = find.text('Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      // Confirm payment
      final confirmPaymentButton = find.text('Confirm Payment');
      await tester.tap(confirmPaymentButton);
      await tester.pumpAndSettle();

      // Wait for payment processing
      await tester.pump(const Duration(seconds: 3));

      // Verify cart is empty
      expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text('0'),
          ),
          findsOneWidget);

      // Verify on order screen
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('Size toggle switches between footlong and six-inch',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find the size switch
      final sizeSwitch = find.byType(Switch);
      expect(sizeSwitch, findsOneWidget);

      // Initially should be footlong (true)
      Switch switchWidget = tester.widget<Switch>(sizeSwitch);
      expect(switchWidget.value, true);

      // Toggle to six-inch
      await tester.tap(sizeSwitch);
      await tester.pumpAndSettle();

      // Verify switched to six-inch (false)
      switchWidget = tester.widget<Switch>(sizeSwitch);
      expect(switchWidget.value, false);

      // Toggle back to footlong
      await tester.tap(sizeSwitch);
      await tester.pumpAndSettle();

      switchWidget = tester.widget<Switch>(sizeSwitch);
      expect(switchWidget.value, true);
    });
  });
}
