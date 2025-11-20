# Sandwich Shop

A Flutter application for ordering customizable sandwiches with real-time pricing and cart management.

## Features

- **Sandwich Customization**
  - Choose from 4 sandwich types: Veggie Delight, Chicken Teriyaki, Tuna Melt, and Meatball Marinara
  - Select size: Six-inch (£7.00) or Footlong (£11.00)
  - Pick bread type: White, Wheat, or Wholemeal
  - Adjust quantity with intuitive +/- controls

- **Real-time Price Display**
  - See the price update instantly as you customize your order
  - Price shown before adding items to cart

- **Smart Cart Management**
  - View cart summary directly on the main screen
  - See total items and total price
  - Remove items from cart with one tap
  - Automatic price calculations with support for tax, delivery fees, and discounts

- **User-Friendly Interface**
  - Dynamic image display based on sandwich selection
  - SnackBar notifications when items are added
  - Clean, Material Design UI

## Installation

### Prerequisites
- Flutter SDK 2.17.0 or higher
- Dart SDK
- An IDE (VS Code or Android Studio recommended)

### Steps

1. Clone the repository:
```bash
git clone https://github.com/geopadev/sandwich_shop-1.git
cd sandwich_shop
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Usage

1. **Select your sandwich**: Use the dropdown menu to choose your preferred sandwich type
2. **Choose size**: Toggle the switch between Six-inch and Footlong
3. **Pick bread**: Select your bread type from the dropdown
4. **Set quantity**: Use the +/- buttons to adjust the quantity
5. **Check price**: The current price is displayed below the quantity controls
6. **Add to cart**: Tap "Add to Cart" to add the item
7. **View cart**: Scroll down to see your cart summary with all items and total price
8. **Remove items**: Tap the delete icon next to any item to remove it from the cart

## Running Tests

Run all tests:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

The project includes comprehensive tests:
- Unit tests for models (Cart, Sandwich)
- Unit tests for repositories (PricingRepository)
- Widget tests for UI components and user interactions

## Project Structure

```
lib/
├── main.dart                    # Main app entry point and UI
├── models/
│   ├── cart.dart               # Cart and CartItem models
│   └── sandwich.dart           # Sandwich model with enums
├── repositories/
│   └── pricing_repository.dart # Pricing logic
└── views/
    └── app_styles.dart         # Text styles and theming

test/
├── widget_test.dart            # Widget tests for UI
├── models/
│   ├── cart_test.dart         # Unit tests for Cart
│   └── sandwich_test.dart     # Unit tests for Sandwich
└── repositories/
    └── pricing_repository_test.dart # Unit tests for pricing
```

## Technologies Used

- **Flutter** - UI framework
- **Dart** - Programming language
- **Material Design** - Design system
- **Provider Pattern** - State management (Cart uses ChangeNotifier)
- **Repository Pattern** - Business logic separation

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is part of a programming course assignment.

## Contact

Repository: [sandwich_shop-1](https://github.com/geopadev/sandwich_shop-1)
