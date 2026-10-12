import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sales_system/widgets/elevated_button.dart';
import 'package:sales_system/src/features/products/presentation/widgets/products_empty_state.dart';

void main() {
  testWidgets('CustomElevatedButton renders text and triggers callback', (WidgetTester tester) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomElevatedButton(
            buttonText: 'Click Me',
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Click Me'), findsOneWidget);
    await tester.tap(find.text('Click Me'));
    expect(wasPressed, isTrue);
  });

  testWidgets('ProductsEmptyState renders no products state correctly', (WidgetTester tester) async {
    bool refreshed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProductsEmptyState.noProducts(
            onRefresh: () {
              refreshed = true;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No Products Available'), findsOneWidget);
    expect(find.text('Refresh Catalog'), findsOneWidget);

    await tester.tap(find.text('Refresh Catalog'));
    expect(refreshed, isTrue);
  });
}

