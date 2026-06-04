import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/devil_laugh_animation.dart';
import '../widgets/game_layout.dart';
import '../widgets/gradient_button.dart';

class DevilCallScreen extends StatefulWidget {
  const DevilCallScreen({super.key});

  @override
  State<DevilCallScreen> createState() => _DevilCallScreenState();
}

class _DevilCallScreenState extends State<DevilCallScreen> {
  late final List<String> _players;
  final List<String> _stopOrder = [];
  final Map<String, Duration> _stopTimes = {};
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _introDone = false;
  bool _resultApplied = false;

  @override
  void initState() {
    super.initState();
    _players = context.read<GameProvider>().devilCallParticipants;
    _timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (mounted && !_resultApplied) {
        setState(() => _elapsed += const Duration(milliseconds: 250));
      }
    });
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _introDone = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _stopPlayer(String player) {
    if (_resultApplied || _stopTimes.containsKey(player)) return;

    setState(() {
      _stopOrder.add(player);
      _stopTimes[player] = _elapsed;
    });

    if (_stopOrder.length == _players.length) {
      _finishChallenge();
    }
  }

  void _finishChallenge() {
    if (_resultApplied) return;
    _timer?.cancel();
    context.read<GameProvider>().applyDevilCallResult(_stopOrder);
    setState(() => _resultApplied = true);
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final tenths = (duration.inMilliseconds ~/ 100).remainder(10);
    return '$minutes:$seconds.$tenths';
  }

  @override
  Widget build(BuildContext context) {
    if (_players.isEmpty) {
      return GameLayout(
        showBubbles: true,
        child: Center(
          child: Text(
            'Aucun pacte looser a purifier.',
            textAlign: TextAlign.center,
            style: GoogleFonts.bebasNeue(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
      );
    }

    return GameLayout(
      showBubbles: true,
      maxFrameWidth: 560,
      child: Column(
        children: [
          _DevilTopBar(elapsed: _formatTime(_elapsed)),
          const SizedBox(height: 14),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 420),
              child: _introDone
                  ? _buildChallenge()
                  : const _DevilSummonIntro(key: ValueKey('intro')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallenge() {
    return Column(
      key: const ValueKey('challenge'),
      children: [
        _RulePanel(
          remaining: _players.length - _stopOrder.length,
          total: _players.length,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: _players.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final player = _players[index];
              final stoppedAt = _stopTimes[player];
              final rank =
                  stoppedAt == null ? null : _stopOrder.indexOf(player);

              return _HellPlayerTile(
                name: player,
                isActive: stoppedAt == null,
                stoppedAt: stoppedAt == null ? null : _formatTime(stoppedAt),
                rank: rank,
                totalPlayers: _players.length,
                onTap: () => _stopPlayer(player),
              );
            },
          ),
        ),
        if (_resultApplied) ...[
          const SizedBox(height: 12),
          _ResultPanel(
            stopOrder: _stopOrder,
            totalPlayers: _players.length,
          ),
          const SizedBox(height: 12),
          GradientButton(
            text: 'Retour au ticket',
            icon: Icons.receipt_long_rounded,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ],
    );
  }
}

class _DevilTopBar extends StatelessWidget {
  final String elapsed;

  const _DevilTopBar({required this.elapsed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B0B0E).withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.42)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department_rounded,
              color: Color(0xFFFFB000)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'LE TCHIN BAR INFERNAL',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.bebasNeue(
                color: Colors.white,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              elapsed,
              style: GoogleFonts.robotoMono(
                color: const Color(0xFFFFE45E),
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DevilSummonIntro extends StatefulWidget {
  const _DevilSummonIntro({super.key});

  @override
  State<_DevilSummonIntro> createState() => _DevilSummonIntroState();
}

class _DevilSummonIntroState extends State<_DevilSummonIntro>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final wobble = math.sin(_controller.value * math.pi * 2);
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 230,
                  height: 230,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(220, 220),
                        painter:
                            _FlameCirclePainter(progress: _controller.value),
                      ),
                      Transform.translate(
                        offset: Offset(0, 22 - (_controller.value * 34)),
                        child: Transform.rotate(
                          angle: wobble * 0.08,
                          child: const DevilLaughAnimation(
                            size: 158,
                            frameDuration: Duration(milliseconds: 86),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'HA HA HA',
                  style: GoogleFonts.bebasNeue(
                    color: const Color(0xFFFFE45E),
                    fontSize: 34 + (_controller.value * 5),
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'Le diable ouvre le bar.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FlameCirclePainter extends CustomPainter {
  final double progress;

  const _FlameCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.32;
    final ringPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFFE45E), Color(0xFFFF6B35), Color(0xFF5C0D12)],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.8));

    canvas.drawCircle(center, radius + 20, ringPaint);
    canvas.drawCircle(
      center,
      radius - 8,
      Paint()..color = const Color(0xFF12060A),
    );

    final flamePaint = Paint()..color = const Color(0xFFFF6B35);
    for (var i = 0; i < 18; i++) {
      final angle = (math.pi * 2 / 18) * i + (progress * 0.08);
      final outer = radius + 34 + (math.sin(progress * math.pi * 2 + i) * 5);
      final base = radius + 12;
      final p1 = Offset(
        center.dx + math.cos(angle - 0.06) * base,
        center.dy + math.sin(angle - 0.06) * base,
      );
      final p2 = Offset(
        center.dx + math.cos(angle) * outer,
        center.dy + math.sin(angle) * outer,
      );
      final p3 = Offset(
        center.dx + math.cos(angle + 0.06) * base,
        center.dy + math.sin(angle + 0.06) * base,
      );
      canvas.drawPath(Path()..addPolygon([p1, p2, p3], true), flamePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FlameCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _RulePanel extends StatelessWidget {
  final int remaining;
  final int total;

  const _RulePanel({required this.remaining, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$remaining/$total boivent encore',
            style: GoogleFonts.bebasNeue(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tape un joueur quand il arrete. Le premier garde le pacte looser, les derniers peuvent le purifier.',
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 12,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _HellPlayerTile extends StatelessWidget {
  final String name;
  final bool isActive;
  final String? stoppedAt;
  final int? rank;
  final int totalPlayers;
  final VoidCallback onTap;

  const _HellPlayerTile({
    required this.name,
    required this.isActive,
    required this.stoppedAt,
    required this.rank,
    required this.totalPlayers,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final verdict = rank == null ? null : _verdictForRank(rank!, totalPlayers);

    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      scale: isActive ? 1 : 0.97,
      child: InkWell(
        onTap: isActive ? onTap : null,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: isActive
                  ? const [Color(0xFF3B1114), Color(0xFF722019)]
                  : const [Color(0xFF202432), Color(0xFF171A24)],
            ),
            border: Border.all(
              color: isActive
                  ? const Color(0xFFFFB000)
                  : Colors.white.withOpacity(0.1),
              width: isActive ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isActive
                    ? Icons.local_fire_department_rounded
                    : Icons.check_circle_rounded,
                color: isActive
                    ? const Color(0xFFFFB000)
                    : const Color(0xFF7BD88F),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      isActive
                          ? 'boit encore'
                          : '${_rankText(rank!, totalPlayers)} a $stoppedAt',
                      style: GoogleFonts.inter(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (verdict != null)
                Text(
                  verdict,
                  style: GoogleFonts.bebasNeue(
                    color: rank == 0
                        ? const Color(0xFFFF6B35)
                        : const Color(0xFF7BD88F),
                    fontSize: 22,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _rankText(int rank, int totalPlayers) {
    if (rank == 0) return 'premier arret';
    if (rank == totalPlayers - 1) return 'dernier debout';
    return 'arret valide';
  }

  String _verdictForRank(int rank, int totalPlayers) {
    if (rank == 0) return 'PACTE';
    if (rank == totalPlayers - 1) return 'PURIFIE';
    return 'SAUVE';
  }
}

class _ResultPanel extends StatelessWidget {
  final List<String> stopOrder;
  final int totalPlayers;

  const _ResultPanel({
    required this.stopOrder,
    required this.totalPlayers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF16070A).withOpacity(0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFB000).withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verdict du diable',
            style: GoogleFonts.bebasNeue(
              color: const Color(0xFFFFE45E),
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 6),
          ...stopOrder.asMap().entries.map((entry) {
            final verdict = entry.key == 0
                ? 'PACTE'
                : entry.key == totalPlayers - 1
                    ? 'PURIFIE'
                    : 'SAUVE';
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.value,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    verdict,
                    style: GoogleFonts.inter(
                      color: entry.key == 0
                          ? const Color(0xFFFF6B35)
                          : const Color(0xFF7BD88F),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
