import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/game_provider.dart';
import 'providers/premium_provider.dart';
import 'services/ad_service.dart';
import 'screens/category_selection_screen.dart';
import 'screens/player_entry_screen.dart';
import 'screens/mode_selection_screen.dart';
import 'screens/game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // Immersive mode (transparent status bar)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize AdMob
  final adService = AdService();
  await adService.initialize();

  runApp(TchinApp(adService: adService));
}

class TchinApp extends StatelessWidget {
  final AdService adService;

  const TchinApp({super.key, required this.adService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => PremiumProvider()),
        Provider.value(value: adService),
      ],
      child: MaterialApp(
        title: 'Tchin App 2',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const PlayerEntryScreen(),
        routes: {
          '/categories': (context) => const CategorySelectionScreen(),
          '/player-entry': (context) => const PlayerEntryScreen(),
          '/mode': (context) => const ModeSelectionScreen(),
          '/game': (context) => const GameScreen(),
        },
      ),
    );
  }
}
