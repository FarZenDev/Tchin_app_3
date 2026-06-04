import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../providers/game_provider.dart';
import '../providers/premium_provider.dart';
import '../services/ad_service.dart';
import '../widgets/game_layout.dart';
import '../widgets/gradient_button.dart';
import '../theme/app_theme.dart';
import 'stats_screen.dart';
import '../models/question_model.dart';
import 'tic_tac_toe_screen.dart';
import '../widgets/dice_widget.dart';
import '../widgets/liquid_transition.dart';
import '../theme/beer_colors.dart';
import '../widgets/fortune_wheel.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/slot_machine.dart';
import '../widgets/question_playing_card.dart';
import '../widgets/devil_laugh_animation.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _allowExitPop = false;
  bool _isExitInterstitialShowing = false;
  bool _hasShownGameOverInterstitial = false;
  bool _isGameOverInterstitialShowing = false;
  bool _showDevilSkipEffect = false;
  int _devilSkipEffectSerial = 0;

  Future<void> _leaveGame() async {
    if (_isExitInterstitialShowing) return;
    _isExitInterstitialShowing = true;

    final premium = context.read<PremiumProvider>();
    await context.read<AdService>().showInterstitialIfReady(
          isPremium: premium.isPremium,
          context: context,
        );

    if (!mounted) return;
    setState(() => _allowExitPop = true);
    Navigator.pop(context);
  }

  void _maybeShowGameOverInterstitial(GameProvider game) {
    if (!game.isGameOver) {
      _hasShownGameOverInterstitial = false;
      return;
    }

    if (_hasShownGameOverInterstitial ||
        _isGameOverInterstitialShowing ||
        _isExitInterstitialShowing) {
      return;
    }

    _hasShownGameOverInterstitial = true;
    _isGameOverInterstitialShowing = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final premium = context.read<PremiumProvider>();
      await context.read<AdService>().showInterstitialIfReady(
            isPremium: premium.isPremium,
            context: context,
          );

      if (mounted) {
        _isGameOverInterstitialShowing = false;
      }
    });
  }

  Future<void> _skipQuestionWithDevil() async {
    final game = context.read<GameProvider>();
    if (!game.canSkipWithDevil || _showDevilSkipEffect) return;

    setState(() {
      _showDevilSkipEffect = true;
      _devilSkipEffectSerial++;
    });

    game.skipCurrentQuestionWithDevil();

    await Future.delayed(const Duration(milliseconds: 1900));
    if (mounted) {
      setState(() => _showDevilSkipEffect = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get colors based on mode
    final game = Provider.of<GameProvider>(context, listen: false);
    final themeColor = BeerColors.getForMode(
      game.currentMode ?? GameMode.classic,
    );

    return PopScope(
      canPop: _allowExitPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _leaveGame();
      },
      child: Stack(
        children: [
          // Initial Fill Animation (Background)
          Positioned.fill(
            child: LiquidTransition(
              isFilling: true,
              color: themeColor,
              duration: const Duration(milliseconds: 1000),
            ),
          ),

          // Happy Hour Overlay (Pulse Effect)
          Consumer<GameProvider>(
            builder: (context, game, _) {
              if (!game.isHappyHour) return const SizedBox.shrink();
              return IgnorePointer(
                child: Container(color: Colors.red.withOpacity(0.1))
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .shimmer(
                      color: Colors.redAccent,
                      duration: 1500.ms,
                    ) // Usage of shimmer instead of boxShadow
                    .fadeIn(duration: 500.ms),
              );
            },
          ),

          GameLayout(
            enableBackground: false,
            child: Column(
              children: [
                _GameHeader(
                  accentColor: themeColor,
                  modeLabel: BeerColors.getNameForMode(
                    game.currentMode ?? GameMode.classic,
                  ),
                  onLeaveGame: _leaveGame,
                ),

                const SizedBox(height: 10),

                // Happy Hour Banner
                Consumer<GameProvider>(
                  builder: (context, game, _) {
                    if (!game.isHappyHour) return const SizedBox.shrink();
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF1744), Color(0xFFFF6D00)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.5),
                            blurRadius: 18,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Text(
                            'HAPPY HOUR — X2 GORGÉES',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('🔥', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scaleXY(begin: 1.0, end: 1.02, duration: 800.ms);
                  },
                ),

                Expanded(
                  child: Consumer<GameProvider>(
                    builder: (context, game, _) {
                      _maybeShowGameOverInterstitial(game);

                      return QuestionPlayingCard(
                        accentColor: themeColor,
                        modeLabel: BeerColors.getNameForMode(
                          game.currentMode ?? GameMode.classic,
                        ),
                        animationKey:
                            '${game.currentQuestionText}-${game.currentQuestionType}-${game.isGameOver}',
                        isSpecial: game.currentQuestionType ==
                                QuestionType.centralGlass ||
                            game.isHappyHour,
                        child: _QuestionCardContent(
                          accentColor: themeColor,
                          game: game,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),
                _QuestionNavigationBar(
                  accentColor: themeColor,
                  onDevilSkip: _skipQuestionWithDevil,
                ),
              ],
            ),
          ),

          Positioned(
            left: 0,
            top: 120,
            bottom: 116,
            width: MediaQuery.of(context).size.width * 0.24,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Provider.of<GameProvider>(
                  context,
                  listen: false,
                ).previousQuestion();
              },
              child: Container(color: Colors.transparent),
            ),
          ),

          Positioned(
            right: 0,
            top: 120,
            bottom: 116,
            width: MediaQuery.of(context).size.width * 0.24,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                final game = Provider.of<GameProvider>(context, listen: false);
                if (!game.isGameOver) game.nextQuestion();
              },
              child: Container(color: Colors.transparent),
            ),
          ),

          if (_showDevilSkipEffect)
            Positioned.fill(
              child: IgnorePointer(
                child: _DevilSkipOverlay(key: ValueKey(_devilSkipEffectSerial)),
              ),
            ),
        ],
      ),
    );
  }
}

class _GameHeader extends StatelessWidget {
  final Color accentColor;
  final String modeLabel;
  final Future<void> Function() onLeaveGame;

  const _GameHeader({
    required this.accentColor,
    required this.modeLabel,
    required this.onLeaveGame,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: accentColor.withOpacity(0.08),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        children: [
          Consumer<GameProvider>(
            builder: (context, game, _) {
              final duration = game.gameDuration;
              final minutes =
                  duration.inMinutes.remainder(60).toString().padLeft(2, '0');
              final seconds =
                  duration.inSeconds.remainder(60).toString().padLeft(2, '0');
              return _HeaderPill(
                icon: Icons.timer_outlined,
                label: "$minutes:$seconds",
                color: accentColor,
                monospace: true,
              );
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _HeaderPill(
              icon: Icons.sports_bar_rounded,
              label: modeLabel,
              color: accentColor,
              centered: true,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Stats',
            onPressed: () async {
              final game = Provider.of<GameProvider>(context, listen: false);
              if (game.playerSips.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StatsScreen()),
                );
              } else {
                await onLeaveGame();
              }
            },
            icon: Icon(Icons.bar_chart_rounded, size: 20, color: accentColor),
            style: IconButton.styleFrom(
              backgroundColor: accentColor.withOpacity(0.12),
              fixedSize: const Size(38, 38),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: accentColor.withOpacity(0.3)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool monospace;
  final bool centered;

  const _HeaderPill({
    required this.icon,
    required this.label,
    required this.color,
    this.monospace = false,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment:
            centered ? MainAxisAlignment.center : MainAxisAlignment.start,
        mainAxisSize: centered ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: AppTheme.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: monospace ? 1.2 : 0,
                fontFeatures:
                    monospace ? const [FontFeature.tabularFigures()] : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCardContent extends StatelessWidget {
  final GameProvider game;
  final Color accentColor;

  const _QuestionCardContent({required this.game, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    if (game.isGameOver) {
      return _GameOverContent(accentColor: accentColor);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1).animate(animation),
            child: child,
          ),
        );
      },
      child: Column(
        key: ValueKey(
          '${game.currentQuestionDisplayText}-${game.currentQuestionType}',
        ),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 5,
            child: Center(
              child: AutoSizeText(
                game.currentQuestionDisplayText,
                textAlign: TextAlign.center,
                style: GoogleFonts.bebasNeue(
                  fontSize: 36,
                  height: 1.02,
                  color: Colors.black87,
                ),
                minFontSize: 20,
                maxLines: 7,
                overflow: TextOverflow.ellipsis,
              )
                  .animate(
                    target: (game.currentQuestionType ==
                                QuestionType.centralGlass &&
                            game.currentQuestionText.contains("Cul sec"))
                        ? 1
                        : 0,
                  )
                  .shake(
                    hz: 8,
                    curve: Curves.easeInOutCubic,
                    duration: 600.ms,
                  ),
            ),
          ),
          const SizedBox(height: 18),
          _buildAction(context),
        ],
      ),
    );
  }

  Widget _buildAction(BuildContext context) {
    switch (game.currentQuestionType) {
      case QuestionType.ticTacToe:
        return GradientButton(
          text: "Duel",
          icon: Icons.grid_3x3,
          isSmall: true,
          onPressed: () {
            final text = game.currentQuestionText;
            var challenger = "Joueur";
            for (final player in game.players) {
              if (text.contains(player)) {
                challenger = player;
                break;
              }
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TicTacToeScreen(challenger: challenger),
              ),
            );
          },
        );
      case QuestionType.dice:
        return const Flexible(
          flex: 4,
          child: FittedBox(fit: BoxFit.scaleDown, child: _DiceSection()),
        );
      case QuestionType.wheel:
        return GradientButton(
          text: "Tourner la roue",
          icon: Icons.casino,
          isSmall: true,
          onPressed: () => _openWheel(context),
        );
      case QuestionType.slotMachine:
        return Flexible(
          flex: 4,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SlotMachineWidget(
              onResult: (sips) => _showSlotResult(context, sips),
            ),
          ),
        );
      default:
        return const SizedBox(height: 10);
    }
  }

  void _openWheel(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: FortuneWheel(
          items: const [
            "Cul Sec",
            "Distrib 3",
            "Vérité",
            "Gage",
            "Shot",
            "Bois 2",
          ],
          onResult: (result) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!dialogContext.mounted) return;

              showDialog(
                context: dialogContext,
                barrierDismissible: false,
                builder: (ctx) => AlertDialog(
                  title: const Text("Le sort en est jeté ! 🎲"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("La roue est tombée sur :"),
                      const SizedBox(height: 10),
                      Text(
                        result,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }
                      },
                      child: const Text("OK", style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              );
            });
          },
        ),
      ),
    );
  }

  void _showSlotResult(BuildContext context, int sips) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("🎰 Résultat du Jackpot !"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Tu dois boire :"),
            const SizedBox(height: 10),
            Text(
              "$sips gorgée${sips > 1 ? 's' : ''} 🍺",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}

class _GameOverContent extends StatelessWidget {
  final Color accentColor;

  const _GameOverContent({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.emoji_events_rounded, size: 62, color: accentColor),
        const SizedBox(height: 18),
        Text(
          "Partie terminée",
          textAlign: TextAlign.center,
          style: GoogleFonts.bebasNeue(fontSize: 34, color: Colors.black87),
        ),
        const SizedBox(height: 18),
        GradientButton(
          text: "Voir les résultats",
          icon: Icons.bar_chart,
          isSmall: true,
          onPressed: () async {
            final premium = context.read<PremiumProvider>();
            await context.read<AdService>().showInterstitialIfReady(
                  isPremium: premium.isPremium,
                  context: context,
                );

            if (!context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StatsScreen()),
            );
          },
        ),
      ],
    );
  }
}

class _QuestionNavigationBar extends StatelessWidget {
  final Color accentColor;
  final VoidCallback onDevilSkip;

  const _QuestionNavigationBar({
    required this.accentColor,
    required this.onDevilSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.09)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              _NavButton(
                icon: Icons.arrow_back_rounded,
                color: accentColor,
                onPressed: game.playerCount > 0 ? game.previousQuestion : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withOpacity(0.15),
                        accentColor.withOpacity(0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: accentColor.withOpacity(0.2)),
                  ),
                  child: Text(
                    game.isGameOver ? '🏁 Fin de partie' : '🍻 TCHIN !',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.bubblegumSans(
                      color: AppTheme.textPrimary,
                      fontSize: 19,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _NavButton(
                icon: Icons.local_fire_department_rounded,
                color: const Color(0xFFD7263D),
                onPressed: game.canSkipWithDevil ? onDevilSkip : null,
              ),
              const SizedBox(width: 8),
              _NavButton(
                icon: Icons.arrow_forward_rounded,
                color: accentColor,
                onPressed: game.isGameOver ? null : game.nextQuestion,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DevilSkipOverlay extends StatelessWidget {
  const _DevilSkipOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.24),
      child: Center(
        child: Container(
          width: 172,
          height: 172,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [
                Color(0xFFFFE45E),
                Color(0xFFFF6B35),
                Color(0xFF5C0D12),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF3D00).withOpacity(0.45),
                blurRadius: 36,
                spreadRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const DevilLaughAnimation(
                size: 86,
                frameDuration: Duration(milliseconds: 320),
              ),
              Text(
                'PACTE SIGNE',
                style: GoogleFonts.bebasNeue(
                  color: Colors.white,
                  fontSize: 25,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '(LOOSER)',
                style: GoogleFonts.inter(
                  color: const Color(0xFFFFF3C4),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 180.ms)
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1, 1),
              duration: 360.ms,
            )
            .shake(hz: 5, duration: 760.ms)
            .then(delay: 540.ms)
            .fadeOut(duration: 260.ms),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const _NavButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor:
            onPressed == null ? Colors.white.withOpacity(0.05) : color,
        foregroundColor: onPressed == null ? AppTheme.textMuted : Colors.white,
        fixedSize: const Size(46, 42),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _DiceSection extends StatefulWidget {
  const _DiceSection();

  @override
  State<_DiceSection> createState() => _DiceSectionState();
}

class _DiceSectionState extends State<_DiceSection> {
  final GlobalKey<DiceWidgetState> _diceKey = GlobalKey();
  String? _resultMessage;
  bool _hasRolled = false;

  void _onRollPressed() async {
    setState(() {
      _resultMessage = null; // Clear previous result
    });

    // Safety check just in case
    if (_diceKey.currentState != null) {
      final mode =
          Provider.of<GameProvider>(context, listen: false).currentMode;
      int result = await _diceKey.currentState!.roll();

      // Logic based on mode
      // Classic: result / 2 (ceil)
      // BorderLine: result = sips
      int sips = 0;

      if (mode == GameMode.borderline) {
        sips = result;
      } else {
        sips = (result / 2).ceil();
      }

      if (mounted) {
        setState(() {
          _hasRolled = true;
          _resultMessage = "🎲 $result !\nBois $sips gorgées 🍺";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DiceWidget(key: _diceKey),
        const SizedBox(height: 20),
        if (!_hasRolled)
          GradientButton(text: "Lancer le Dé", onPressed: _onRollPressed)
        else
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.secondary.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  _resultMessage ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.secondary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // TextButton(
              //    onPressed: _onRollPressed,
              //    child: const Text("Relancer", style: TextStyle(color: Colors.white54)),
              // )
            ],
          ),
      ],
    );
  }
}
