import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/sandwich.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({Key? key, required this.cart}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: widget.cart.isEmpty
          ? const Center(child: Text('Your cart is empty'))
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
                        // Assuming Sandwich has a name or we construct a title.
                        // Adjust 'title' based on actual Sandwich class properties.
                        subtitle: Text('Quantity: $quantity'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  widget.cart.remove(sandwich);
                                });
                              },
                            ),
                            Text('$quantity'),
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total: \$${widget.cart.totalPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
    );
  }
}
