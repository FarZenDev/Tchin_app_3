import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/game_layout.dart';
import 'autoroute_setup_screen.dart';

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameLayout(
      showBubbles: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ─────────────────────────────────────────────────────────
          Row(
            children: [
              _BackButton(onTap: () =>
                  Navigator.pushReplacementNamed(context, '/player-entry')),
              const Expanded(
                child: Center(
                  child: _ScreenTitle(text: 'Choisissez un jeu'),
                ),
              ),
              const SizedBox(width: 42),
            ],
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, duration: 400.ms),

          const SizedBox(height: 6),

          Text(
            'Deux ambiances, même table.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppTheme.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ).animate(delay: 100.ms).fadeIn(duration: 400.ms),

          const SizedBox(height: 24),

          // ── Cards ──────────────────────────────────────────────────────────
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _GameChoiceCard(
                      index: 0,
                      number: '01',
                      title: 'TCHIN',
                      subtitle: 'Questions, défis & gorgées pour toute la tablée.',
                      tag: 'Classique',
                      accentColor: const Color(0xFFF5A623),
                      cardSymbols: const ['T', '+', '2'],
                      emoji: '🍺',
                      onTap: () => Navigator.pushNamed(context, '/mode'),
                    ),
                    const SizedBox(height: 16),
                    _GameChoiceCard(
                      index: 1,
                      number: '02',
                      title: "L'AUTOROUTE",
                      subtitle: 'Plus ou moins ? Avance carte par carte.',
                      tag: 'Cartes',
                      accentColor: const Color(0xFF6C63FF),
                      cardSymbols: const ['A', '+', '-'],
                      emoji: '🃏',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AutorouteSetupScreen()),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sous-widgets ──────────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Retour',
      onPressed: onTap,
      icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.07),
        fixedSize: const Size(40, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
    );
  }
}

class _ScreenTitle extends StatelessWidget {
  final String text;
  const _ScreenTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        letterSpacing: -0.3,
      ),
    );
  }
}

class _GameChoiceCard extends StatefulWidget {
  final int index;
  final String number;
  final String title;
  final String subtitle;
  final String tag;
  final Color accentColor;
  final List<String> cardSymbols;
  final String emoji;
  final VoidCallback onTap;

  const _GameChoiceCard({
    required this.index,
    required this.number,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.accentColor,
    required this.cardSymbols,
    required this.emoji,
    required this.onTap,
  });

  @override
  State<_GameChoiceCard> createState() => _GameChoiceCardState();
}

class _GameChoiceCardState extends State<_GameChoiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _hovered = true),
      onTapUp: (_) {
        setState(() => _hovered = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(_hovered ? 0.07 : 0.04),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.accentColor.withOpacity(_hovered ? 0.6 : 0.3),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: widget.accentColor.withOpacity(_hovered ? 0.22 : 0.10),
                blurRadius: 40,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Halo de fond
              Positioned(
                top: -40,
                right: -20,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.accentColor.withOpacity(0.08),
                  ),
                ),
              ),

              // Mini card stack décorative
              Positioned(
                right: 14,
                top: 18,
                child: _MiniCardStack(
                  accentColor: widget.accentColor,
                  number: widget.number,
                  symbols: widget.cardSymbols,
                ),
              ),

              // Contenu texte
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 130, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Badge numéro
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: widget.accentColor.withOpacity(0.5)),
                          ),
                          child: Text(
                            widget.number,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Badge tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.accentColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: widget.accentColor.withOpacity(0.4)),
                          ),
                          child: Text(
                            widget.tag,
                            style: GoogleFonts.inter(
                              color: widget.accentColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(widget.emoji,
                            style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 8),
                        Text(
                          widget.title,
                          style: GoogleFonts.bebasNeue(
                            fontSize: 32,
                            height: 0.96,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        height: 1.3,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Flèche CTA
              Positioned(
                right: 14,
                bottom: 14,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.accentColor,
                    boxShadow: [
                      BoxShadow(
                        color:
                            widget.accentColor.withOpacity(_hovered ? 0.6 : 0.3),
                        blurRadius: _hovered ? 20 : 10,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        )
            .animate(delay: (widget.index * 120).ms)
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.3, duration: 450.ms, curve: Curves.easeOut),
      ),
    );
  }
}

class _MiniCardStack extends StatelessWidget {
  final Color accentColor;
  final String number;
  final List<String> symbols;

  const _MiniCardStack({
    required this.accentColor,
    required this.number,
    required this.symbols,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108,
      height: 114,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 6,
            top: 18,
            child: Transform.rotate(
              angle: -0.18,
              child: _TinyCard(
                accentColor: accentColor.withOpacity(0.7),
                label: symbols[1],
                number: number,
                isBack: true,
              ),
            ),
          ),
          Positioned(
            left: 26,
            top: 10,
            child: Transform.rotate(
              angle: 0.14,
              child: _TinyCard(
                accentColor: accentColor,
                label: symbols[2],
                number: number,
                isBack: true,
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 0,
            child: _TinyCard(
              accentColor: accentColor,
              label: symbols.first,
              number: number,
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyCard extends StatelessWidget {
  final Color accentColor;
  final String label;
  final String number;
  final bool isBack;

  const _TinyCard({
    required this.accentColor,
    required this.label,
    required this.number,
    this.isBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 100,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: isBack
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withOpacity(0.25),
                  accentColor.withOpacity(0.05),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFF8E6), Color(0xFFEDD9A3)],
              ),
        border: Border.all(
          color: isBack
              ? accentColor.withOpacity(0.4)
              : Colors.black.withOpacity(0.1),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: isBack
          ? Center(
              child: Text(
                number,
                style: GoogleFonts.bebasNeue(
                  color: accentColor.withOpacity(0.85),
                  fontSize: 28,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(number,
                    style: GoogleFonts.inter(
                      color: accentColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    )),
                const Spacer(),
                Center(
                  child: Text(label,
                      style: GoogleFonts.bebasNeue(
                        color: accentColor,
                        fontSize: 34,
                        height: 0.9,
                      )),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Transform.rotate(
                    angle: math.pi,
                    child: Text(number,
                        style: GoogleFonts.inter(
                          color: accentColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        )),
                  ),
                ),
              ],
            ),
    );
  }
}
