import 'package:flutter/material.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/app_styles.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _incrementQuantity(CartItem item) {
    setState(() {
      widget.cart.increment(item.sandwich);
    });
  }

  void _decrementQuantity(CartItem item) {
    setState(() {
      widget.cart.decrement(item.sandwich);
      if (item.quantity <= 0) {
        _showSnackBar('Item removed from cart');
      }
    });
  }

  void _removeItem(CartItem item) {
    setState(() {
      widget.cart.removeItem(item.sandwich);
    });
    _showSnackBar('Item removed from cart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart', style: heading1),
      ),
      body: widget.cart.isEmpty
          ? const Center(
              child: Text('Your cart is empty', style: normalText),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cart.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.cart.items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.sandwich.name,
                                          style: heading2,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.sandwich.isFootlong
                                              ? 'Footlong'
                                              : 'Six-inch',
                                          style: normalText,
                                        ),
                                        Text(
                                          '${item.sandwich.breadType.name} bread',
                                          style: normalText,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => _removeItem(item),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () =>
                                            _decrementQuantity(item),
                                      ),
                                      Text(
                                        'Quantity: ${item.quantity}',
                                        style: normalText,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () =>
                                            _incrementQuantity(item),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '£${item.totalPrice().toStringAsFixed(2)}',
                                    style: heading2,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Price:',
                        style: heading2,
                      ),
                      Text(
                        '£${widget.cart.total().toStringAsFixed(2)}',
                        style: heading2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
