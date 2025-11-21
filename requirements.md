# Cart Modification Feature Requirements

## 1. Feature Description and Purpose

The Cart Modification feature enables users of the Sandwich Shop Flutter app to manage the contents of their cart before checkout. Users can adjust the quantity of each sandwich or remove items. Editing sandwich details (such as bread type or size) is not supported on the cart page; users must add a new item from the order screen if they wish to change sandwich options. This feature aims to provide a flexible and user-friendly shopping experience, ensuring users can easily correct mistakes or change their order without starting over.

---

## 2. User Stories

### 2.1. Adjust Quantity

- **As a user**, I want to increase or decrease the quantity of a sandwich in my cart, so I can order the exact number I want.
- **As a user**, I want the cart to automatically remove an item if I decrease its quantity below 1, so my cart never contains items with zero or negative quantity.

### 2.2. Remove Item

- **As a user**, I want to remove a sandwich from my cart with a single action, so I can quickly update my order if I change my mind.

### 2.3. Feedback and UI Responsiveness

- **As a user**, I want the cart and total price to update immediately when I make changes, so I always see an accurate summary of my order.
- **As a user**, I want to receive feedback (such as a snackbar) when I remove or update an item, so I know my action was successful.
- **As a user**, I want to see a clear message if my cart is empty, so I know I need to add items before checking out.

---

## 3. Acceptance Criteria

### 3.1. Quantity Adjustment

- [ ] Each cart item displays "+" and "–" buttons for quantity adjustment.
- [ ] Tapping "+" increases the quantity by 1.
- [ ] Tapping "–" decreases the quantity by 1.
- [ ] If the quantity is reduced below 1, the item is removed from the cart.
- [ ] The total price updates automatically and accurately.
- [ ] The UI updates immediately to reflect changes.

### 3.2. Remove Item

- [ ] Each cart item has a "Remove" button (e.g., trash icon).
- [ ] Tapping "Remove" deletes the item from the cart.
- [ ] The total price updates accordingly.
- [ ] A snackbar or similar feedback is shown when an item is removed.

### 3.3. General UI and Behavior

- [ ] All changes are reflected immediately in the UI.
- [ ] The cart's total price is always accurate.
- [ ] The cart handles empty states gracefully (e.g., displays a message if empty).
- [ ] The UI prevents negative quantities.
- [ ] User feedback is provided for all cart modification actions.

---

## 4. Subtasks

1. Implement "+" and "–" quantity adjustment buttons for each cart item.
2. Implement logic to remove an item if its quantity is reduced below 1.
3. Add a "Remove" button for each cart item.
4. Ensure the total price and UI update immediately after any change.
5. Provide user feedback (snackbar) for remove and update actions.
6. Handle empty cart states with a clear message.

# Profile Page Feature Requirements

## 1. Feature Description and Purpose

The Profile Page feature allows users to view and edit their personal information within the Sandwich Shop app. This screen provides fields for entering details such as name, email, and phone number. While actual data persistence and authentication are not yet implemented, this feature establishes the UI and basic validation logic necessary for future user account management.

---

## 2. User Stories

### 2.1. View and Edit Details

- **As a user**, I want to see input fields for my name, email, and phone number, so I can keep my contact information up to date.
- **As a user**, I want to be able to type into these fields and see my changes reflected immediately.

### 2.2. Save Action

- **As a user**, I want a "Save" button that confirms my action, so I feel confident that my details have been captured (even if just a mock confirmation for now).

### 2.3. Navigation

- **As a user**, I want to access this profile page easily from the order screen, so I can quickly check my details while browsing.

---

## 3. Acceptance Criteria

### 3.1. UI Components

- [ ] The screen displays a clear title "My Profile".
- [ ] Input fields exist for "Full Name", "Email Address", and "Phone Number".
- [ ] A "Save Details" button is present at the bottom of the form.

### 3.2. Functionality

- [ ] Users can enter text into all input fields.
- [ ] Tapping "Save Details" triggers a snackbar message confirming the action (e.g., "Profile details saved").
- [ ] The screen is accessible via a link or button from the Order Screen.

---

## 4. Subtasks

1. Create a new `ProfileScreen` widget with a form layout.
2. Add `TextFormField` widgets for Name, Email, and Phone.
3. Implement a "Save" button that displays a confirmation Snackbar.
4. Add a navigation link/button to the `ProfileScreen` at the bottom of the Order Screen.