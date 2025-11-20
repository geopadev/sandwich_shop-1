import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    late PricingRepository repository;

    setUp(() {
      repository = PricingRepository();
    });

    test('calculates correct price for zero six-inch sandwiches', () {
      final price = repository.calculatePrice(quantity: 0, size: 'six-inch');
      expect(price, 0.0);
    });

    test('calculates correct price for one six-inch sandwich', () {
      final price = repository.calculatePrice(quantity: 1, size: 'six-inch');
      expect(price, 7.0);
    });

    test('calculates correct price for multiple six-inch sandwiches', () {
      final price = repository.calculatePrice(quantity: 3, size: 'six-inch');
      expect(price, 21.0);
    });

    test('calculates correct price for zero footlong sandwiches', () {
      final price = repository.calculatePrice(quantity: 0, size: 'footlong');
      expect(price, 0.0);
    });

    test('calculates correct price for one footlong sandwich', () {
      final price = repository.calculatePrice(quantity: 1, size: 'footlong');
      expect(price, 11.0);
    });

    test('calculates correct price for multiple footlong sandwiches', () {
      final price = repository.calculatePrice(quantity: 5, size: 'footlong');
      expect(price, 55.0);
    });

    test('handles case-insensitive size input for footlong', () {
      final price = repository.calculatePrice(quantity: 2, size: 'Footlong');
      expect(price, 22.0);
    });

    test('defaults to six-inch price for invalid size', () {
      final price = repository.calculatePrice(quantity: 1, size: 'invalid');
      expect(price, 7.0);
    });
  });
}
