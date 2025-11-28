import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('App', () {
    testWidgets('renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('OrderScreen - UI Components', () {
    testWidgets('shows initial UI with title and controls',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.byType(DropdownMenu<SandwichType>), findsOneWidget);
      expect(find.byType(DropdownMenu<BreadType>), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
      expect(find.text('Add to Cart'), findsOneWidget);
    });

    testWidgets('displays default quantity of 1', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      // Scroll down to make quantity visible
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);
    });
  });

  group('OrderScreen - Quantity Controls', () {
    testWidgets('increments quantity when + IconButton is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll to make quantity controls visible
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('decrements quantity when - IconButton is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll to make quantity controls visible
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // First increment to 2
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);

      // Then decrement back to 1
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('does not decrement below zero', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll to make quantity controls visible
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);

      // Decrement to 0
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('0'), findsOneWidget);

      // Try to decrement below 0
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('can increment quantity multiple times',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll to make quantity controls visible
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      for (int i = 0; i < 4; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();
      }

      expect(find.text('5'), findsOneWidget);
    });
  });

  group('OrderScreen - Size Switch', () {
    testWidgets('toggles size when Switch is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Check initial state shows footlong
      expect(find.text('Footlong'), findsOneWidget);
      expect(find.text('Six-inch'), findsOneWidget);

      // Toggle the switch
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Verify switch toggled (both labels still present, but state changed)
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isFalse);
    });
  });

  group('OrderScreen - Dropdown Menus', () {
    testWidgets('sandwich type dropdown is present',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(DropdownMenu<SandwichType>), findsOneWidget);
      // DropdownMenu creates multiple Text widgets with label, so check at least one
      expect(find.text('Sandwich Type'), findsWidgets);
    });

    testWidgets('bread type dropdown is present', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(DropdownMenu<BreadType>), findsOneWidget);
      // DropdownMenu creates multiple Text widgets with label, so check at least one
      expect(find.text('Bread Type'), findsWidgets);
    });
  });

  group('OrderScreen - Add to Cart Button', () {
    testWidgets('Add to Cart button is enabled when quantity > 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll to make button visible
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      final addToCartButton = find.text('Add to Cart');
      expect(addToCartButton, findsOneWidget);

      // Find the ElevatedButton ancestor
      final elevatedButton = find.ancestor(
        of: addToCartButton,
        matching: find.byType(ElevatedButton),
      );

      final buttonWidget = tester.widget<ElevatedButton>(elevatedButton);
      expect(buttonWidget.onPressed, isNotNull);
    });

    testWidgets('Add to Cart button is disabled when quantity is 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll to make controls visible
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Decrement to 0
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      // Scroll more to make button visible
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -100));
      await tester.pumpAndSettle();

      final addToCartButton = find.text('Add to Cart');
      final elevatedButton = find.ancestor(
        of: addToCartButton,
        matching: find.byType(ElevatedButton),
      );

      final buttonWidget = tester.widget<ElevatedButton>(elevatedButton);
      expect(buttonWidget.onPressed, isNull);
    });

    testWidgets('shows SnackBar when item is added to cart',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll to make button visible
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      // Tap Add to Cart
      await tester.tap(find.text('Add to Cart'));
      await tester.pump(); // Start animation
      await tester
          .pump(const Duration(milliseconds: 100)); // Let animation progress

      // Verify SnackBar appears with appropriate message
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Added 1 footlong Veggie Delight'),
          findsOneWidget);
    });

    testWidgets('SnackBar shows correct details for six-inch sandwich',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Toggle to six-inch
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Scroll to button
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      // Add to cart
      await tester.tap(find.text('Add to Cart'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify SnackBar shows six-inch
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('six-inch'), findsOneWidget);
    });

    testWidgets('SnackBar shows correct quantity in message',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll to quantity controls
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Increase quantity to 3
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Scroll to button
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -100));
      await tester.pumpAndSettle();

      // Add to cart
      await tester.tap(find.text('Add to Cart'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify SnackBar shows quantity 3
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Added 3'), findsOneWidget);
    });

    testWidgets('SnackBar appears and contains correct message',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll and add to cart
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to Cart'));
      await tester.pump();

      // SnackBar should be visible with correct message
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Added 1 footlong'), findsOneWidget);
      expect(find.textContaining('white bread'), findsOneWidget);
    });
  });

  group('OrderScreen - Cart Summary', () {
    testWidgets('shows initial empty cart summary',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll to bottom to see summary
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -500));
      await tester.pumpAndSettle();

      expect(find.text('Cart Summary'), findsOneWidget);
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Total Price: £0.00'), findsOneWidget);
    });

    testWidgets('updates summary when item is added and removed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll to button
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      // Add 1 item (default is 1 footlong @ £11.00)
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Scroll to bottom to see summary
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -200));
      await tester.pumpAndSettle();

      // Verify item is listed in a ListTile (Cart Summary)
      expect(
        find.descendant(
          of: find.byType(ListTile),
          matching: find.text('Veggie Delight'),
        ),
        findsOneWidget,
      );
      expect(find.text('1x Footlong'), findsOneWidget);
      expect(find.text('Total Price: £11.00'), findsOneWidget);

      // Find delete button and tap it
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Verify item is removed
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Total Price: £0.00'), findsOneWidget);
    });
  });

  group('StyledButton', () {
    testWidgets('renders with icon and label', (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.add,
        label: 'Test Add',
        backgroundColor: Colors.blue,
      );
      const testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );
      await tester.pumpWidget(testApp);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Test Add'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
