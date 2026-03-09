import 'package:flutter_test/flutter_test.dart';

import 'package:skycast/main.dart';

void main() {
  testWidgets('Home screen renders SkyCast search UI', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SkyCastApp());

    expect(find.text('SkyCast'), findsOneWidget);
    expect(find.text('Get Weather'), findsOneWidget);
  });
}
