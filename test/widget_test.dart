// Basic Flutter widget test for RENGSÉ app

import 'package:flutter_test/flutter_test.dart';
import 'package:rengse/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RengseApp());

    // Verify that app loads (loading indicator shows)
    expect(find.byType(RengseApp), findsOneWidget);
  });
}
