import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  group('OrderScreen widget flows', () {
    testWidgets(
        'live preview, add to cart, increment, decrement->remove and UNDO',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Live preview initially (default: six-inch, quantity 1 -> £7.00)
      expect(find.text('Unit: £7.00 · Total: £7.00'), findsOneWidget);

      // Add to cart
      final addButton = find.text('Add to cart');
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pump(); // show SnackBar
      await tester.pumpAndSettle();

      // Cart should contain the sandwich line and subtotal £7.00
      expect(find.text('Veggie Delight · Six-inch'), findsOneWidget);
      expect(
          find.text('£7.00'), findsWidgets); // unit/total/subtotal occurrences

      // Increment quantity (press the cart line "+" button)
      final cartAddIcon = find.byIcon(Icons.add).first;
      await tester.tap(cartAddIcon);
      await tester.pumpAndSettle();

      // Expect quantity '2' displayed and subtotal updated to £14.00
      expect(find.text('2'), findsOneWidget);
      expect(find.text('£14.00'), findsOneWidget);

      // Decrement once -> quantity should become 1
      final cartRemoveIcon = find.byIcon(Icons.remove).first;
      await tester.tap(cartRemoveIcon);
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);
      expect(find.text('£7.00'), findsWidgets);

      // Decrement again -> line removed and SnackBar shown
      await tester.tap(cartRemoveIcon);
      await tester.pump(); // start SnackBar animation
      await tester.pumpAndSettle();
      expect(find.text('Your cart is empty.'), findsOneWidget);
      expect(find.textContaining('Removed'), findsOneWidget);

      // Tap UNDO on the SnackBar to restore the removed line
      final undoButton = find.text('UNDO');
      expect(undoButton, findsOneWidget);
      await tester.tap(undoButton);
      await tester.pumpAndSettle();

      // Item should be restored with quantity 1 and subtotal £7.00
      expect(find.text('Veggie Delight · Six-inch'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('£7.00'), findsWidgets);
    });
  });
}
