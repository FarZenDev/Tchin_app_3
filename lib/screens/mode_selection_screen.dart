import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/premium_provider.dart';
import '../models/question_model.dart';
import '../widgets/game_layout.dart';
import '../theme/app_theme.dart';
import '../theme/beer_colors.dart';
import '../widgets/ad_banner_slot.dart';
import '../widgets/beer_background.dart';
import '../widgets/liquid_transition.dart';
import 'premium_screen.dart';

class ModeSelectionScreen extends StatefulWidget {
  const ModeSelectionScreen({super.key});

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  bool _isTransitioning = false;
  Color _transitionColor = BeerColors.lager;

  void _onModeSelected(GameMode mode) {
    setState(() {
      _isTransitioning = true;
      _transitionColor = BeerColors.getForMode(mode);
    });
  }

  void _onTransitionComplete(GameMode mode) {
    Provider.of<GameProvider>(context, listen: false).setGameMode(mode);
    Provider.of<GameProvider>(context, listen: false).nextQuestion();
    Navigator.pushNamed(context, '/game').then((_) {
      if (mounted) setState(() => _isTransitioning = false);
    });
  }

  static const _modes = [
    (
      GameMode.classic,
      'Classique',
      '🍺',
      'Défis équilibrés pour tout le groupe',
      'Recommandé'
    ),
    (GameMode.duo, 'Duo', '👥', 'Parfait pour jouer à deux', 'Équipe'),
    (GameMode.bar, 'Bar', '🍸', 'Questions absurdes de bar', 'Débile'),
    (GameMode.chill, 'Chill', '😌', 'Sans alcool, sans pression', 'Zen'),
    (GameMode.hot, 'Hot', '🔥', 'Questions épicées et coquines', 'Coquin'),
    (GameMode.express, 'Express', '⚡', 'Partie rapide en 15 min', 'Flash'),
    (
      GameMode.borderline,
      'Borderline',
      '💀',
      'Zéro tabou, tout est permis',
      'Hardcore'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isTransitioning)
          Positioned.fill(
            child: LiquidTransition(
              isFilling: false,
              color: _transitionColor,
              duration: const Duration(milliseconds: 900),
              onCompleted: () {},
            ),
          ),
        GameLayout(
          customBackground: const BeerBackground(),
          child: Column(
            children: [
              // ── Header ────────────────────────────────────────────────────
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new,
                        size: 18, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.07),
                      fixedSize: const Size(40, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Mode de jeu',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ).animate().fadeIn(duration: 350.ms),

              const SizedBox(height: 4),

              Text(
                'Choisissez l\'ambiance de la soirée',
                style: GoogleFonts.inter(
                  color: AppTheme.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ).animate(delay: 80.ms).fadeIn(duration: 350.ms),

              const SizedBox(height: 18),

              // ── Liste des modes ───────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      for (int i = 0; i < _modes.length; i++) ...[
                        _ModeCard(
                          index: i,
                          mode: _modes[i].$1,
                          title: _modes[i].$2,
                          emoji: _modes[i].$3,
                          desc: _modes[i].$4,
                          badge: _modes[i].$5,
                          accentColor: BeerColors.getForMode(_modes[i].$1),
                          onTap: (mode) {
                            _onModeSelected(mode);
                            Future.delayed(
                              const Duration(milliseconds: 800),
                              () {
                                if (mounted) _onTransitionComplete(mode);
                              },
                            );
                          },
                        ),
                        if (i < _modes.length - 1) const SizedBox(height: 8),
                      ],
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              const AdBannerSlot(),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModeCard extends StatefulWidget {
  final int index;
  final GameMode mode;
  final String title;
  final String emoji;
  final String desc;
  final String badge;
  final Color accentColor;
  final void Function(GameMode) onTap;

  const _ModeCard({
    required this.index,
    required this.mode,
    required this.title,
    required this.emoji,
    required this.desc,
    required this.badge,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_ModeCard> createState() => _ModeCardState();
}

class _ModeCardState extends State<_ModeCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<PremiumProvider>(
      builder: (context, premium, _) {
        final bool isLocked = !widget.mode.isFree && !premium.isPremium;
        final color = isLocked ? Colors.white24 : widget.accentColor;

        return GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            if (isLocked) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PremiumScreen()));
            } else {
              widget.onTap(widget.mode);
            }
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed ? 0.97 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              constraints: const BoxConstraints(minHeight: 80),
              decoration: BoxDecoration(
                color: isLocked
                    ? Colors.white.withOpacity(0.03)
                    : Colors.white.withOpacity(_pressed ? 0.08 : 0.05),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isLocked
                      ? Colors.white.withOpacity(0.07)
                      : widget.accentColor.withOpacity(_pressed ? 0.6 : 0.35),
                  width: 1.3,
                ),
                boxShadow: isLocked
                    ? null
                    : [
                        BoxShadow(
                          color: widget.accentColor
                              .withOpacity(_pressed ? 0.2 : 0.1),
                          blurRadius: 20,
                        ),
                      ],
              ),
              clipBehavior: Clip.antiAlias,
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // Barre colorée latérale
                    Container(
                      width: 4,
                      color: isLocked
                          ? Colors.white.withOpacity(0.08)
                          : widget.accentColor,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            // Emoji orb
                            Container(
                              width: 48,
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color.withOpacity(0.13),
                                border:
                                    Border.all(color: color.withOpacity(0.3)),
                              ),
                              child: Text(widget.emoji,
                                  style: const TextStyle(fontSize: 24)),
                            ),
                            const SizedBox(width: 13),
                            // Texte
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: GoogleFonts.inter(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: isLocked
                                          ? AppTheme.textMuted
                                          : AppTheme.textPrimary,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.desc,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: isLocked
                                          ? AppTheme.textMuted
                                          : AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: color.withOpacity(0.35)),
                              ),
                              child: Text(
                                widget.badge,
                                style: GoogleFonts.inter(
                                  color: isLocked
                                      ? AppTheme.textMuted
                                      : widget.accentColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Icône droite
                            isLocked
                                ? Icon(Icons.lock_outline_rounded,
                                    color: AppTheme.textMuted, size: 18)
                                : Icon(Icons.chevron_right_rounded,
                                    color: widget.accentColor, size: 22),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
                .animate(delay: (widget.index * 60 + 80).ms)
                .fadeIn(duration: 400.ms)
                .slideX(begin: 0.08, duration: 350.ms, curve: Curves.easeOut),
          ),
        );
      },
    );
  }
}
