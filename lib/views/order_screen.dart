import 'package:flutter/material.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:sandwich_shop/views/app_styles.dart';

class OrderScreen extends StatefulWidget {
  final int maxQuantity;
  const OrderScreen({super.key, this.maxQuantity = 99});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final Cart _cart = Cart();

  SandwichType _selectedType = SandwichType.veggieDelight;
  bool _isFootlong = false;
  BreadType _selectedBread = BreadType.white;
  int _selectedQuantity = 1;

  final PricingRepository _pricing = PricingRepository();

  String _priceString(double v) => '£${v.toStringAsFixed(2)}';

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () => _cart.undoLast(),
        ),
      ),
    );
  }

  void _addToCart() {
    final Sandwich s = Sandwich(
      type: _selectedType,
      isFootlong: _isFootlong,
      breadType: _selectedBread,
    );
    _cart.add(s, quantity: _selectedQuantity);
    _showSnackBar('Added ${_selectedQuantity} × ${s.name}');
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
                  Text('Edit ${sandwich.name}', style: heading2),
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
                        _cart.editItem(sandwich, newSandwich);
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
    final unitPrice =
        _pricing.calculatePrice(quantity: 1, isFootlong: _isFootlong);
    final previewTotal = _pricing.calculatePrice(
        quantity: _selectedQuantity, isFootlong: _isFootlong);

    return Scaffold(
      appBar: AppBar(title: const Text('Sandwich Shop')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Configurator
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Configure sandwich', style: heading2),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Type: '),
                        const SizedBox(width: 8),
                        DropdownButton<SandwichType>(
                          value: _selectedType,
                          onChanged: (v) => setState(() => _selectedType = v!),
                          items: SandwichType.values
                              .map((t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(Sandwich(
                                            type: t,
                                            isFootlong: false,
                                            breadType: BreadType.white)
                                        .name),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                    SwitchListTile(
                      title: Text(_isFootlong ? 'Footlong' : 'Six-inch'),
                      value: _isFootlong,
                      onChanged: (v) => setState(() => _isFootlong = v),
                      contentPadding: EdgeInsets.zero,
                    ),
                    Row(
                      children: [
                        const Text('Bread: '),
                        const SizedBox(width: 8),
                        DropdownButton<BreadType>(
                          value: _selectedBread,
                          onChanged: (v) => setState(() => _selectedBread = v!),
                          items: BreadType.values
                              .map((b) => DropdownMenuItem(
                                    value: b,
                                    child: Text(b.name),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Quantity: '),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: _selectedQuantity > 1
                              ? () => setState(() => _selectedQuantity--)
                              : null,
                        ),
                        Text('$_selectedQuantity'),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: _selectedQuantity < widget.maxQuantity
                              ? () => setState(() => _selectedQuantity++)
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                        'Unit: ${_priceString(unitPrice)} · Total: ${_priceString(previewTotal)}',
                        style: normalText),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.add_shopping_cart),
                            label: const Text('Add to cart'),
                            onPressed: _addToCart,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Cart', style: heading2),
              ],
            ),

            const SizedBox(height: 8),

            Expanded(
              child: AnimatedBuilder(
                animation: _cart,
                builder: (context, _) {
                  final items = _cart.items;
                  if (items.isEmpty) {
                    return const Center(child: Text('Your cart is empty.'));
                  }
                  final subtotal = _cart.totalPrice;
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: items.entries.map((entry) {
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
                                  width: 140,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () =>
                                            _showEditModal(sandwich),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          _cart.remove(sandwich, quantity: 1);
                                          _showSnackBar(
                                              'Removed 1 × ${sandwich.name}');
                                        },
                                      ),
                                      Text('$qty'),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          if (qty < widget.maxQuantity) {
                                            _cart.add(sandwich, quantity: 1);
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () {
                                          final int currentQty =
                                              _cart.getQuantity(sandwich);
                                          if (currentQty > 0) {
                                            _cart.removeItem(sandwich,
                                                quantity: currentQty);
                                            _showSnackBar(
                                                'Removed ${currentQty} × ${sandwich.name}');
                                          }
                                        },
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
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal', style: heading1),
                            Text(_priceString(subtotal), style: heading1),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
