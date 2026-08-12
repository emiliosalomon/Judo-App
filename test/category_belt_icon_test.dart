import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_app/widgets/category_belt_icon.dart';

void main() {
  testWidgets('zeigt vier uebereinander gestapelte Guertel-Balken', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: CategoryBeltIcon(size: 40))),
    );

    expect(find.byType(CategoryBeltIcon), findsOneWidget);
    final decoratedBoxes = tester.widgetList<Container>(find.byType(Container));
    expect(decoratedBoxes.length, 4);
  });
}
