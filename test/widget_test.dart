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
