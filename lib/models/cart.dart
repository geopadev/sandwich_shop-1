import 'package:flutter/foundation.dart';
import 'sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CartItem {
  Sandwich sandwich;
  int quantity;

  CartItem(this.sandwich, this.quantity);

  CartItem.clone(CartItem other)
      : sandwich = other.sandwich,
        quantity = other.quantity;
}

class Cart extends ChangeNotifier {
  final List<CartItem> _items = [];

  // single-level undo snapshot
  List<CartItem>? _lastSnapshot;

  // Helper: identity rule (type, isFootlong, breadType)
  bool _sameSandwich(Sandwich a, Sandwich b) {
    return a.type == b.type &&
        a.isFootlong == b.isFootlong &&
        a.breadType == b.breadType;
  }

  // Returns a read-only copy of the items and their quantities
  Map<Sandwich, int> get items {
    final Map<Sandwich, int> map = {
      for (final ci in _items) ci.sandwich: ci.quantity
    };
    return Map.unmodifiable(map);
  }

  // Backwards-compatible add (keeps existing tests working)
  void add(Sandwich sandwich, {int quantity = 1}) =>
      addItem(sandwich, quantity: quantity);

  void addItem(Sandwich sandwich, {int quantity = 1}) {
    if (quantity <= 0) return;
    final index =
        _items.indexWhere((ci) => _sameSandwich(ci.sandwich, sandwich));
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(sandwich, quantity));
    }
    notifyListeners();
  }

  // Existing remove signature retained for compatibility.
  void remove(Sandwich sandwich, {int quantity = 1}) {
    removeItem(sandwich, quantity: quantity);
  }

  void removeItem(Sandwich sandwich, {int quantity = 1}) {
    final index =
        _items.indexWhere((ci) => _sameSandwich(ci.sandwich, sandwich));
    if (index < 0) return; // nothing to remove
    final currentQty = _items[index].quantity;
    if (quantity >= currentQty) {
      // destructive: record snapshot for undo
      _recordSnapshot();
      _items.removeAt(index);
    } else {
      _items[index].quantity = currentQty - quantity;
    }
    notifyListeners();
  }

  // Sets absolute quantity; if <=0 removes the line and records snapshot for undo.
  void updateQuantity(Sandwich sandwich, int quantity) {
    final index =
        _items.indexWhere((ci) => _sameSandwich(ci.sandwich, sandwich));
    if (index < 0) return;
    if (quantity > 0) {
      _items[index].quantity = quantity;
    } else {
      _recordSnapshot();
      _items.removeAt(index);
    }
    notifyListeners();
  }

  // Edit an existing item. If newItem matches another line, merge quantities.
  // If quantity is provided, use it; otherwise keep existing quantity.
  void editItem(Sandwich oldItem, Sandwich newItem, {int? quantity}) {
    final oldIndex =
        _items.indexWhere((ci) => _sameSandwich(ci.sandwich, oldItem));
    if (oldIndex < 0) return;
    final int desiredQty = quantity ?? _items[oldIndex].quantity;

    // find possible merge target excluding the old item itself
    final mergeIndex = _items.indexWhere(
        (ci) => _sameSandwich(ci.sandwich, newItem) && ci != _items[oldIndex]);

    if (mergeIndex >= 0) {
      // merge into existing line
      _items[mergeIndex].quantity += desiredQty;
      _items.removeAt(oldIndex);
    } else {
      // replace the sandwich on the existing cart item
      _items[oldIndex] = CartItem(newItem, desiredQty);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Pricing helpers
  double unitPriceFor(Sandwich sandwich) {
    final repo = PricingRepository();
    return repo.calculatePrice(quantity: 1, isFootlong: sandwich.isFootlong);
  }

  double subtotal() {
    final repo = PricingRepository();
    double total = 0.0;
    for (final ci in _items) {
      total += repo.calculatePrice(
          quantity: ci.quantity, isFootlong: ci.sandwich.isFootlong);
    }
    return total;
  }

  // Backwards-compatible getter
  double get totalPrice => subtotal();

  bool get isEmpty => _items.isEmpty;

  int get length => _items.length;

  int get countOfItems {
    int total = 0;
    for (final ci in _items) total += ci.quantity;
    return total;
  }

  int getQuantity(Sandwich sandwich) {
    final ci = _items.firstWhere(
      (ci) => _sameSandwich(ci.sandwich, sandwich),
      orElse: () => CartItem(sandwich, 0),
    );
    return ci.quantity;
  }

  // Undo support: single-level restore
  void _recordSnapshot() {
    _lastSnapshot = _items.map((ci) => CartItem.clone(ci)).toList();
  }

  void undoLast() {
    if (_lastSnapshot == null) return;
    _items
      ..clear()
      ..addAll(_lastSnapshot!.map((ci) => CartItem.clone(ci)));
    _lastSnapshot = null;
    notifyListeners();
  }
}
