import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unit_conv_app/main.dart';
import 'package:unit_conv_app/widgets/swap_button.dart';

void main() {
  testWidgets('Unit Converter smoke & UI test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify title and main labels
    expect(find.text('Unit Converter'), findsOneWidget);
    expect(find.text('Length'), findsOneWidget);
    expect(find.text('Weight'), findsOneWidget);
    expect(find.text('Temp'), findsOneWidget);
    expect(find.text('Enter Value'), findsOneWidget);

    // Initial state has '25' meter to kilometer = '0.025 km'
    expect(find.text('25'), findsOneWidget);
    expect(find.text('0.025 km'), findsOneWidget);

    // Test real-time input change
    final textFieldFinder = find.byType(TextField);
    await tester.enterText(textFieldFinder, '50');
    await tester.pumpAndSettle();

    expect(find.text('0.05 km'), findsOneWidget);

    // Test swap button
    final swapButtonFinder = find.byType(SwapButton);
    expect(swapButtonFinder, findsOneWidget);
    await tester.tap(swapButtonFinder);
    await tester.pumpAndSettle();

    // 50 km to meter = 50000 m
    expect(find.text('50000 m'), findsOneWidget);

    // Test category switch to Weight
    await tester.tap(find.text('Weight'));
    await tester.pumpAndSettle();

    // In weight: 50 g to kg = 0.05 kg
    expect(find.text('Gram'), findsOneWidget);
    expect(find.text('Kilogram'), findsOneWidget);
    expect(find.text('0.05 kg'), findsOneWidget);
  });
}
