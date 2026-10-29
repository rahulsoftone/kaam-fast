import 'package:flutter_test/flutter_test.dart';
import 'package:kaam_fast/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KaamFastApp());
    expect(find.byType(KaamFastApp), findsOneWidget);
  });
}
