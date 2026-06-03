// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tchin_app_3/main.dart';
import 'package:tchin_app_3/services/ad_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    tester.binding.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(
      tester.binding.platformDispatcher.clearAccessibilityFeaturesTestValue,
    );

    final adService = AdService();

    // Build our app and trigger a frame.
    await tester.pumpWidget(TchinApp(adService: adService));
    await tester.pump(const Duration(seconds: 1));

    // Verify that our app starts on the Player Entry Screen
    expect(find.text('Tchin !'), findsOneWidget);
    expect(find.text('Commencer la fête'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
}
