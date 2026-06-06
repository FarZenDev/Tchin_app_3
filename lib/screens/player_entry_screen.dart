import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import '../providers/premium_provider.dart';
import '../widgets/game_layout.dart';
import '../widgets/gradient_button.dart';
import '../theme/app_theme.dart';
import '../widgets/beer_background.dart';
import '../widgets/ad_banner_slot.dart';
import 'asset_preview_screen.dart';
import 'receipt_history_screen.dart';

class PlayerEntryScreen extends StatefulWidget {
  const PlayerEntryScreen({super.key});

  @override
  State<PlayerEntryScreen> createState() => _PlayerEntryScreenState();
}

class _PlayerEntryScreenState extends State<PlayerEntryScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _submitPlayer() {
    final game = Provider.of<GameProvider>(context, listen: false);
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      game.addPlayer(name);
      _controller.clear();
      _focusNode.requestFocus();
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameLayout(
      customBackground: const BeerBackground(),
      child: Stack(
        children: [
          // ── Bouton Historique ─────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            child: IconButton(
              tooltip: 'Historique',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ReceiptHistoryScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.receipt_long_rounded,
                color: Colors.white54,
                size: 22,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.06),
                fixedSize: const Size(40, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 48,
            child: IconButton(
              tooltip: 'Aperçu design',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AssetPreviewScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.palette_rounded,
                color: Colors.white54,
                size: 22,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.06),
                fixedSize: const Size(40, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
              ),
            ),
          ),

          // ── Bouton Premium ─────────────────────────────────────────────────
          Positioned(
            top: 0,
            right: 0,
            child: Consumer<PremiumProvider>(
              builder: (context, premium, _) {
                return IconButton(
                  tooltip:
                      premium.isPremium ? 'Premium actif' : 'Activer Premium',
                  onPressed: () async {
                    await premium.togglePremiumDebug();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          premium.isPremium
                              ? '✨ Premium activé — tous les modes débloqués'
                              : 'Premium désactivé.',
                        ),
                        backgroundColor: premium.isPremium
                            ? AppTheme.primary.withOpacity(0.9)
                            : AppTheme.glassCardBg,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    premium.isPremium
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color:
                        premium.isPremium ? AppTheme.secondary : Colors.white38,
                    size: 22,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.06),
                    fixedSize: const Size(40, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Contenu principal ──────────────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Hero ───────────────────────────────────────────────────────
              _HeroSection(),
              const SizedBox(height: 22),

              // ── Saisie du nom ──────────────────────────────────────────────
              _PlayerInput(
                controller: _controller,
                focusNode: _focusNode,
                onSubmit: _submitPlayer,
              ),
              const SizedBox(height: 16),

              // ── Liste des joueurs ──────────────────────────────────────────
              Expanded(child: _PlayerList()),
              const SizedBox(height: 18),

              // ── CTA ────────────────────────────────────────────────────────
              Consumer<GameProvider>(
                builder: (context, game, _) => GradientButton(
                  text: 'Commencer la fête',
                  icon: Icons.celebration_rounded,
                  isLarge: true,
                  onPressed: game.canStartGame
                      ? () => Navigator.pushNamed(context, '/categories')
                      : null,
                ),
              ),
              const AdBannerSlot(),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Hero ──────────────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo animé
        Text(
          '🍻',
          style: const TextStyle(fontSize: 52),
        )
            .animate()
            .scale(
              begin: const Offset(0.7, 0.7),
              duration: 600.ms,
              curve: Curves.elasticOut,
            )
            .fadeIn(duration: 400.ms),

        const SizedBox(height: 8),

        // Titre
        Text(
          'Tchin !',
          style: Theme.of(context).textTheme.displayLarge,
        )
            .animate(delay: 100.ms)
            .slideY(begin: 0.3, duration: 500.ms, curve: Curves.easeOut)
            .fadeIn(duration: 400.ms),

        const SizedBox(height: 4),

        // Sous-titre
        Text(
          'Le jeu festif entre amis',
          style: Theme.of(context).textTheme.bodyMedium,
        ).animate(delay: 200.ms).fadeIn(duration: 500.ms),
      ],
    );
  }
}

// ── Input ─────────────────────────────────────────────────────────────────────
class _PlayerInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSubmit;

  const _PlayerInput({
    required this.controller,
    required this.focusNode,
    required this.onSubmit,
  });

  @override
  State<_PlayerInput> createState() => _PlayerInputState();
}

class _PlayerInputState extends State<_PlayerInput> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _focused
              ? AppTheme.primary.withOpacity(0.7)
              : Colors.white.withOpacity(0.12),
          width: 1.5,
        ),
        color: Colors.white.withOpacity(0.06),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.18),
                  blurRadius: 16,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(
            Icons.person_add_rounded,
            color: _focused ? AppTheme.primary : Colors.white30,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              maxLength: 12,
              style: GoogleFonts.inter(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              onSubmitted: (_) => widget.onSubmit(),
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'Ajouter un joueur…',
                hintStyle: GoogleFonts.inter(
                  color: Colors.white24,
                  fontSize: 16,
                ),
                counterText: '',
                filled: false,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                isDense: true,
              ),
            ),
          ),
          // Bouton + intégré
          GestureDetector(
            onTap: widget.onSubmit,
            child: Container(
              margin: const EdgeInsets.all(8),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.4),
                    blurRadius: 8,
                  )
                ],
              ),
              child:
                  const Icon(Icons.add_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Liste joueurs ─────────────────────────────────────────────────────────────
class _PlayerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.07)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.groups_rounded,
                      color: AppTheme.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Invités du soir',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.primary.withOpacity(0.35),
                        ),
                      ),
                      child: Text(
                        '${game.playerCount} fêtard${game.playerCount > 1 ? 's' : ''}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: Color(0x14FFFFFF)),

              // Chips ou placeholder
              Expanded(
                child: game.players.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🥂', style: TextStyle(fontSize: 32)),
                            const SizedBox(height: 8),
                            Text(
                              'Personne pour l\'instant…',
                              style: GoogleFonts.inter(
                                color: Colors.white24,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(12),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(game.players.length, (i) {
                            final player = game.players[i];
                            return _PlayerChip(
                              name: player,
                              color: _chipColor(i),
                              onRemove: () => game.removePlayer(player),
                            )
                                .animate()
                                .scale(
                                  begin: const Offset(0.5, 0.5),
                                  duration: 300.ms,
                                  curve: Curves.elasticOut,
                                )
                                .fadeIn(duration: 200.ms);
                          }),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _chipColor(int index) {
    const colors = [
      Color(0xFFF5A623),
      Color(0xFF8B5CF6),
      Color(0xFF06B6D4),
      Color(0xFF22C55E),
      Color(0xFFEF4444),
      Color(0xFFEC4899),
      Color(0xFFF59E0B),
      Color(0xFF3B82F6),
    ];
    return colors[index % colors.length];
  }
}

// ── Player chip ───────────────────────────────────────────────────────────────
class _PlayerChip extends StatelessWidget {
  final String name;
  final Color color;
  final VoidCallback onRemove;

  const _PlayerChip({
    required this.name,
    required this.color,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Text(
            name,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded,
              size: 14,
              color: Colors.white38,
            ),
          ),
        ],
      ),
    );
  }
}
