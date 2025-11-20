# 🥪 Sandwich Shop

A Flutter application for managing sandwich orders with an intuitive interface. This app allows users to customize their sandwich orders by selecting size, bread type, quantity, and adding special notes.

## 📋 Table of Contents

- [Features](#-features)
- [Screenshots](#-screenshots)
- [Installation and Setup](#-installation-and-setup)
- [Usage Instructions](#-usage-instructions)
- [Running Tests](#-running-tests)
- [Project Structure](#-project-structure)
- [Technologies Used](#-technologies-used)
- [Known Issues and Limitations](#-known-issues-and-limitations)
- [Future Improvements](#-future-improvements)
- [Contact Information](#-contact-information)

## ✨ Features

- **Sandwich Quantity Management**: Add or remove sandwiches with increment/decrement controls
- **Size Selection**: Choose between six-inch (£7) or footlong (£11) sandwiches using an intuitive toggle switch
- **Bread Type Selection**: Select from three bread types (white, wheat, wholemeal) via dropdown menu
- **Toasted Option**: Toggle between untoasted and toasted sandwiches
- **Order Notes**: Add custom notes for special instructions (e.g., "no onions", "extra mayo")
- **Real-Time Price Calculation**: Automatically calculates and displays total order price
- **Visual Feedback**: Real-time display of order details with sandwich emojis 🥪
- **Order Limits**: Configurable maximum order quantity to prevent over-ordering
- **Responsive UI**: Clean, Material Design-based interface with styled buttons

## 📱 Screenshots

*Note: Screenshots can be found in the `images/` directory, including:*
- Flutter project structure
- Device selector
- Hot reload functionality
- Source control integration

## 🚀 Installation and Setup

### Prerequisites

Before you begin, ensure you have the following installed:

- **Operating System**: Windows, macOS, or Linux
- **Flutter SDK**: Version 2.17.0 or higher
- **Dart SDK**: Comes bundled with Flutter
- **IDE**: Visual Studio Code (recommended) or Android Studio
- **Git**: For cloning the repository

### Step-by-Step Installation

1. **Install Flutter**

   Follow the official Flutter installation guide for your operating system:
   - [Flutter Installation Guide](https://docs.flutter.dev/get-started/install)

2. **Verify Flutter Installation**

   ```bash
   flutter doctor
   ```

   Ensure all checks pass or resolve any issues indicated.

3. **Clone the Repository**

   ```bash
   git clone https://github.com/geopadev/sandwich_shop-1.git
   cd sandwich_shop-1/sandwich_shop
   ```

4. **Install Dependencies**

   ```bash
   flutter pub get
   ```

5. **Run the Application**

   Connect a device or start an emulator, then run:

   ```bash
   flutter run
   ```

   Or in Visual Studio Code:
   - Press `F5` or click the "Run and Debug" icon
   - Select your target device from the device selector

## 📖 Usage Instructions

### Main Features

1. **Adding Sandwiches**
   - Click the green "Add" button to increase the sandwich count
   - Maximum quantity is limited to 5 sandwiches per order

2. **Removing Sandwiches**
   - Click the red "Remove" button to decrease the sandwich count
   - Minimum quantity is 0 (cannot go below zero)

3. **Selecting Sandwich Size**
   - Use the toggle switch to choose between "six-inch" (£7) and "footlong" (£11)
   - Default selection is "footlong"
   - Price updates automatically based on size selection

4. **Toasted Option**
   - Use the toggle switch to choose between "untoasted" and "toasted"
   - Default selection is "untoasted"

5. **Choosing Bread Type**
   - Click the dropdown menu to select bread type
   - Options: white, wheat, wholemeal
   - Default selection is "white"

6. **Adding Order Notes**
   - Type in the text field to add special instructions
   - Examples: "no onions", "extra mayo"
   - Notes are displayed in real-time below the order summary

7. **Viewing Total Price**
   - Total price is calculated automatically and displayed in green
   - Updates in real-time as quantity or size changes
   - Formatted as £X.XX (e.g., £35.00 for 5 six-inch sandwiches)

### User Flow

```
Launch App → Select Sandwich Size → Choose Toasted Option → 
Choose Bread Type → Add Quantity → Enter Notes (optional) → 
View Order Summary & Total Price
```

## 🧪 Running Tests

The project includes comprehensive unit and widget tests.

### Run All Tests

```bash
flutter test
```

### Run Specific Test Files

```bash
# Test the OrderRepository
flutter test test/repositories/order_repository_test.dart

# Test the PricingRepository
flutter test test/repositories/pricing_repository_test.dart

# Test the UI widgets
flutter test test/views/widget_test.dart
```

### Test Coverage

The test suite covers:
- ✅ Repository logic (increment/decrement, boundaries)
- ✅ Pricing calculations (six-inch, footlong, multiple quantities)
- ✅ Widget rendering and interactions
- ✅ User input handling (buttons, switches, dropdowns, text fields)
- ✅ Edge cases (max/min quantities, empty states, invalid inputs)

### View Test Coverage Report

```bash
flutter test --coverage
```

## 📁 Project Structure

```
sandwich_shop/
├── lib/
│   ├── main.dart                    # Main application entry point and UI
│   ├── repositories/
│   │   ├── order_repository.dart    # Business logic for order management
│   │   └── pricing_repository.dart  # Business logic for price calculations
│   └── views/
│       └── app_styles.dart          # Centralized text styles
├── test/
│   ├── repositories/
│   │   ├── order_repository_test.dart   # Repository unit tests
│   │   └── pricing_repository_test.dart # Pricing logic unit tests
│   └── views/
│       └── widget_test.dart         # Widget and integration tests
├── images/                          # Screenshot assets
├── pubspec.yaml                     # Project dependencies and metadata
├── analysis_options.yaml            # Dart linting rules
└── README.md                        # Project documentation
```

### Key Files and Their Purposes

- **`main.dart`**: Contains all UI components including:
  - `App`: Root application widget
  - `OrderScreen`: Main screen with order interface
  - `OrderItemDisplay`: Displays order summary
  - `StyledButton`: Reusable button component
  
- **`order_repository.dart`**: Handles order state management with:
  - Quantity tracking
  - Increment/decrement operations
  - Boundary validation (min/max limits)

- **`pricing_repository.dart`**: Handles pricing logic with:
  - Price calculation based on quantity and size
  - Six-inch pricing (£7 per sandwich)
  - Footlong pricing (£11 per sandwich)

- **`app_styles.dart`**: Defines consistent text styles across the app

## 🛠 Technologies Used

### Framework and Language

- **Flutter**: Version 2.17.0+ (Cross-platform UI framework)
- **Dart**: Primary programming language

### Key Dependencies

- **flutter**: Core Flutter SDK
- **cupertino_icons**: iOS-style icons (^1.0.0)

### Development Dependencies

- **flutter_test**: Testing framework
- **flutter_lints**: Linting rules for code quality (^2.0.0)

### Development Tools

- **Visual Studio Code**: Primary IDE
- **Flutter DevTools**: Debugging and performance analysis
- **Git**: Version control
- **GitHub**: Repository hosting

### Architecture Pattern

- **Repository Pattern**: Separates business logic from UI
- **StatefulWidget**: For reactive UI components
- **Provider Pattern**: Implicit through StatefulWidget state management

## ⚠️ Known Issues and Limitations

### Current Limitations

1. **Local State Only**: Orders are not persisted between app sessions
2. **No Backend Integration**: No API calls or database storage
3. **Single Order**: Cannot manage multiple orders simultaneously
4. **Fixed Pricing**: Prices are hardcoded (£7 for six-inch, £11 for footlong)
5. **Limited Customization**: Fixed options for bread, size, and toasting only

### Minor Issues

- No confirmation dialog when removing items
- Notes field has no character limit
- No form validation for special characters in notes

## 🔮 Future Improvements

### Planned Features

- [ ] **Order Persistence**: Save orders locally using SharedPreferences or SQLite
- [ ] **Order History**: View past orders
- [ ] **Dynamic Pricing**: Admin interface to update prices
- [ ] **Toppings Selection**: Add checkboxes for vegetables, sauces, and proteins with individual pricing
- [ ] **Multiple Orders**: Manage a cart with multiple sandwich orders
- [ ] **Order Submission**: Backend integration for submitting orders
- [ ] **User Authentication**: Login/signup functionality
- [ ] **Payment Integration**: Add payment gateway
- [ ] **Dark Mode**: Theme switching capability
- [ ] **Localization**: Multi-language support
- [ ] **Discount Codes**: Apply promotional codes to orders

### Technical Improvements

- [ ] Implement state management solution (Provider, Riverpod, or Bloc)
- [ ] Add integration tests
- [ ] Implement CI/CD pipeline
- [ ] Add error handling and user feedback (snackbars, dialogs)
- [ ] Improve accessibility features
- [ ] Add animations and transitions

## 👨‍💻 Contact Information

**Developer**: Georg (geopadev)

- **GitHub**: [@geopadev](https://github.com/geopadev)
- **Repository**: [sandwich_shop-1](https://github.com/geopadev/sandwich_shop-1)
- **Branch**: w4

---

## 📝 License

This project is part of a Level 5 Programming coursework (Worksheet 2).

## 🙏 Acknowledgments

- Flutter team for the excellent framework and documentation
- Material Design for UI guidelines
- Flutter community for helpful resources and packages

---

**Made with ❤️ and Flutter**
