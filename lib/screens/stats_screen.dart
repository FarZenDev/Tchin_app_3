import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/premium_provider.dart';
import '../services/ad_service.dart';
import '../widgets/ad_banner_slot.dart';
import '../widgets/game_layout.dart';
import '../widgets/gradient_button.dart';
import '../theme/app_theme.dart';
import 'devil_call_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);
    final sortedPlayers = game.playerSips.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final loserEntries = game.playerLoserScores.entries
        .where((entry) => entry.value > 0)
        .toList()
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  entry.key.toUpperCase(),
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
                                  const SizedBox(width: 4),
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

                      if (game.hasLoserScores) ...[
                        const Divider(
                            color: Colors.black, thickness: 2, height: 30),
                        Text("PACTE DU DIABLE",
                            style: GoogleFonts.courierPrime(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        const SizedBox(height: 6),
                        ...loserEntries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    entry.key.toUpperCase(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.courierPrime(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ),
                                Text(
                                  "+${entry.value} LOOSER",
                                  style: GoogleFonts.courierPrime(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF9B1C1C)),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],

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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DevilCallScreen(),
                      ),
                    );
                  },
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
