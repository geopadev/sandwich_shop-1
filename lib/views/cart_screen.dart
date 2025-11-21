import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  void _goBack() {
    Navigator.pop(context);
  }

  String _getSizeText(bool isFootlong) {
    if (isFootlong) {
      return 'Footlong';
    } else {
      return 'Six-inch';
    }
  }

  double _getItemPrice(Sandwich sandwich, int quantity) {
    final PricingRepository pricingRepository = PricingRepository();
    return pricingRepository.calculatePrice(
      quantity: quantity,
      isFootlong: sandwich.isFootlong,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        title: const Text(
          'Cart View',
          style: heading1,
        ),
      ),
      body: widget.cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text('Add some delicious sandwiches to get started!'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Back to Order'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cart.items.length,
                    itemBuilder: (context, index) {
                      final sandwich = widget.cart.items.keys.elementAt(index);
                      final quantity = widget.cart.items[sandwich]!;

                      return ListTile(
                        title: Text(
                            'Sandwich ${sandwich.isFootlong ? "(Footlong)" : "(6-inch)"}'),
                        subtitle: Text('Quantity: $quantity'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Remove Button (Trash Icon)
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  widget.cart.delete(sandwich);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Item removed from cart'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                            // Decrease Quantity Button
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  widget.cart.remove(sandwich);
                                });
                                if (!widget.cart.items.containsKey(sandwich)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Item removed from cart'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              },
                            ),
                            Text('$quantity'),
                            // Increase Quantity Button
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  widget.cart.add(sandwich);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            '\$${widget.cart.totalPrice.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Back to Order'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
