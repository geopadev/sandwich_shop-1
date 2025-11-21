import 'package:flutter/material.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/about_screen.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/profile_screen.dart';

class AppDrawer extends StatelessWidget {
  final bool permanent;

  const AppDrawer({super.key, this.permanent = false});

  void _navigateTo(BuildContext context, Widget screen) {
    if (permanent) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    } else {
      Navigator.pop(context); // Close drawer
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final drawerContent = ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.orange,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
                child: Image.asset('assets/images/logo.png',
                    errorBuilder: (c, e, s) => const Icon(Icons.fastfood,
                        size: 60, color: Colors.white)),
              ),
              const SizedBox(height: 10),
              const Text('Sandwich Shop',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.restaurant_menu),
          title: const Text('Order'),
          onTap: () {
            if (permanent) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const OrderScreen()));
            } else {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const OrderScreen()),
                  (route) => false);
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.shopping_cart),
          title: const Text('Cart'),
          onTap: () => _navigateTo(context, CartScreen(cart: Cart())),
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Profile'),
          onTap: () => _navigateTo(context, const ProfileScreen()),
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('About'),
          onTap: () => _navigateTo(context, const AboutScreen()),
        ),
      ],
    );

    if (permanent) {
      return SizedBox(
        width: 250,
        child: Drawer(child: drawerContent),
      );
    }
    return Drawer(child: drawerContent);
  }
}
