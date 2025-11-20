import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('Cart model', () {
    late Cart cart;
    late PricingRepository pricing;

    setUp(() {
      cart = Cart();
      pricing = PricingRepository();
    });

    test('addItem and subtotal use PricingRepository for price', () {
      final s = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: true,
          breadType: BreadType.white);
      cart.addItem(s, quantity: 2);

      expect(cart.totalItemsCount, 2);
      // expected subtotal uses PricingRepository single-item price
      final expected = pricing.calculatePrice(quantity: 2, isFootlong: true);
      expect(cart.subtotal, expected);
    });

    test('adding same sandwich merges quantities', () {
      final s = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: false,
          breadType: BreadType.wheat);
      cart.addItem(s);
      cart.addItem(s);

      expect(cart.uniqueItemsCount, 1);
      expect(cart.totalItemsCount, 2);
    });

    test('different sandwiches create separate line items', () {
      final a = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.white);
      final b = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white);
      cart.addItem(a);
      cart.addItem(b);

      expect(cart.uniqueItemsCount, 2);
    });

    test('updateQuantity removes item when set to zero', () {
      final s = Sandwich(
          type: SandwichType.meatballMarinara,
          isFootlong: true,
          breadType: BreadType.wholemeal);
      cart.addItem(s, quantity: 3);
      expect(cart.totalItemsCount, 3);

      cart.updateQuantity(s, 0);
      expect(cart.totalItemsCount, 0);
      expect(cart.isEmpty, true);
    });

    test('increment and decrement adjust quantities and remove when zero', () {
      final s = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: false,
          breadType: BreadType.wheat);
      cart.addItem(s, quantity: 2);
      expect(cart.totalItemsCount, 2);

      cart.increment(s, by: 3);
      expect(cart.totalItemsCount, 5);

      cart.decrement(s, by: 4);
      expect(cart.totalItemsCount, 1);

      cart.decrement(s, by: 1);
      expect(cart.isEmpty, true);
    });

    test('subtotal, discounts, tax, delivery and total calculation', () {
      final s1 = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: true,
          breadType: BreadType.white);
      final s2 = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.wheat);

      cart.addItem(s1, quantity: 2); // 2 * 11 = 22
      cart.addItem(s2, quantity: 3); // 3 * 7 = 21

      expect(
          cart.subtotal,
          pricing.calculatePrice(quantity: 2, isFootlong: true) +
              pricing.calculatePrice(quantity: 3, isFootlong: false));

      cart.applyFlatDiscount(5.0); // flat 5
      cart.applyPercentDiscount(0.1); // 10%
      cart.taxRate = 0.05; // 5%
      cart.deliveryFee = 3.0;

      // calculate expected values via the same logic
      final rawSubtotal = cart.subtotal;
      final percentDiscount = rawSubtotal * 0.1;
      final discountValue = (percentDiscount + 5.0).clamp(0.0, rawSubtotal);
      final beforeTax =
          (rawSubtotal - discountValue).clamp(0.0, double.infinity);
      final tax = beforeTax * 0.05;
      final expectedTotal = beforeTax + tax + 3.0;

      expect(cart.total(), expectedTotal);
    });

    test('clear empties the cart', () {
      final s = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.white);
      cart.addItem(s, quantity: 2);
      expect(cart.isEmpty, false);
      cart.clear();
      expect(cart.isEmpty, true);
    });
  });
}
