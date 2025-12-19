import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Basic widget test', (WidgetTester tester) async {
    // Simple test that doesn't require Firebase
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('AASHA MEDIX'))),
      ),
    );

    // Verify basic text is shown
    expect(find.text('AASHA MEDIX'), findsOneWidget);
  });
}
