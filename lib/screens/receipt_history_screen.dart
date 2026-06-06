import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/ad_banner_slot.dart';
import '../widgets/beer_background.dart';
import '../widgets/clean_scroll_behavior.dart';
import '../widgets/game_layout.dart';
import 'stats_screen.dart';

class ReceiptHistoryScreen extends StatefulWidget {
  const ReceiptHistoryScreen({super.key});

  @override
  State<ReceiptHistoryScreen> createState() => _ReceiptHistoryScreenState();
}

class _ReceiptHistoryScreenState extends State<ReceiptHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<GameProvider>().refreshReceiptHistory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GameLayout(
      customBackground: const BeerBackground(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Retour',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: Colors.white,
                ),
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
                    'Historique',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Les tickets des parties terminées',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppTheme.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Consumer<GameProvider>(
              builder: (context, game, _) {
                if (!game.receiptHistoryLoaded && game.receiptHistory.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppTheme.primary),
                  );
                }

                if (game.receiptHistory.isEmpty) {
                  return const _EmptyHistory();
                }

                return ScrollConfiguration(
                  behavior: const CleanScrollBehavior(),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: game.receiptHistory.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final receipt = game.receiptHistory[index];
                      return _HistoryTicketCard(
                        receipt: receipt,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StatsScreen(receipt: receipt),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const AdBannerSlot(),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.045),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.receipt_long_rounded,
              color: AppTheme.primary,
              size: 38,
            ),
            const SizedBox(height: 12),
            Text(
              "Aucun ticket pour l'instant",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Termine une partie pour l'ajouter ici.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppTheme.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTicketCard extends StatelessWidget {
  final PartyReceipt receipt;
  final VoidCallback onTap;

  const _HistoryTicketCard({
    required this.receipt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final topName = receipt.topDrinker?.key ?? 'Aucun joueur';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.055),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.09)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.22),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.16),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primary.withOpacity(0.34)),
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                color: AppTheme.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TICKET #${receipt.ticketNumber}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${_formatHistoryDate(receipt.endedAt)} · ${receipt.modeLabel}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: AppTheme.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$topName · ${receipt.totalSips} gorgees · ${receipt.totalLoser} looser',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFFFC46B),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatDuration(receipt.duration),
                  style: GoogleFonts.robotoMono(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textSecondary,
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _formatHistoryDate(DateTime date) {
  String two(int value) => value.toString().padLeft(2, '0');
  return '${two(date.day)}/${two(date.month)} ${two(date.hour)}:${two(date.minute)}';
}

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  if (duration.inHours <= 0) return '$minutes:$seconds';
  final hours = duration.inHours.toString().padLeft(2, '0');
  return '$hours:$minutes:$seconds';
}
