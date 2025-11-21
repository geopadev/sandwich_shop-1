import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
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
  final PricingRepository _pricing = PricingRepository();

  void _goBack() {
    Navigator.pop(context);
  }

  String _priceString(double v) => '£${v.toStringAsFixed(2)}';

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () => widget.cart.undoLast(),
        ),
      ),
    );
  }

  void _showEditModal(Sandwich sandwich) {
    bool isFootlong = sandwich.isFootlong;
    BreadType bread = sandwich.breadType;

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Edit Item', style: heading2),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(isFootlong ? 'Footlong' : 'Six-inch'),
                    value: isFootlong,
                    onChanged: (v) => setModalState(() => isFootlong = v),
                  ),
                  Row(
                    children: [
                      const Text('Bread: '),
                      const SizedBox(width: 8),
                      DropdownButton<BreadType>(
                        value: bread,
                        onChanged: (v) => setModalState(() => bread = v!),
                        items: BreadType.values
                            .map((b) => DropdownMenuItem(
                                  value: b,
                                  child: Text(b.name),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final newSandwich = Sandwich(
                          type: sandwich.type,
                          isFootlong: isFootlong,
                          breadType: bread,
                        );
                        widget.cart.editItem(sandwich, newSandwich);
                        Navigator.pop(context);
                      },
                      child: const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
      body: AnimatedBuilder(
        animation: widget.cart,
        builder: (context, _) {
          if (widget.cart.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Your cart is empty.', style: normalText),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _goBack,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to Order'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: widget.cart.items.entries.map((entry) {
                    final Sandwich sandwich = entry.key;
                    final int qty = entry.value;
                    final double unit = _pricing.calculatePrice(
                        quantity: 1, isFootlong: sandwich.isFootlong);
                    final double lineTotal = _pricing.calculatePrice(
                        quantity: qty, isFootlong: sandwich.isFootlong);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: Image.asset(
                          sandwich.image,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) =>
                              const Icon(Icons.fastfood),
                        ),
                        title: Text(
                            '${sandwich.name} · ${sandwich.isFootlong ? 'Footlong' : 'Six-inch'}'),
                        subtitle: Text(
                            '${sandwich.breadType.name} · Unit: ${_priceString(unit)} · ${_priceString(lineTotal)}'),
                        trailing: SizedBox(
                          width: 160,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showEditModal(sandwich),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                    minWidth: 32, minHeight: 32),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  widget.cart.remove(sandwich, quantity: 1);
                                  _showSnackBar('Removed 1 × ${sandwich.name}');
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                    minWidth: 32, minHeight: 32),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text('$qty'),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  widget.cart.add(sandwich, quantity: 1);
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                    minWidth: 32, minHeight: 32),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () {
                                  final int currentQty =
                                      widget.cart.getQuantity(sandwich);
                                  if (currentQty > 0) {
                                    widget.cart.removeItem(sandwich,
                                        quantity: currentQty);
                                    _showSnackBar(
                                        'Removed ${currentQty} × ${sandwich.name}');
                                  }
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                    minWidth: 32, minHeight: 32),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Total: ${_priceString(widget.cart.totalPrice)}',
                      style: heading2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _goBack,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back to Order'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
