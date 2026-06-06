import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/premium_provider.dart';
import '../services/ad_service.dart';
import '../widgets/ad_banner_slot.dart';
import '../widgets/clean_scroll_behavior.dart';
import '../widgets/devil_laugh_animation.dart';
import '../widgets/game_layout.dart';
import '../widgets/gradient_button.dart';
import '../theme/app_theme.dart';
import 'devil_call_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsScreen extends StatefulWidget {
  final PartyReceipt? receipt;

  const StatsScreen({super.key, this.receipt});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late final PartyReceipt _fallbackReceipt;

  @override
  void initState() {
    super.initState();
    final game = context.read<GameProvider>();
    _fallbackReceipt = widget.receipt ??
        game.currentReceipt ??
        (game.isGameOver
            ? game.ensureCurrentReceipt()
            : PartyReceipt.fromGame(game));
  }

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

    await Future.delayed(const Duration(milliseconds: 3300));
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
    final game = context.watch<GameProvider>();
    final isHistoryView = widget.receipt != null;
    final receipt = widget.receipt ?? game.currentReceipt ?? _fallbackReceipt;
    final sortedPlayers = receipt.sortedPlayers;
    final loserRows = receipt.loserRows;

    return GameLayout(
      showBubbles: false,
      customBackground: const _StatsBarBackdrop(),
      maxFrameWidth: 520,
      outerPadding: 10,
      framePadding: 14,
      child: Center(
        child: ScrollConfiguration(
          behavior: const CleanScrollBehavior(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ReceiptHero(
                  totalSips: receipt.totalSips,
                  totalLoser: receipt.totalLoser,
                  playerCount: receipt.playerCount,
                  phaseLabel: receipt.phaseLabel,
                  chaosScore: receipt.chaosScore,
                ),
                const SizedBox(height: 14),
                _ReceiptPaper(
                  ticketNumber: receipt.ticketNumber,
                  dateLabel: _formatReceiptDate(receipt.endedAt),
                  modeLabel: receipt.modeLabel,
                  durationLabel: _formatDuration(receipt.duration),
                  players: sortedPlayers,
                  loserScores: receipt.playerLoserScores,
                  loserRows: loserRows,
                  topDrinker: receipt.topDrinker,
                  topLoser: receipt.topLoser,
                  totalSips: receipt.totalSips,
                  totalLoser: receipt.totalLoser,
                  questionsPlayed: receipt.questionsPlayed,
                  phaseLabel: receipt.phaseLabel,
                  chaosScore: receipt.chaosScore,
                ),
                const SizedBox(height: 18),
                if (!isHistoryView && receipt.hasLoserScores) ...[
                  _DevilCallTeaser(
                    loserRows: loserRows,
                    totalLoser: receipt.totalLoser,
                    chaosScore: receipt.chaosScore,
                    onPressed: () => _launchDevilCall(context),
                  ),
                  const SizedBox(height: 12),
                ],
                if (isHistoryView)
                  GradientButton(
                    text: "Retour",
                    icon: Icons.arrow_back_rounded,
                    onPressed: () => Navigator.pop(context),
                  )
                else ...[
                  GradientButton(
                    text: "Retour au menu",
                    icon: Icons.home,
                    onPressed: () async {
                      game.ensureCurrentReceipt();
                      final premium = context.read<PremiumProvider>();
                      await context.read<AdService>().showInterstitialIfReady(
                            isPremium: premium.isPremium,
                            context: context,
                            ignoreFrequencyCap: true,
                          );

                      if (!context.mounted) return;
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName('/mode'));
                    },
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      game.ensureCurrentReceipt();
                      game.resetGame();
                      Navigator.of(context).popUntil(ModalRoute.withName('/'));
                    },
                    child: const Text(
                      "Nouvelle partie complète",
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                const AdBannerSlot(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formatReceiptDate(DateTime date) {
  String two(int value) => value.toString().padLeft(2, '0');
  return '${two(date.day)}/${two(date.month)}/${date.year}  '
      '${two(date.hour)}:${two(date.minute)}';
}

String _formatDuration(Duration duration) {
  if (duration.inSeconds <= 0) return '00:00';
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  if (duration.inHours <= 0) return '$minutes:$seconds';
  final hours = duration.inHours.toString().padLeft(2, '0');
  return '$hours:$minutes:$seconds';
}

class _ReceiptHero extends StatelessWidget {
  final int totalSips;
  final int totalLoser;
  final int playerCount;
  final String phaseLabel;
  final int chaosScore;

  const _ReceiptHero({
    required this.totalSips,
    required this.totalLoser,
    required this.playerCount,
    required this.phaseLabel,
    required this.chaosScore,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.22),
              border: Border.all(
                color: const Color(0xFFFFC46B).withOpacity(0.32),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B35).withOpacity(0.18),
                  blurRadius: 28,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Color(0xFFFFC46B),
              size: 30,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'ADDITION DE LA SOIREE',
            textAlign: TextAlign.center,
            style: GoogleFonts.bebasNeue(
              color: AppTheme.textPrimary,
              fontSize: 34,
              letterSpacing: 1.1,
              shadows: [
                Shadow(
                  color: const Color(0xFFFF6B35).withOpacity(0.42),
                  blurRadius: 18,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$playerCount joueurs  •  $totalSips gorgees  •  $totalLoser looser',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${phaseLabel.toUpperCase()}  •  CHAOS $chaosScore%',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: const Color(0xFFFFC46B),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _DevilCallTeaser extends StatelessWidget {
  final List<MapEntry<String, int>> loserRows;
  final int totalLoser;
  final int chaosScore;
  final VoidCallback onPressed;

  const _DevilCallTeaser({
    required this.loserRows,
    required this.totalLoser,
    required this.chaosScore,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final topLoser = loserRows.isEmpty ? 'Aucun pacte' : loserRows.first.key;
    final participantCount = loserRows.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF331017), Color(0xFF17080D), Color(0xFF24100A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFFFC46B).withOpacity(0.32)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF3D00).withOpacity(0.18),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
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
                      color: const Color(0xFFFF3D00).withOpacity(0.34),
                      blurRadius: 22,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: DevilLaughAnimation(
                    size: 42,
                    frameDuration: Duration(milliseconds: 420),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PACTE DISPONIBLE',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: const Color(0xFFFFC46B),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Appel du diable',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.bebasNeue(
                        color: Colors.white,
                        fontSize: 32,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      '$topLoser mene la dette du comptoir',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              _DevilTeaserStat(
                label: 'JOUEURS',
                value: participantCount.toString(),
              ),
              const SizedBox(width: 8),
              _DevilTeaserStat(
                label: 'DETTE',
                value: totalLoser.toString(),
              ),
              const SizedBox(width: 8),
              _DevilTeaserStat(
                label: 'CHAOS',
                value: '$chaosScore%',
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            'Lance le defi: les premiers qui arretent prennent la dette, les derniers la nettoient.',
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 12,
              height: 1.28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 13),
          GradientButton(
            text: "Lancer l'appel",
            icon: Icons.local_fire_department_rounded,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

class _DevilTeaserStat extends StatelessWidget {
  final String label;
  final String value;

  const _DevilTeaserStat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.26),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppTheme.textMuted,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.robotoMono(
                color: const Color(0xFFFFE45E),
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptPaper extends StatelessWidget {
  final String ticketNumber;
  final String dateLabel;
  final String modeLabel;
  final String durationLabel;
  final List<MapEntry<String, int>> players;
  final Map<String, int> loserScores;
  final List<MapEntry<String, int>> loserRows;
  final MapEntry<String, int>? topDrinker;
  final MapEntry<String, int>? topLoser;
  final int totalSips;
  final int totalLoser;
  final int questionsPlayed;
  final String phaseLabel;
  final int chaosScore;

  const _ReceiptPaper({
    required this.ticketNumber,
    required this.dateLabel,
    required this.modeLabel,
    required this.durationLabel,
    required this.players,
    required this.loserScores,
    required this.loserRows,
    required this.topDrinker,
    required this.topLoser,
    required this.totalSips,
    required this.totalLoser,
    required this.questionsPlayed,
    required this.phaseLabel,
    required this.chaosScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.62),
            blurRadius: 34,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: const Color(0xFFFFC46B).withOpacity(0.12),
            blurRadius: 42,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: ClipPath(
        clipper: _ReceiptPathClipper(),
        child: CustomPaint(
          painter: const _ReceiptPaperPainter(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 28, 18, 44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ReceiptHeader(
                  ticketNumber: ticketNumber,
                  dateLabel: dateLabel,
                ),
                const SizedBox(height: 14),
                _ReceiptMetaGrid(
                  modeLabel: modeLabel,
                  durationLabel: durationLabel,
                  playerCount: players.length,
                  questionsPlayed: questionsPlayed,
                  phaseLabel: phaseLabel,
                  chaosScore: chaosScore,
                ),
                const _ReceiptDivider(height: 24),
                if (players.isEmpty)
                  Center(
                    child: Text(
                      'AUCUNE LIGNE A ENCAISSER',
                      style: GoogleFonts.courierPrime(
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                else
                  ...List.generate(players.length, (index) {
                    final entry = players[index];
                    return _ReceiptPlayerLine(
                      rank: index + 1,
                      name: entry.key,
                      sips: entry.value,
                      loserScore: loserScores[entry.key] ?? 0,
                    );
                  }),
                const _ReceiptDivider(height: 24),
                _ReceiptTotalLine(
                  totalSips: totalSips,
                  totalLoser: totalLoser,
                ),
                const SizedBox(height: 14),
                _ReceiptHighlights(
                  topDrinker: topDrinker,
                  topLoser: topLoser,
                ),
                if (loserRows.isNotEmpty) ...[
                  const _ReceiptDivider(height: 22),
                  _LoserScoreSection(loserRows: loserRows),
                ],
                const SizedBox(height: 18),
                Center(
                  child: Transform.rotate(
                    angle: -0.045,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF7A1D16),
                          width: 1.8,
                        ),
                      ),
                      child: Text(
                        'PAYE EN GORGEES',
                        style: GoogleFonts.courierPrime(
                          color: const Color(0xFF7A1D16),
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'MERCI DE VOTRE VISITE !',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.courierPrime(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                _ReceiptBarcode(ticketNumber: ticketNumber),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReceiptHeader extends StatelessWidget {
  final String ticketNumber;
  final String dateLabel;

  const _ReceiptHeader({
    required this.ticketNumber,
    required this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.local_bar_rounded, color: Colors.black87, size: 34),
        const SizedBox(height: 8),
        Text(
          'LE TCHIN BAR',
          textAlign: TextAlign.center,
          style: GoogleFonts.courierPrime(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'TICKET #$ticketNumber',
          textAlign: TextAlign.center,
          style: GoogleFonts.courierPrime(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          dateLabel,
          textAlign: TextAlign.center,
          style: GoogleFonts.courierPrime(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

class _ReceiptMetaGrid extends StatelessWidget {
  final String modeLabel;
  final String durationLabel;
  final int playerCount;
  final int questionsPlayed;
  final String phaseLabel;
  final int chaosScore;

  const _ReceiptMetaGrid({
    required this.modeLabel,
    required this.durationLabel,
    required this.playerCount,
    required this.questionsPlayed,
    required this.phaseLabel,
    required this.chaosScore,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.045),
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.black.withOpacity(0.18),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _ReceiptMetaItem(label: 'MODE', value: modeLabel),
                ),
                Expanded(
                  child: _ReceiptMetaItem(label: 'DUREE', value: durationLabel),
                ),
                Expanded(
                  child: _ReceiptMetaItem(
                    label: 'JOUEURS',
                    value: playerCount.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _ReceiptMetaItem(
                    label: 'CARTES',
                    value: questionsPlayed.toString(),
                  ),
                ),
                Expanded(
                  child: _ReceiptMetaItem(
                    label: 'AMBIANCE',
                    value: phaseLabel,
                  ),
                ),
                Expanded(
                  child: _ReceiptMetaItem(
                    label: 'CHAOS',
                    value: '$chaosScore%',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptMetaItem extends StatelessWidget {
  final String label;
  final String value;

  const _ReceiptMetaItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.courierPrime(
            color: Colors.black54,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value.toUpperCase(),
            maxLines: 1,
            style: GoogleFonts.courierPrime(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReceiptPlayerLine extends StatelessWidget {
  final int rank;
  final String name;
  final int sips;
  final int loserScore;

  const _ReceiptPlayerLine({
    required this.rank,
    required this.name,
    required this.sips,
    required this.loserScore,
  });

  @override
  Widget build(BuildContext context) {
    final hasLoser = loserScore > 0;
    final displayName =
        hasLoser ? '${name.toUpperCase()} (LOOSER)' : name.toUpperCase();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Text(
              rank.toString().padLeft(2, '0'),
              style: GoogleFonts.courierPrime(
                fontSize: 13,
                color: Colors.black45,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.courierPrime(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                if (hasLoser)
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      '+$loserScore POINT${loserScore > 1 ? 'S' : ''} LOOSER',
                      style: GoogleFonts.courierPrime(
                        fontSize: 10,
                        color: const Color(0xFF7A1D16),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.4,
                      ),
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
                sips.toString(),
                style: GoogleFonts.courierPrime(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
              Text(
                'GOR',
                style: GoogleFonts.courierPrime(
                  fontSize: 10,
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReceiptTotalLine extends StatelessWidget {
  final int totalSips;
  final int totalLoser;

  const _ReceiptTotalLine({
    required this.totalSips,
    required this.totalLoser,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'TOTAL',
              style: GoogleFonts.courierPrime(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  '$totalSips GORGEES',
                  style: GoogleFonts.courierPrime(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (totalLoser > 0) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DETTE DU DIABLE',
                style: GoogleFonts.courierPrime(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF7A1D16),
                ),
              ),
              Text(
                '$totalLoser POINT${totalLoser > 1 ? 'S' : ''}',
                style: GoogleFonts.courierPrime(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF7A1D16),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ReceiptHighlights extends StatelessWidget {
  final MapEntry<String, int>? topDrinker;
  final MapEntry<String, int>? topLoser;

  const _ReceiptHighlights({
    required this.topDrinker,
    required this.topLoser,
  });

  @override
  Widget build(BuildContext context) {
    final drinkerText = topDrinker == null
        ? 'AUCUN CLIENT'
        : '${topDrinker!.key.toUpperCase()} · ${topDrinker!.value} GOR';
    final loserText = topLoser == null
        ? 'AUCUN PACTE'
        : '${topLoser!.key.toUpperCase()} · ${topLoser!.value} LOS';

    return Column(
      children: [
        _ReceiptHighlightLine(
          label: 'CLIENT DU SOIR',
          value: drinkerText,
        ),
        const SizedBox(height: 6),
        _ReceiptHighlightLine(
          label: 'PACTE LE PLUS CHARGE',
          value: loserText,
        ),
      ],
    );
  }
}

class _ReceiptHighlightLine extends StatelessWidget {
  final String label;
  final String value;

  const _ReceiptHighlightLine({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.courierPrime(
              fontSize: 11,
              color: Colors.black54,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.courierPrime(
              fontSize: 11,
              color: Colors.black87,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoserScoreSection extends StatelessWidget {
  final List<MapEntry<String, int>> loserRows;

  const _LoserScoreSection({required this.loserRows});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'COMPTE LOOSER',
          style: GoogleFonts.courierPrime(
            color: const Color(0xFF7A1D16),
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 7),
        ...loserRows.take(5).map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    entry.key.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.courierPrime(
                      color: Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '${entry.value} POINT${entry.value > 1 ? 'S' : ''}',
                  style: GoogleFonts.courierPrime(
                    color: const Color(0xFF7A1D16),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _ReceiptDivider extends StatelessWidget {
  final double height;

  const _ReceiptDivider({required this.height});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: height,
          child: Center(
            child: CustomPaint(
              size: Size(constraints.maxWidth, 2),
              painter: const _ReceiptDividerPainter(),
            ),
          ),
        );
      },
    );
  }
}

class _ReceiptBarcode extends StatelessWidget {
  final String ticketNumber;

  const _ReceiptBarcode({required this.ticketNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      color: Colors.black.withOpacity(0.09),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: CustomPaint(
        painter: _ReceiptBarcodePainter(seed: ticketNumber),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            'TCHIN-$ticketNumber',
            style: GoogleFonts.courierPrime(
              fontSize: 8,
              color: Colors.black45,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsBarBackdrop extends StatelessWidget {
  const _StatsBarBackdrop();

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: CustomPaint(
        painter: _StatsBarBackdropPainter(),
      ),
    );
  }
}

class _StatsBarBackdropPainter extends CustomPainter {
  const _StatsBarBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFF090A12),
            Color(0xFF14101A),
            Color(0xFF07070C),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect),
    );

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFF6B35).withOpacity(0.2),
          const Color(0xFFF5A623).withOpacity(0.05),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.5, size.height * 0.18),
          radius: size.width * 0.7,
        ),
      );
    canvas.drawRect(rect, glowPaint);

    final shelfPaint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFFFC46B).withOpacity(0.11);
    final bottlePaint = Paint();
    for (var row = 0; row < 4; row++) {
      final y = size.height * (0.14 + row * 0.105);
      canvas.drawLine(
        Offset(size.width * 0.08, y),
        Offset(size.width * 0.92, y),
        shelfPaint,
      );
      for (var i = 0; i < 11; i++) {
        final x = size.width * 0.1 + i * size.width * 0.082;
        final h = 16.0 + ((i + row) % 4) * 7;
        final color = [
          const Color(0xFFFFC46B),
          const Color(0xFFFF6B35),
          const Color(0xFF7BD88F),
          const Color(0xFFB66CFF),
        ][(i + row) % 4];
        bottlePaint.color = color.withOpacity(0.055);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y - h - 4, 10 + (i % 2) * 3, h),
            const Radius.circular(3),
          ),
          bottlePaint,
        );
      }
    }

    final spotlight = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFFC46B).withOpacity(0.12),
          Colors.transparent,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    for (var i = 0; i < 3; i++) {
      final x = size.width * (0.2 + i * 0.3);
      final cone = Path()
        ..moveTo(x - 34, 0)
        ..lineTo(x + 34, 0)
        ..lineTo(x + 112, size.height * 0.78)
        ..lineTo(x - 112, size.height * 0.78)
        ..close();
      canvas.drawPath(cone, spotlight);
    }

    final barTop = size.height * 0.78;
    final counterPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF080509).withOpacity(0.96),
          const Color(0xFF2A140D).withOpacity(0.9),
          const Color(0xFF050408).withOpacity(0.98),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    final counter = Path()
      ..moveTo(0, barTop + 28)
      ..quadraticBezierTo(
        size.width * 0.5,
        barTop - 24,
        size.width,
        barTop + 28,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(counter, counterPaint);

    final vignette = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          Colors.black.withOpacity(0.7),
        ],
        stops: const [0.42, 1],
      ).createShader(rect);
    canvas.drawRect(rect, vignette);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ReceiptPaperPainter extends CustomPainter {
  const _ReceiptPaperPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFFFFFBEF),
            Color(0xFFF5EEDB),
            Color(0xFFFFF8E8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(rect),
    );

    final grainPaint = Paint()
      ..strokeWidth = 1
      ..color = Colors.black.withOpacity(0.035);
    for (var i = 0; i < 34; i++) {
      final y = 12.0 + i * 17;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y + ((i % 3) - 1) * 0.7),
        grainPaint,
      );
    }

    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.transparent,
            const Color(0xFF7A4A12).withOpacity(0.12),
          ],
          stops: const [0.65, 1],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ReceiptDividerPainter extends CustomPainter {
  const _ReceiptDividerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.square
      ..color = Colors.black.withOpacity(0.78);
    const dash = 10.0;
    const gap = 5.0;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(
          Offset(x, 0), Offset(math.min(x + dash, size.width), 0), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ReceiptBarcodePainter extends CustomPainter {
  final String seed;

  const _ReceiptBarcodePainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.34);
    final codeUnits = seed.codeUnits.isEmpty ? [1, 2, 3, 4] : seed.codeUnits;
    var x = 0.0;
    var index = 0;
    while (x < size.width) {
      final value = codeUnits[index % codeUnits.length];
      final barWidth = 1.0 + (value % 4);
      final gap = 2.0 + (value % 3);
      final height = size.height * (0.52 + ((value % 5) * 0.06));
      canvas.drawRect(
        Rect.fromLTWH(x, 0, barWidth, height),
        paint,
      );
      x += barWidth + gap;
      index++;
    }
  }

  @override
  bool shouldRepaint(covariant _ReceiptBarcodePainter oldDelegate) {
    return oldDelegate.seed != seed;
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
      duration: const Duration(milliseconds: 3200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = math.min(size.width * 0.88, 390.0);
    final height = math.min(size.height * 0.82, 500.0);
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
                  height: height,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _LaunchPortalPainter(progress: p),
                        ),
                      ),
                      Positioned(
                        top: 32 - (14 * titleIn),
                        child: Opacity(
                          opacity: titleIn,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 13,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.32),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: const Color(0xFFFFC46B)
                                        .withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  'LE TCHIN BAR PRESENTE',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFFFC46B),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.3,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'APPEL DU DIABLE',
                                style: GoogleFonts.bebasNeue(
                                  color: const Color(0xFFFFE45E),
                                  fontSize: 43,
                                  letterSpacing: 1.4,
                                  shadows: [
                                    Shadow(
                                      color: const Color(0xFFFF3D00)
                                          .withOpacity(0.9),
                                      blurRadius: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 155 - (50 * rise),
                        child: Transform.scale(
                          scale: 0.74 + (0.28 * rise),
                          child: const DevilLaughAnimation(
                            size: 190,
                            frameDuration: Duration(milliseconds: 360),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 72,
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

    final stagePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFFC46B).withOpacity(0.1 * p),
          Colors.transparent,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Offset.zero & size);
    for (var i = 0; i < 3; i++) {
      final x = size.width * (0.18 + i * 0.32);
      final path = Path()
        ..moveTo(x - 28, 0)
        ..lineTo(x + 28, 0)
        ..lineTo(x + 68, size.height * 0.78)
        ..lineTo(x - 68, size.height * 0.78)
        ..close();
      canvas.drawPath(path, stagePaint);
    }

    final shelfPaint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFFFC46B).withOpacity(0.12 * p);
    for (var i = 0; i < 2; i++) {
      final y = size.height * (0.62 + i * 0.08);
      canvas.drawLine(
        Offset(size.width * 0.18, y),
        Offset(size.width * 0.82, y),
        shelfPaint,
      );
    }

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
