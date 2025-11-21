import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/shared/responsive_layout.dart';
import 'package:sandwich_shop/views/shared/app_drawer.dart';

void main() {
  testWidgets('ResponsiveLayout shows drawer on mobile',
      (WidgetTester tester) async {
    // Set screen size to mobile portrait
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      const MaterialApp(
        home: ResponsiveLayout(
          title: 'Test Title',
          body: Text('Body Content'),
        ),
      ),
    );

    // Verify AppBar title
    expect(find.text('Test Title'), findsOneWidget);

    // Verify body content
    expect(find.text('Body Content'), findsOneWidget);

    // Verify Drawer is NOT visible initially
    expect(find.byType(AppDrawer), findsNothing);

    // Open drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Verify Drawer IS visible
    expect(find.byType(AppDrawer), findsOneWidget);

    // Reset view
    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('ResponsiveLayout shows permanent side menu on desktop',
      (WidgetTester tester) async {
    // Set screen size to desktop/tablet landscape
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      const MaterialApp(
        home: ResponsiveLayout(
          title: 'Test Title',
          body: Text('Body Content'),
        ),
      ),
    );

    // Verify AppBar title
    expect(find.text('Test Title'), findsOneWidget);

    // Verify body content
    expect(find.text('Body Content'), findsOneWidget);

    // Verify AppDrawer is visible permanently (part of the body row)
    expect(find.byType(AppDrawer), findsOneWidget);

    // Reset view
    addTearDown(tester.view.resetPhysicalSize);
  });
}
