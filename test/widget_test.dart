// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tchin_app_2/main.dart';
import 'package:tchin_app_2/services/ad_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    tester.binding.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(
      tester.binding.platformDispatcher.clearAccessibilityFeaturesTestValue,
    );

    final adService = AdService();

    // Build our app and trigger a frame.
    await tester.pumpWidget(TchinApp(adService: adService));

    // Verify that our app starts on the Player Entry Screen
    expect(find.text('🍻 Tchin 2'), findsOneWidget);
    expect(find.text('Commencer la partie'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
