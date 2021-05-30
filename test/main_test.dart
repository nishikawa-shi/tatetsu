import 'package:flutter_test/flutter_test.dart';
import 'package:tatetsu/main.dart';

void main() {
  testWidgets('Participants label test', (WidgetTester tester) async {
    await tester.pumpWidget(Tatetsu());
    expect(find.text('Enter participants names.'), findsOneWidget);
  });
}
