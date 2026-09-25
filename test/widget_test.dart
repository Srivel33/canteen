import 'package:flutter_test/flutter_test.dart';
import 'package:canteentoken/main.dart';

void main() {
  testWidgets('Canteen App initial render smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CanteenApp());
    expect(find.text('Menu'), findsWidgets);
  });
}
