import 'package:flutter/foundation.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

/// Represents one line item in the cart.
class CartItem {
  final Sandwich sandwich;
  int quantity;

  CartItem({required this.sandwich, this.quantity = 1});

  double unitPrice() {
    // Use PricingRepository to determine price per sandwich
    final pricing = PricingRepository();
    return pricing.calculatePrice(quantity: 1, isFootlong: sandwich.isFootlong);
  }

  double totalPrice() => unitPrice() * quantity;

  Map<String, dynamic> toJson() => {
        'type': sandwich.type.name,
        'isFootlong': sandwich.isFootlong,
        'breadType': sandwich.breadType.name,
        'quantity': quantity,
      };
}

/// Simple cart implementation with common operations used in food delivery apps.
///
/// - Add / remove items
/// - Update quantity
/// - Calculate totals, tax, delivery, discounts
///
/// This class extends `ChangeNotifier` so it can be used with Provider/ChangeNotifierProvider.
class Cart with ChangeNotifier {
  final List<CartItem> _items = [];

  // Optional global adjustments
  double taxRate = 0.0; // e.g. 0.07 for 7%
  double deliveryFee = 0.0;
  double discountAmount = 0.0; // flat discount
  double discountPercent = 0.0; // percentage discount (0.0 to 1.0)

  // Accessors
  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  int get uniqueItemsCount => _items.length;

  int get totalItemsCount => _items.fold(0, (s, e) => s + e.quantity);

  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice());

  double get discountValue {
    final fromPercent = subtotal * discountPercent;
    return (fromPercent + discountAmount).clamp(0.0, subtotal);
  }

  double totalBeforeTaxAndDelivery() =>
      (subtotal - discountValue).clamp(0.0, double.infinity);

  double totalTax() => totalBeforeTaxAndDelivery() * taxRate;

  double total() => totalBeforeTaxAndDelivery() + totalTax() + deliveryFee;

  // Helpers
  bool _sameSandwich(Sandwich a, Sandwich b) {
    return a.type == b.type &&
        a.isFootlong == b.isFootlong &&
        a.breadType == b.breadType;
  }

  CartItem? _findItem(Sandwich sandwich) {
    try {
      return _items.firstWhere((i) => _sameSandwich(i.sandwich, sandwich));
    } catch (_) {
      return null;
    }
  }

  // Operations
  void addItem(Sandwich sandwich, {int quantity = 1}) {
    if (quantity <= 0) return;
    final existing = _findItem(sandwich);
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _items.add(CartItem(sandwich: sandwich, quantity: quantity));
    }
    notifyListeners();
  }

  void removeItem(Sandwich sandwich) {
    _items.removeWhere((i) => _sameSandwich(i.sandwich, sandwich));
    notifyListeners();
  }

  void updateQuantity(Sandwich sandwich, int quantity) {
    if (quantity <= 0) {
      removeItem(sandwich);
      return;
    }
    final existing = _findItem(sandwich);
    if (existing != null) {
      existing.quantity = quantity;
      notifyListeners();
    }
  }

  void increment(Sandwich sandwich, {int by = 1}) =>
      addItem(sandwich, quantity: by);

  void decrement(Sandwich sandwich, {int by = 1}) {
    final existing = _findItem(sandwich);
    if (existing == null) return;
    existing.quantity -= by;
    if (existing.quantity <= 0) {
      removeItem(sandwich);
    } else {
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void applyFlatDiscount(double amount) {
    discountAmount = amount >= 0 ? amount : 0.0;
    notifyListeners();
  }

  void applyPercentDiscount(double percent) {
    discountPercent = percent.clamp(0.0, 1.0);
    notifyListeners();
  }

  Map<String, dynamic> toJson() => {
        'items': _items.map((i) => i.toJson()).toList(),
        'taxRate': taxRate,
        'deliveryFee': deliveryFee,
        'discountAmount': discountAmount,
        'discountPercent': discountPercent,
      };
}
