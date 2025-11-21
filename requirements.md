# Requirements: Cart Modification Feature (Sandwich Shop)

## 1. Feature description & purpose

Description
- Allow users to modify items in their cart directly from the main Order screen (no separate cart page required for initial rollout).
- Supported modifications:
  - Change quantity (increment / decrement)
  - Remove item
  - Edit item options (size, bread)
  - See per-item unit price and line total in the cart summary
  - Live unit/total price preview while configuring a sandwich before adding to cart
  - UNDO for destructive actions (via SnackBar)

Purpose
- Reduce friction during ordering by letting shoppers correct or tune their selections without leaving the Order screen.
- Keep pricing consistent by using `PricingRepository` as the single source of truth.

Scope
- Modify: `lib/models/cart.dart`, `lib/views/order_screen.dart`
- Add tests: `test/models/cart_test.dart`, `test/views/cart_widget_test.dart`
- No external network calls or persistent storage required for initial implementation.

Out of scope
- Separate cart page, checkout flow, or persistent storage beyond in-memory undo snapshot.

---

## 2. Assumptions & constraints
- Prices come solely from `PricingRepository.calculatePrice({required int quantity, required bool isFootlong})`.
- Sandwich identity (for merging) is defined by `(type, isFootlong, breadType)`.
- `Cart` must be a `ChangeNotifier` and call `notifyListeners()` on updates.
- Keep UI changes localized to `OrderScreen`; do not introduce new screens unless explicitly requested.
- Tests must avoid network calls and be deterministic.

---

## 3. User stories

US-1: Live price preview
- Actor: Shopper
- Story: While configuring a sandwich, I see the current unit price and the total for the selected quantity and size.
- Outcome: Unit & total update instantly when size or quantity changes and always use `PricingRepository`.
- Acceptance test: Widget test toggles size/quantity and asserts displayed price strings update accordingly.

US-2: Increment quantity in cart
- Actor: Shopper
- Story: I tap “+” on a cart line to increase quantity.
- Outcome: Quantity increments, line total and cart subtotal update immediately.
- Acceptance test: Widget test taps “+” and asserts displayed quantity and totals changed.

US-3: Decrement quantity in cart
- Actor: Shopper
- Story: I tap “−” on a cart line. If quantity>1 it decrements; if quantity becomes 0 the item is removed and a SnackBar with UNDO is shown.
- Outcome: Quantity or line removal occurs and totals update.
- Acceptance test: Widget test decrements to removal, asserts SnackBar appears and UNDO restores the line.

US-4: Remove item entirely
- Actor: Shopper
- Story: I tap delete on a cart line.
- Outcome: Item removed; subtotal updated; SnackBar with UNDO shown.
- Acceptance test: Widget test taps delete, asserts removal and that UNDO restores the item.

US-5: Edit an item’s options
- Actor: Shopper
- Story: I edit size or bread for an existing cart line via a modal editor.
- Outcome: If edited configuration matches another cart line, quantities merge; otherwise the line is updated to the new configuration. Totals update.
- Acceptance test: Unit tests for `Cart.editItem` merging/replacing; widget test exercises the modal flow and verifies merge/replace behavior.

US-6: Undo destructive actions
- Actor: Shopper
- Story: After a removal or destructive quantity change, I can tap UNDO on the SnackBar to restore the previous state.
- Outcome: Cart returns to the state prior to the destructive action within the undo window (3–5s).
- Acceptance test: Unit & widget tests simulate remove then UNDO and assert state/totals restored.

---

## 4. Acceptance criteria (definitive & testable)

Functional
- Identity rule: Sandwiches are identical if `(type, isFootlong, breadType)` are equal.
- `addItem(sandwich, quantity)` merges identical lines and increases quantity.
- `updateQuantity(sandwich, n)`:
  - `n > 0` sets the new quantity and updates totals.
  - `n <= 0` removes the line and records a snapshot for undo.
- `removeItem(sandwich)` removes the line and records a snapshot for undo.
- `editItem(oldItem, newItem, {quantity?})` merges with an existing matching line or replaces the old line; totals update.
- Pricing rules (must call `PricingRepository`):
  - `unitPrice = PricingRepository.calculatePrice(quantity: 1, isFootlong: sandwich.isFootlong)`
  - `lineTotal = PricingRepository.calculatePrice(quantity: quantity, isFootlong: sandwich.isFootlong)`
  - `Cart.subtotal()` sums `lineTotal` across items.
- UI requirements:
  - Live preview displays `Unit: £x.xx  Total: £y.yy` and updates on size/quantity changes.
  - Cart summary displays per-item unit price and line total formatted to two decimals with a `£` prefix.
  - Per-item controls: decrement, quantity display, increment, delete.
  - SnackBar appears on add/remove with UNDO action that restores prior state.
- Testing:
  - Unit tests cover Cart methods (add, updateQuantity, remove, edit, undo, subtotal).
  - Widget tests cover live preview, add-to-cart, quantity controls, delete+undo, and edit flows.

Non-functional
- No network calls in tests.
- All new and existing tests pass locally and in CI.
- UI updates are responsive and do not block the main thread.

---

## 5. Subtasks & implementation steps

Subtask A — Cart model (`lib/models/cart.dart`)
- [x] Add/verify `CartItem` model: `{ Sandwich sandwich; int quantity; }`.
- [x] Implement:
  - `addItem(Sandwich sandwich, {int quantity = 1})`
  - `updateQuantity(Sandwich sandwich, int quantity)`
  - `removeItem(Sandwich sandwich)`
  - `editItem(Sandwich oldItem, Sandwich newItem, {int? quantity})`
  - `unitPriceFor(Sandwich sandwich)` — calls `PricingRepository` with `quantity:1`
  - `subtotal()` — sums `lineTotal` via `PricingRepository`
  - `undoLast()` — single-level undo snapshot restore
- [x] Ensure `notifyListeners()` on changes and enforce no negative quantities. Merge identical items using identity rule.

Subtask B — Order screen UI (`lib/views/order_screen.dart`)
- [x] Live preview: compute `unitPrice` and `total` using `PricingRepository` and display as `Unit: £x.xx · Total: £y.yy`.
- [x] Persistent cart summary on the Order screen showing a list of `CartItem`s with thumbnail, name, size, bread, unit price, line total, quantity controls, delete action.
- [x] Add to Cart: call `_cart.addItem(...)` and show SnackBar with UNDO (`_cart.undoLast()`).
- [x] Per-item actions: increment/decrement call `_cart.updateQuantity(...)`; delete calls `_cart.removeItem(...)`.
- [x] Edit action: show a modal editor (`showModalBottomSheet`) prefilled with item options; on save call `_cart.editItem(...)`.

Subtask C — Tests
- [x] Unit tests (`test/models/cart_test.dart`): addItem merging, updateQuantity, remove+undo, editItem merge/replace, subtotal correctness.
- [x] Widget tests (`test/views/cart_widget_test.dart`): live preview, add-to-cart, increment/decrement, delete+undo, edit modal flow.
- [x] Use `PricingRepository` implementation available in `lib/repositories/pricing_repository.dart` for pricing.

Subtask D — Documentation & README
- [x] Update `README.md` to document new cart behaviors and how to run tests.
- [x] Add a developer note in `prompt.md` / project README linking to `requirements.md`.

Subtask E — QA and edge-case handling
- [x] Validate no negative quantities, optional `maxQuantity` enforcement, and resilience to rapid taps.
- [x] Manual QA checklist and automated tests to cover core edge cases.

---

## 6. Test cases (representative)
- TC-1: Live preview updates when toggling size or changing quantity.
- TC-2: Adding a configured sandwich updates cart summary and subtotal.
- TC-3: Incrementing a line updates quantity and totals.
- TC-4: Decrementing to 0 removes the line, shows SnackBar, and UNDO restores it.
- TC-5: Deleting a line shows SnackBar and UNDO restores it.
- TC-6: Editing an item to match an existing line merges quantities.
- TC-7: All price numbers come from `PricingRepository`.

---

## 7. Deliverables
- Modified code: `lib/models/cart.dart`, `lib/views/order_screen.dart`.
- Tests: `test/models/cart_test.dart`, `test/views/cart_widget_test.dart`.
- Docs: `requirements.md` (this file), updated `README.md`, and `prompt.md` linkage.

---

## 8. Risks & mitigation
- Race conditions from rapid taps: mitigate with atomic model updates and optional debounce.
- Undo complexity: implement single-level undo initially; expand later if needed.
- Merge rules collisions: strictly enforce the identity rule in all merge logic.

---

## 9. Acceptance checklist (pre-merge)
- [x] Unit tests for Cart pass.
- [x] Widget tests for cart flows pass.
- [x] Pricing calls go through `PricingRepository`.
- [x] UI displays prices formatted as `£x.xx`.
- [x] SnackBar UNDO restores previous state.
- [x] README updated and developer note added.

---

*End of requirements.*