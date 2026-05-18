import 'package:dewmii/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Dewmii app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DewmiiApp());

    expect(find.text('Dewmii'), findsOneWidget);
  });
}
