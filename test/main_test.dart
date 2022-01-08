import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tatetsu/main_dev.dart';

void main() {
  testWidgets('Participants label test', (WidgetTester tester) async {
    await tester.pumpWidget(Tatetsu());
    expect(find.byIcon(Icons.add_circle), findsOneWidget);
  });
}
