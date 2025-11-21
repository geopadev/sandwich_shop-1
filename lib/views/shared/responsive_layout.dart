import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/shared/app_drawer.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget body;
  final String title;

  const ResponsiveLayout({
    super.key,
    required this.body,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          // Desktop / Tablet Layout
          return Scaffold(
            appBar: AppBar(
              title: Text(title, style: heading1),
            ),
            body: Row(
              children: [
                const AppDrawer(permanent: true),
                Expanded(child: body),
              ],
            ),
          );
        } else {
          // Mobile Layout
          return Scaffold(
            appBar: AppBar(
              title: Text(title, style: heading1),
            ),
            drawer: const AppDrawer(),
            body: body,
          );
        }
      },
    );
  }
}
