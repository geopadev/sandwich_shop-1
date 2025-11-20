import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('name returns correct display names for all types', () {
      final expectations = {
        SandwichType.veggieDelight: 'Veggie Delight',
        SandwichType.chickenTeriyaki: 'Chicken Teriyaki',
        SandwichType.tunaMelt: 'Tuna Melt',
        SandwichType.meatballMarinara: 'Meatball Marinara',
      };

      expectations.forEach((type, expectedName) {
        final sandwich =
            Sandwich(type: type, isFootlong: true, breadType: BreadType.white);
        expect(sandwich.name, expectedName);
      });
    });

    test('image returns correct path for footlong and six-inch', () {
      // Validate for all sandwich types and both sizes
      for (final type in SandwichType.values) {
        final footlong =
            Sandwich(type: type, isFootlong: true, breadType: BreadType.wheat);
        final sixInch =
            Sandwich(type: type, isFootlong: false, breadType: BreadType.wheat);

        final typeString = type.name; // matches how the model builds the path
        expect(footlong.image, 'assets/images/${typeString}_footlong.png');
        expect(sixInch.image, 'assets/images/${typeString}_six_inch.png');
      }
    });

    test('breadType is stored and accessible', () {
      final sandwich = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: false,
          breadType: BreadType.wholemeal);
      expect(sandwich.breadType, BreadType.wholemeal);
    });
  });
}
