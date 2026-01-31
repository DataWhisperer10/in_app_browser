// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ia_browser/main.dart';

void main() {
  testWidgets('App launches with splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: IABrowserApp()));

    // Verify that splash screen appears
    expect(find.text('IA Browser'), findsOneWidget);
    expect(find.text('AI-Powered Browsing'), findsOneWidget);
  });
}
