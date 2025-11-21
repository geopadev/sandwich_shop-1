# Prompt for LLM: Implement cart modification UX & logic for Sandwich Shop app

You are an expert Flutter developer LLM. Goal: implement cart modification features and UI updates in the existing Sandwich Shop app. Use the project structure and files in the repository (lib/models, lib/views, repositories) and follow these constraints.

---

## Context (do not change)
- Models:
  - `Sandwich(type: SandwichType, isFootlong: bool, breadType: BreadType)`
  - `Cart` exists with basic `add`, `remove`, `clear`, and total price calculation.
- Repository:
  - `PricingRepository.calculatePrice({required int quantity, required bool isFootlong})` — the single source of truth for pricing (price depends only on size and quantity; not on type or bread).
- UI:
  - Two screens: OrderScreen (select sandwich and add to cart) and CartScreen (view cart). For this task, keep everything on the main OrderScreen (no separate cart page yet).

---

## High-level requirements
1. Allow users to modify cart items from the main UI (no separate cart page required for now).
2. Support operations:
   - Change quantity of an existing cart line (increment/decrement).
   - Remove an item entirely.
   - Edit item options (size or bread) for an item; merge or replace lines as appropriate.
   - Show per-item unit price and line total in the cart summary.
   - Show live price preview on OrderScreen while configuring before adding to cart.
   - Provide UNDO via SnackBar for removes (and optionally for quantity-changes that remove an item).
3. All price calculations must call `PricingRepository.calculatePrice(...)` and never compute prices locally.
4. Minimize UI changes: restrict changes to `lib/models/cart.dart` and `lib/views/order_screen.dart` (and add tests). Use `ChangeNotifier` for Cart.

---

## Feature specs (for each feature include description, expected behavior, state/model changes, UI suggestions, edge cases, tests)

### 1) Change quantity (increment/decrement)
- Description: Allow user to increase/decrease quantity of a cart item using ± controls.
- Behavior:
  - Tap "+" → quantity +1; line total = unitPrice * quantity; subtotal updates.
  - Tap "−" → if quantity > 1 decrement; if quantity==1 and "−" tapped → remove line (or show confirm dialog; see config).
- Model:
  - Add `Cart.updateQuantity(Sandwich sandwich, int quantity)` which notifies listeners.
- UI:
  - Per-item row: IconButton(Icons.remove), Text(qty), IconButton(Icons.add).
  - Disable "−" when quantity is 0 or handle removal flow.
- Edge cases:
  - Quantity >= 0 (no negatives); enforce `maxQuantity` if present.
- Tests:
  - Unit: quantity updates and subtotal recalculated.
  - Widget: tapping "+" / "−" updates UI and totals.

### 2) Remove item (delete)
- Description: Remove a cart line entirely.
- Behavior:
  - Tap delete → optional confirm → remove item → update subtotal → show SnackBar "Removed X" with UNDO.
- Model:
  - `Cart.removeItem(Sandwich sandwich)` and maintain last-removed snapshot for undo.
  - `Cart.undoLast()` restores last removed item.
- UI:
  - Per-item delete IconButton; optional Dismissible swipe.
- Tests:
  - Unit: remove updates items and subtotal; undo restores.
  - Widget: delete via UI, SnackBar undo restores.

### 3) Edit item options (size/bread)
- Description: Edit an existing cart line's size or bread.
- Behavior:
  - Open an editor (modal/bottom sheet) pre-filled with item options.
  - Save: if new options match an existing line, merge quantities; else update the line.
- Model:
  - `Cart.editItem(Sandwich oldItem, Sandwich newItem, {int? quantity})` (merging logic).
- UI:
  - `showModalBottomSheet` with dropdowns/switch/qty controls; Save/Cancel.
- Tests:
  - Unit: edit replaces/merges correctly.
  - Widget: editing updates summary and totals.

### 4) Show item price while selecting (live preview)
- Description: While configuring the sandwich on OrderScreen, show current unit price and total for selected quantity.
- Behavior:
  - Use `PricingRepository.calculatePrice(quantity: 1, isFootlong: bool)` for unit price.
  - Display "Unit: £X.XX · Total: £Y.YY" and update on size/quantity changes.
- Tests:
  - Widget: toggling size or quantity updates displayed prices.

### 5) UNDO support via SnackBar
- Description: After remove (or destructive quantity-change) show SnackBar with UNDO.
- Behavior:
  - Undo restores previous state; Undo window 3–5s.
- Model:
  - Keep minimal undo stack (single-level snapshot is sufficient).
- Tests:
  - Unit/widget: remove followed by UNDO restores items and totals.

---

## Acceptance criteria (explicit)
- Identity for merging: Sandwiches are identical when `(type, isFootlong, breadType)` are equal.
- `Cart.updateQuantity(sandwich, n)`:
  - `n > 0` sets quantity; `n <= 0` removes line and offers UNDO.
- Pricing:
  - `unitPrice = PricingRepository.calculatePrice(quantity: 1, isFootlong: sandwich.isFootlong)`
  - `lineTotal = PricingRepository.calculatePrice(quantity: quantity, isFootlong: sandwich.isFootlong)`
  - `Cart.subtotal()` sums `lineTotal` for all items.
- UI:
  - Use `SnackBar` for confirmations & UNDO.
  - Use `Image.asset(sandwich.image)` with `errorBuilder`.
  - Prices formatted to two decimals with "£".
- Tests utilize local `PricingRepository` (no network).

---

## API / Model suggestions (Dart signatures)
```dart
class Cart extends ChangeNotifier {
  List<CartItem> items;
  void addItem(Sandwich sandwich, {int quantity = 1});
  void updateQuantity(Sandwich sandwich, int quantity);
  void removeItem(Sandwich sandwich);
  void editItem(Sandwich oldItem, Sandwich newItem, {int? quantity});
  int totalItemsCount();
  double subtotal(); // uses PricingRepository internally
  double total({double taxRate = 0.0, double deliveryFee = 0.0});
  void undoLast();
  double unitPriceFor(Sandwich sandwich);
}
```

CartItem:
```dart
class CartItem {
  final Sandwich sandwich;
  int quantity;
}
```

---

## Files to modify / add
- Modify: `lib/models/cart.dart` — extend functionality (updateQuantity, editItem, undo)
- Modify: `lib/views/order_screen.dart` — add live price preview, Add to Cart with SnackBar+UNDO, persistent cart summary (per-item display with quantity controls & delete)
- Add tests:
  - `test/models/cart_test.dart` — unit tests for Cart behavior
  - `test/views/cart_widget_test.dart` — widget tests for live preview, add, update, delete, undo

---

## UI implementation notes & snippets (how to do it)
- Live preview in `OrderScreen`:
  - Recompute `unitPrice` on change:
    ```dart
    final unitPrice = PricingRepository.calculatePrice(quantity: 1, isFootlong: _isFootlong);
    final total = PricingRepository.calculatePrice(quantity: _quantity, isFootlong: _isFootlong);
    Text('Unit: £${unitPrice.toStringAsFixed(2)}  Total: £${total.toStringAsFixed(2)}');
    ```
- Add to Cart with SnackBar+UNDO:
  ```dart
  _cart.addItem(sandwich, quantity: _quantity);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Added $_quantity ${sandwich.name}'),
      action: SnackBarAction(label: 'UNDO', onPressed: () => _cart.undoLast()),
    ),
  );
  ```
- Per-item row (ListTile):
  - Leading: thumbnail `Image.asset(sandwich.image, fit: BoxFit.cover, errorBuilder: ...)`
  - Title: `${sandwich.name} (${_isFootlong ? 'Footlong' : 'Six-inch'})`
  - Subtitle: `Text('£unitPrice · £lineTotal')`
  - Trailing: Row: [IconButton(remove), Text(qty), IconButton(add), IconButton(delete)]

---

## Tests & acceptance checklist (deliverables)
- Unit tests (`test/models/cart_test.dart`):
  - addItem merges identical items
  - updateQuantity updates subtotal or removes and pushes undo snapshot
  - removeItem removes and undo restores
  - editItem merges or replaces properly
  - subtotal uses PricingRepository
- Widget tests (`test/views/cart_widget_test.dart`):
  - Live preview updates for size/quantity
  - Add to cart updates the cart summary count and totals
  - Increment/decrement buttons update UI and totals
  - Delete removes item; SnackBar UNDO restores it
- Expected test run: All new tests + existing tests should pass (report expected numbers after you implement).

---

## Implementation constraints & style
- Keep changes minimal and localized.
- Use `ChangeNotifier` for Cart; call `notifyListeners()` on state changes.
- All price lookups must call `PricingRepository`.
- Currency format: `£${value.toStringAsFixed(2)}`.
- Do not introduce external network calls or API keys in tests.

---

## Output format for LLM (what I want back)
Produce only the code patches (modified/added files) and the two new test files. Each file must be presented in its own code block with the file path as a comment at the top. Example:
```dart
// filepath: lib/models/cart.dart
// ...file contents...
```
Do not include extra explanatory prose — only the code patches and test files. At the end, include a one-line test-run expectation like:
"Expected: unit tests: X, widget tests: Y — all should pass."

---

## Final example instruction to paste for the LLM
"Modify `lib/models/cart.dart` and `lib/views/order_screen.dart` to implement cart item quantity update, removal, edit, live price preview, per-item pricing in the cart summary, and UNDO via SnackBar. Add tests under `test/models/cart_test.dart` and `test/views/cart_widget_test.dart`. Use `PricingRepository` for all pricing. Provide only the full file contents for the modified/added files in code blocks with file path comments at the top."

---

**Developer Note:**
For detailed feature specifications, user stories, and acceptance criteria regarding the Cart Modification feature, please refer to `requirements.md` in the project root.

*End of prompt.*
