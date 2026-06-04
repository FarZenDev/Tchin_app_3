import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tchin_app_3/providers/game_provider.dart';
import 'package:tchin_app_3/providers/premium_provider.dart';
import 'package:tchin_app_3/screens/stats_screen.dart';
import 'package:tchin_app_3/services/ad_service.dart';
import 'package:tchin_app_3/theme/app_theme.dart';

void main() {
  testWidgets('Stats receipt renders party summary and loser account', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    final game = GameProvider()
      ..addPlayer('Mathis')
      ..addPlayer('Alex')
      ..applyDevilCallResult(['Mathis', 'Alex']);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<GameProvider>.value(value: game),
          ChangeNotifierProvider(create: (_) => PremiumProvider()),
          Provider.value(value: AdService()),
        ],
        child: MaterialApp(
          theme: AppTheme.theme,
          home: const StatsScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('ADDITION DE LA SOIREE'), findsOneWidget);
    expect(find.text('LE TCHIN BAR'), findsOneWidget);
    expect(find.text('COMPTE LOOSER'), findsOneWidget);
    expect(find.textContaining('TOTAL'), findsWidgets);

    game.dispose();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
}
