import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/premium_provider.dart';
import '../services/ad_service.dart';
import '../widgets/ad_banner_slot.dart';
import '../widgets/devil_laugh_animation.dart';
import '../widgets/game_layout.dart';
import '../widgets/gradient_button.dart';
import '../theme/app_theme.dart';
import 'devil_call_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  Future<void> _launchDevilCall(BuildContext context) async {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Appel du diable',
      barrierColor: Colors.black.withOpacity(0.78),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) => const _DevilCallLaunchOverlay(),
      transitionBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 2900));
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pop();

    await Future.delayed(const Duration(milliseconds: 90));
    if (!context.mounted) return;
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 620),
        reverseTransitionDuration: const Duration(milliseconds: 260),
        pageBuilder: (_, __, ___) => const DevilCallScreen(),
        transitionsBuilder: (context, animation, _, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: Transform.scale(
              scale: 0.96 + (0.04 * curved.value),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);
    final loserPlayers = game.playerLoserScores.entries
        .where((entry) => entry.value > 0)
        .map((entry) => entry.key)
        .toSet();
    final playerRows = Map<String, int>.from(game.playerSips);
    for (final player in loserPlayers) {
      playerRows.putIfAbsent(player, () => 0);
    }
    final sortedPlayers = playerRows.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    int totalSips = sortedPlayers.fold(0, (sum, item) => sum + item.value);

    return GameLayout(
      showBubbles: true,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Receipt Container
              ClipPath(
                clipper: _ReceiptPathClipper(),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 0), // Removed extra margin
                  padding: const EdgeInsets.fromLTRB(
                      16, 40, 16, 50), // Reduced horizontal padding
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F5E6), // White/Paper color
                    boxShadow: [
                      BoxShadow(color: Colors.black45, blurRadius: 20)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo / Header
                      const Center(
                        child: Icon(Icons.receipt_long,
                            color: Colors.black87, size: 40),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          "LE TCHIN BAR",
                          style: GoogleFonts.courierPrime(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: 2),
                        ),
                      ),
                      Center(
                        child: Text(
                          DateTime.now().toString().substring(0, 16),
                          style: GoogleFonts.courierPrime(
                              fontSize: 12, color: Colors.black54),
                        ),
                      ),
                      const Divider(
                          color: Colors.black, thickness: 2, height: 30),

                      // Items (Players)
                      if (sortedPlayers.isEmpty)
                        Center(
                            child: Text("Rien à payer...",
                                style: GoogleFonts.courierPrime(
                                    color: Colors.black))),

                      ...sortedPlayers.map((entry) {
                        final loserScore =
                            game.playerLoserScores[entry.key] ?? 0;
                        final loserLabel =
                            loserScore > 0 ? ' (LOOSER $loserScore)' : '';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${entry.key.toUpperCase()}$loserLabel',
                                  style: GoogleFonts.courierPrime(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Row(
                                children: [
                                  Text(
                                    "${entry.value}",
                                    style: GoogleFonts.courierPrime(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    "GOR",
                                    style: GoogleFonts.courierPrime(
                                        fontSize: 12, color: Colors.black54),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }),

                      const Divider(
                          color: Colors.black, thickness: 2, height: 30),

                      // Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("TOTAL",
                              style: GoogleFonts.courierPrime(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text("$totalSips GORGÉES",
                              style: GoogleFonts.courierPrime(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "MERCI DE VOTRE VISITE !",
                          style: GoogleFonts.courierPrime(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Barcode fake
                      Container(
                        height: 40,
                        color: Colors.black12,
                        child: const Center(
                            child: Text("||| || ||||| ||| ||",
                                style: TextStyle(
                                    fontFamily: 'monospace',
                                    letterSpacing: 4))),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Controls
              if (game.hasLoserScores) ...[
                GradientButton(
                  text: "Appel du diable",
                  icon: Icons.local_fire_department_rounded,
                  onPressed: () => _launchDevilCall(context),
                ),
                const SizedBox(height: 12),
              ],
              GradientButton(
                text: "Retour au menu",
                icon: Icons.home,
                onPressed: () async {
                  final premium = context.read<PremiumProvider>();
                  await context.read<AdService>().showInterstitialIfReady(
                        isPremium: premium.isPremium,
                        context: context,
                        ignoreFrequencyCap: true,
                      );

                  if (!context.mounted) return;
                  Navigator.of(context).popUntil(ModalRoute.withName('/mode'));
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  game.resetGame();
                  Navigator.of(context).popUntil(ModalRoute.withName('/'));
                },
                child: const Text("Nouvelle partie complète",
                    style: TextStyle(color: AppTheme.textSecondary)),
              ),
              const AdBannerSlot(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DevilCallLaunchOverlay extends StatefulWidget {
  const _DevilCallLaunchOverlay();

  @override
  State<_DevilCallLaunchOverlay> createState() =>
      _DevilCallLaunchOverlayState();
}

class _DevilCallLaunchOverlayState extends State<_DevilCallLaunchOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = math.min(MediaQuery.sizeOf(context).width * 0.88, 390.0);
    return Material(
      color: Colors.transparent,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final p = _controller.value;
            final rise = Curves.easeOutBack.transform(
              (p.clamp(0.0, 0.78).toDouble()) / 0.78,
            );
            final titleIn = Curves.easeOutCubic.transform(
              (p / 0.42).clamp(0.0, 1.0).toDouble(),
            );
            final flash = Curves.easeOut.transform(
              ((p - 0.72) / 0.28).clamp(0.0, 1.0).toDouble(),
            );

            return Container(
              color: Colors.black.withOpacity(0.55 + (0.26 * p)),
              child: Center(
                child: SizedBox(
                  width: width,
                  height: 470,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _LaunchPortalPainter(progress: p),
                        ),
                      ),
                      Positioned(
                        top: 46 - (16 * titleIn),
                        child: Opacity(
                          opacity: titleIn,
                          child: Text(
                            'APPEL DU DIABLE',
                            style: GoogleFonts.bebasNeue(
                              color: const Color(0xFFFFE45E),
                              fontSize: 43,
                              letterSpacing: 1.4,
                              shadows: [
                                Shadow(
                                  color:
                                      const Color(0xFFFF3D00).withOpacity(0.9),
                                  blurRadius: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 132 - (42 * rise),
                        child: Transform.scale(
                          scale: 0.74 + (0.28 * rise),
                          child: const DevilLaughAnimation(
                            size: 190,
                            frameDuration: Duration(milliseconds: 360),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 76,
                        left: 38,
                        right: 38,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                minHeight: 8,
                                value: p,
                                backgroundColor: Colors.white.withOpacity(0.09),
                                valueColor: const AlwaysStoppedAnimation(
                                  Color(0xFFFF6B35),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Opacity(
                              opacity: (0.35 + (0.65 * p))
                                  .clamp(0.0, 1.0)
                                  .toDouble(),
                              child: Text(
                                flash > 0.6
                                    ? 'Le pacte est ouvert'
                                    : 'Le bar infernal se reveille',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (flash > 0)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              color: const Color(0xFFFFE45E)
                                  .withOpacity(0.16 * (1 - flash)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LaunchPortalPainter extends CustomPainter {
  final double progress;

  const _LaunchPortalPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final p = progress.clamp(0.0, 1.0).toDouble();
    final center = Offset(size.width / 2, size.height * 0.46);
    final pulse = math.sin(p * math.pi);

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFE45E).withOpacity(0.18 + (0.15 * pulse)),
          const Color(0xFFFF6B35).withOpacity(0.22 + (0.22 * p)),
          const Color(0xFF5C0D12).withOpacity(0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.35, 0.68, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: size.width * 0.72),
      );
    canvas.drawCircle(center, size.width * (0.28 + (0.22 * p)), glowPaint);

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8
      ..color = const Color(0xFFFF6B35).withOpacity(0.74);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 103 + (8 * pulse)),
      -math.pi / 2 + (p * math.pi * 0.4),
      math.pi * 2 * p,
      false,
      ringPaint,
    );

    final emberPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;
    for (var i = 0; i < 22; i++) {
      final angle = (math.pi * 2 / 22) * i + (p * math.pi * 0.18);
      final distance = 80 + (p * 86) + (math.sin(i + p * 4) * 12);
      final point = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );
      emberPaint.color =
          (i.isEven ? const Color(0xFFFFE45E) : const Color(0xFFFF6B35))
              .withOpacity(
        (0.18 + (0.48 * p)).clamp(0.0, 0.66).toDouble(),
      );
      canvas.drawLine(
        point,
        point.translate(math.cos(angle) * 18, math.sin(angle) * 18),
        emberPaint,
      );
    }

    final crackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFFFB000).withOpacity(0.34 + (0.34 * p));
    final baseY = size.height * 0.78;
    for (var i = 0; i < 5; i++) {
      final startX = size.width * (0.27 + i * 0.115);
      final length = 22 + (p * (26 + i * 5));
      final path = Path()
        ..moveTo(startX, baseY)
        ..lineTo(startX + (i.isEven ? length : -length), baseY + 18)
        ..lineTo(
            startX + (i.isEven ? length * 0.55 : -length * 0.55), baseY + 34);
      canvas.drawPath(path, crackPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LaunchPortalPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _ReceiptClipper extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // We assume the background is drawn by the Container, but Container rect doesn't support Jagged Edge natively easily without ClipPath.
    // So we'll actually use this painter to Clip OR just draw white bg.
    // Actually ClipPath is better. Let's swap CustomPaint for ClipPath or just draw the shape here if we used CustomPaint as a wrapper?
    // No, the code above uses CustomPaint(child: Container). CustomPaint paints BEHIND child.
    // If we want the container to assume the shape, we should use ClipPath.
    // But wait, creating a receipt jagged edge at the bottom:
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Better Implementation: Use ClipPath
class _ReceiptPathClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 20);

    // Jagged edges
    double toothWidth = 20.0;
    int toothCount = (size.width / toothWidth).ceil();
    for (int i = 0; i < toothCount; i++) {
      double x = i * toothWidth;
      path.lineTo(x + toothWidth / 2, size.height);
      path.lineTo(x + toothWidth, size.height - 20);
    }

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
