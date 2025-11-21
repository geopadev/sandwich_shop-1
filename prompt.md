# Requirements Document: Cart Modification Feature

## 1. Feature Description
The Cart Modification feature aims to enhance the user experience on the `CartScreen` by allowing customers to adjust their current order before checkout. Currently, users can view items but cannot change them without clearing the cart or navigating back. This feature introduces granular control, enabling users to increment or decrement item quantities and remove specific items entirely.

This feature will leverage the existing `Cart` model for state management and the `Pricing` repository to ensure accurate recalculation of totals based on the sandwich size and new quantities.

## 2. User Stories

### Story 1: Adjust Quantity
**As a** hungry customer,
**I want to** increase or decrease the number of a specific sandwich in my cart,
**So that** I can order the exact amount I need without restarting my order.

### Story 2: Remove Item
**As a** customer who changed their mind,
**I want to** remove a specific sandwich from my cart,
**So that** I don't pay for food I no longer want.

### Story 3: View Updated Total
**As a** budget-conscious customer,
**I want to** see the total price update instantly when I change quantities or remove items,
**So that** I know exactly how much I will be charged.

## 3. Acceptance Criteria

### AC 1: Quantity Controls
*   **Given** the user is on the `CartScreen`,
*   **When** they view a cart item,
*   **Then** they should see "+" and "-" buttons (or similar UI controls) associated with that item.
*   **When** the "+" button is tapped, the quantity for that specific sandwich increases by 1.
*   **When** the "-" button is tapped, the quantity decreases by 1.

### AC 2: Minimum Quantity Handling
*   **Given** an item has a quantity of 1,
*   **When** the user taps the "-" button,
*   **Then** the item should be removed from the cart entirely OR a confirmation dialog should appear (depending on UX preference, default to immediate removal for speed).

### AC 3: Explicit Removal
*   **Given** the user is on the `CartScreen`,
*   **When** they tap a "Remove" icon (e.g., trash can) or perform a swipe-to-dismiss gesture on an item,
*   **Then** the item is permanently removed from the cart list.

### AC 4: Price Recalculation
*   **Given** the user modifies a quantity or removes an item,
*   **Then** the `Cart` model must trigger a recalculation of the total price.
*   **And** the calculation must use the `Pricing` repository logic (Price = f(Quantity, Size)).
*   **And** the UI must update immediately to reflect the new total.

### AC 5: Data Integrity
*   **Given** a `Sandwich` object in the cart,
*   **When** the quantity is modified,
*   **Then** the# Requirements Document: Cart Modification Feature

## 1. Feature Description
The Cart Modification feature aims to enhance the user experience on the `CartScreen` by allowing customers to adjust their current order before checkout. Currently, users can view items but cannot change them without clearing the cart or navigating back. This feature introduces granular control, enabling users to increment or decrement item quantities and remove specific items entirely.

This feature will leverage the existing `Cart` model for state management and the `Pricing` repository to ensure accurate recalculation of totals based on the sandwich size and new quantities.

## 2. User Stories

### Story 1: Adjust Quantity
**As a** hungry customer,
**I want to** increase or decrease the number of a specific sandwich in my cart,
**So that** I can order the exact amount I need without restarting my order.

### Story 2: Remove Item
**As a** customer who changed their mind,
**I want to** remove a specific sandwich from my cart,
**So that** I don't pay for food I no longer want.

### Story 3: View Updated Total
**As a** budget-conscious customer,
**I want to** see the total price update instantly when I change quantities or remove items,
**So that** I know exactly how much I will be charged.

## 3. Acceptance Criteria

### AC 1: Quantity Controls
*   **Given** the user is on the `CartScreen`,
*   **When** they view a cart item,
*   **Then** they should see "+" and "-" buttons (or similar UI controls) associated with that item.
*   **When** the "+" button is tapped, the quantity for that specific sandwich increases by 1.
*   **When** the "-" button is tapped, the quantity decreases by 1.

### AC 2: Minimum Quantity Handling
*   **Given** an item has a quantity of 1,
*   **When** the user taps the "-" button,
*   **Then** the item should be removed from the cart entirely OR a confirmation dialog should appear (depending on UX preference, default to immediate removal for speed).

### AC 3: Explicit Removal
*   **Given** the user is on the `CartScreen`,
*   **When** they tap a "Remove" icon (e.g., trash can) or perform a swipe-to-dismiss gesture on an item,
*   **Then** the item is permanently removed from the cart list.

### AC 4: Price Recalculation
*   **Given** the user modifies a quantity or removes an item,
*   **Then** the `Cart` model must trigger a recalculation of the total price.
*   **And** the calculation must use the `Pricing` repository logic (Price = f(Quantity, Size)).
*   **And** the UI must update immediately to reflect the new total.

### AC 5: Data Integrity
*   **Given** a `Sandwich` object in the cart,
*   **When** the quantity is modified,
*   **Then** the