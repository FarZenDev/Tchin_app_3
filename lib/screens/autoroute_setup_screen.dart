import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../widgets/game_layout.dart';
import '../widgets/gradient_button.dart';
import 'autoroute_game_screen.dart';

class AutorouteSetupScreen extends StatefulWidget {
  const AutorouteSetupScreen({super.key});

  @override
  State<AutorouteSetupScreen> createState() => _AutorouteSetupScreenState();
}

class _AutorouteSetupScreenState extends State<AutorouteSetupScreen> {
  static const List<int> _allowedCardCounts = [6, 9, 12, 15, 18];

  int _cardCount = 12;
  bool _isHardMode = false;

  void _changeCardCount(int delta) {
    final currentIndex = _allowedCardCounts.indexOf(_cardCount);
    final nextIndex = (currentIndex + delta).clamp(
      0,
      _allowedCardCounts.length - 1,
    );

    setState(() {
      _cardCount = _allowedCardCounts[nextIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GameLayout(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Retour',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: Colors.white,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.08),
                  fixedSize: const Size(42, 42),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "L'AUTOROUTE",
                    style: GoogleFonts.inter(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 42),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 14),
              children: [
                _SetupHero(cardCount: _cardCount),
                const SizedBox(height: 18),
                _SectionPanel(
                  title: 'Nombre de cartes',
                  subtitle: '6, 9, 12, 15 ou 18 cartes. Gorgée au 4e arrêt.',
                  child: _CardCountControl(
                    value: _cardCount,
                    onMinus: _cardCount > 6 ? () => _changeCardCount(-1) : null,
                    onPlus: _cardCount < 18 ? () => _changeCardCount(1) : null,
                  ),
                ),
                const SizedBox(height: 14),
                _SectionPanel(
                  title: 'Difficulté',
                  subtitle: _isHardMode
                      ? 'Erreur = gorgée, puis nouvelle route.'
                      : "Erreur = nouvelle route.",
                  child: Row(
                    children: [
                      Expanded(
                        child: _DifficultyCard(
                          title: 'Easy',
                          detail: 'Nouvelle route',
                          icon: Icons.undo_rounded,
                          color: Colors.greenAccent,
                          isSelected: !_isHardMode,
                          onTap: () => setState(() => _isHardMode = false),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _DifficultyCard(
                          title: 'Hard',
                          detail: 'Gorgée en plus',
                          icon: Icons.restart_alt_rounded,
                          color: Colors.redAccent,
                          isSelected: _isHardMode,
                          onTap: () => setState(() => _isHardMode = true),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GradientButton(
            text: "Lancer l'autoroute",
            icon: Icons.play_arrow_rounded,
            isLarge: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AutorouteGameScreen(
                    cardCount: _cardCount,
                    isHardMode: _isHardMode,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SetupHero extends StatelessWidget {
  final int cardCount;

  const _SetupHero({required this.cardCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 178,
      decoration: BoxDecoration(
        color: AppTheme.glassCardBg.withOpacity(0.86),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.36)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.26),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -36,
            top: -38,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 24,
            child: const _PreviewRoad(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 142, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(999),
                    border:
                        Border.all(color: Colors.blueAccent.withOpacity(0.36)),
                  ),
                  child: Text(
                    '$cardCount cartes',
                    style: GoogleFonts.inter(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Plus ou moins',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.bebasNeue(
                    color: Colors.white,
                    fontSize: 36,
                    height: 0.95,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Cartes de pique custom Tchin. Tous les 4 arrêts, une gorgée obligatoire.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewRoad extends StatelessWidget {
  const _PreviewRoad();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 126,
      height: 132,
      child: Stack(
        children: [
          for (var index = 0; index < 4; index++)
            Positioned(
              left: 15.0 * index,
              top: 36,
              child: Transform.rotate(
                angle: (index - 1.5) * 0.06,
                child: _SetupPlayingCard(
                  rank: const ['A', '2', '3', '4'][index],
                  suit: const ['♠', '♥', '♣', '♦'][index],
                  number: (index + 1).toString().padLeft(2, '0'),
                  color: index == 3 ? Colors.blueAccent : Colors.amber,
                ),
              ),
            ),
          Positioned(
            left: 48,
            top: 0,
            child: Transform.rotate(
              angle: -0.08,
              child: _SetupPlayingCard(
                rank: '4',
                suit: '♦',
                number: 'G',
                color: Colors.amber,
                isSip: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupPlayingCard extends StatelessWidget {
  final String rank;
  final String suit;
  final String number;
  final Color color;
  final bool isSip;

  const _SetupPlayingCard({
    required this.rank,
    required this.suit,
    required this.number,
    required this.color,
    this.isSip = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 92,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF8E6), Color(0xFFF0D9AD)],
        ),
        border: Border.all(color: color.withOpacity(0.45), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rank,
            style: GoogleFonts.inter(
              color: const Color(0xFF1A1512),
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  suit,
                  style: TextStyle(
                    color: (suit == '♥' || suit == '♦')
                        ? Colors.redAccent
                        : const Color(0xFF1A1512),
                    fontSize: isSip ? 20 : 28,
                    height: 0.9,
                  ),
                ),
                if (isSip)
                  Text(
                    'GORGEE',
                    style: GoogleFonts.inter(
                      color: color,
                      fontSize: 6,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
              ],
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.rotate(
              angle: math.pi,
              child: Text(
                rank,
                style: GoogleFonts.inter(
                  color: const Color(0xFF1A1512),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SectionPanel({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.glassCardBg.withOpacity(0.78),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _CardCountControl extends StatelessWidget {
  final int value;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  const _CardCountControl({
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RoundCountButton(icon: Icons.remove_rounded, onPressed: onMinus),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 68,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.18),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.26)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value.toString().padLeft(2, '0'),
                  style: GoogleFonts.bebasNeue(
                    color: Colors.white,
                    fontSize: 42,
                    height: 0.9,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'cartes',
                  style: GoogleFonts.inter(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        _RoundCountButton(icon: Icons.add_rounded, onPressed: onPlus),
      ],
    );
  }
}

class _RoundCountButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _RoundCountButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: onPressed == null
            ? Colors.white.withOpacity(0.05)
            : Colors.blueAccent,
        foregroundColor: onPressed == null ? AppTheme.textMuted : Colors.white,
        fixedSize: const Size(54, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  final String title;
  final String detail;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyCard({
    required this.title,
    required this.detail,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          constraints: const BoxConstraints(minHeight: 92),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withOpacity(0.16)
                : Colors.black.withOpacity(0.14),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? color.withOpacity(0.72) : Colors.white12,
              width: isSelected ? 1.6 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon,
                      color: isSelected ? color : AppTheme.textMuted, size: 19),
                  const Spacer(),
                  if (isSelected)
                    Icon(Icons.check_circle_rounded, color: color, size: 18),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                detail,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
