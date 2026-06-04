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
  String? _lastStoppedPlayer;
  int _stopFlashSerial = 0;
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
    Future.delayed(const Duration(milliseconds: 4200), () {
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
      _lastStoppedPlayer = player;
      _stopFlashSerial++;
    });

    final flashSerial = _stopFlashSerial;
    Future.delayed(const Duration(milliseconds: 1050), () {
      if (mounted && _stopFlashSerial == flashSerial) {
        setState(() => _lastStoppedPlayer = null);
      }
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
      child: Stack(
        children: [
          const Positioned.fill(child: _InfernalPageBackdrop()),
          Column(
            children: [
              _DevilTopBar(
                elapsed: _formatTime(_elapsed),
                isChallenge: _introDone,
              ),
              const SizedBox(height: 14),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 520),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: _introDone
                      ? _buildChallenge()
                      : const _DevilSummonIntro(key: ValueKey('intro')),
                ),
              ),
            ],
          ),
          if (_lastStoppedPlayer != null)
            Positioned.fill(
              child: IgnorePointer(
                child: _StopBurstOverlay(
                  key: ValueKey(_stopFlashSerial),
                  player: _lastStoppedPlayer!,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChallenge() {
    return Stack(
      key: const ValueKey('challenge'),
      children: [
        Column(
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
                    stoppedAt:
                        stoppedAt == null ? null : _formatTime(stoppedAt),
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
        ),
      ],
    );
  }
}

class _DevilTopBar extends StatelessWidget {
  final String elapsed;
  final bool isChallenge;

  const _DevilTopBar({
    required this.elapsed,
    required this.isChallenge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A090D), Color(0xFF10050A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.42)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF3D00).withOpacity(0.16),
            blurRadius: 22,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withOpacity(0.15),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: const Color(0xFFFFB000).withOpacity(0.36),
              ),
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Color(0xFFFFB000),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'APPEL DU DIABLE',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.bebasNeue(
                    color: Colors.white,
                    fontSize: 25,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  isChallenge ? 'defi en cours' : 'invocation',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFFFE45E),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.42),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Column(
              children: [
                Text(
                  'CHRONO',
                  style: GoogleFonts.inter(
                    color: AppTheme.textSecondary,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  elapsed,
                  style: GoogleFonts.robotoMono(
                    color: const Color(0xFFFFE45E),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
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
      duration: const Duration(milliseconds: 4200),
    )..forward();
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
          final p = _controller.value;
          final wobble = math.sin(p * math.pi * 2);
          final rise = Curves.easeOutBack.transform(
            (p / 0.78).clamp(0.0, 1.0).toDouble(),
          );
          final titleIn = Curves.easeOutCubic.transform(
            (p / 0.38).clamp(0.0, 1.0).toDouble(),
          );
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 292,
                  height: 292,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _SummonAuraPainter(progress: p),
                        ),
                      ),
                      CustomPaint(
                        size: const Size(250, 250),
                        painter: _FlameCirclePainter(progress: p),
                      ),
                      Transform.translate(
                        offset: Offset(0, 35 - (rise * 48)),
                        child: Transform.rotate(
                          angle: wobble * 0.08,
                          child: const DevilLaughAnimation(
                            size: 176,
                            frameDuration: Duration(milliseconds: 650),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Opacity(
                  opacity: titleIn,
                  child: Text(
                    'LE PACTE COMMENCE',
                    style: GoogleFonts.bebasNeue(
                      color: Colors.white,
                      fontSize: 28,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
                Text(
                  'HA HA HA',
                  style: GoogleFonts.bebasNeue(
                    color: const Color(0xFFFFE45E),
                    fontSize: 34 + (p * 5),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 210,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      minHeight: 7,
                      value: p,
                      backgroundColor: Colors.white.withOpacity(0.08),
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFFFF6B35),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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

class _InfernalPageBackdrop extends StatefulWidget {
  const _InfernalPageBackdrop();

  @override
  State<_InfernalPageBackdrop> createState() => _InfernalPageBackdropState();
}

class _InfernalPageBackdropState extends State<_InfernalPageBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _InfernalBackdropPainter(phase: _controller.value),
            );
          },
        ),
      ),
    );
  }
}

class _InfernalBackdropPainter extends CustomPainter {
  final double phase;

  const _InfernalBackdropPainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final pulse = math.sin(phase * math.pi * 2);
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF26070C), Color(0xFF0D0710), Color(0xFF161A2B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect),
    );

    final center = Offset(size.width / 2, size.height * (0.2 + pulse * 0.015));
    canvas.drawCircle(
      center,
      size.width * (0.56 + pulse * 0.025),
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFF6B35).withOpacity(0.18),
            const Color(0xFF5C0D12).withOpacity(0.08),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: size.width)),
    );

    final barPaint = Paint()
      ..color = Colors.black.withOpacity(0.22)
      ..style = PaintingStyle.fill;
    final barTop = size.height * 0.76;
    canvas.drawRect(
        Rect.fromLTWH(0, barTop, size.width, size.height), barPaint);

    final linePaint = Paint()
      ..strokeWidth = 2
      ..color = const Color(0xFFFFB000).withOpacity(0.14 + pulse.abs() * 0.08);
    canvas.drawLine(
      Offset(18, barTop),
      Offset(size.width - 18, barTop),
      linePaint,
    );

    final shelfPaint = Paint()
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFFFE45E).withOpacity(0.08);
    for (var i = 0; i < 4; i++) {
      final y = size.height * (0.82 + i * 0.045);
      canvas.drawLine(
        Offset(size.width * 0.12, y),
        Offset(size.width * 0.88, y + math.sin(phase * math.pi * 2 + i) * 1.4),
        shelfPaint,
      );
    }

    final emberPaint = Paint();
    for (var i = 0; i < 18; i++) {
      final drift = math.sin((phase * math.pi * 2) + i) * 10;
      final x = ((i * 61.0) + drift) % size.width;
      final y = size.height * (0.16 + ((i * 17) % 66) / 100) - (phase * 24);
      emberPaint.color =
          (i.isEven ? const Color(0xFFFFE45E) : const Color(0xFFFF6B35))
              .withOpacity(0.08 + ((i % 4) * 0.025));
      canvas.drawCircle(Offset(x, y), 2 + (i % 3), emberPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _InfernalBackdropPainter oldDelegate) {
    return oldDelegate.phase != phase;
  }
}

class _SummonAuraPainter extends CustomPainter {
  final double progress;

  const _SummonAuraPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final p = progress.clamp(0.0, 1.0).toDouble();
    final center = Offset(size.width / 2, size.height / 2);
    final pulse = math.sin(p * math.pi);

    canvas.drawCircle(
      center,
      size.width * (0.25 + (0.22 * p)),
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFE45E).withOpacity(0.12 + (0.15 * pulse)),
            const Color(0xFFFF6B35).withOpacity(0.16 + (0.18 * p)),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: size.width)),
    );

    final rayPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;
    for (var i = 0; i < 12; i++) {
      final angle = (math.pi * 2 / 12) * i - math.pi / 2;
      final start = size.width * (0.22 + (0.08 * p));
      final end = size.width * (0.36 + (0.12 * p));
      rayPaint.color = const Color(0xFFFFB000).withOpacity(0.08 + 0.18 * p);
      canvas.drawLine(
        Offset(
          center.dx + math.cos(angle) * start,
          center.dy + math.sin(angle) * start,
        ),
        Offset(
          center.dx + math.cos(angle) * end,
          center.dy + math.sin(angle) * end,
        ),
        rayPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SummonAuraPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _StopBurstOverlay extends StatelessWidget {
  final String player;

  const _StopBurstOverlay({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 980),
        curve: Curves.linear,
        builder: (context, value, _) {
          final intro = Curves.easeOutBack.transform(
            (value / 0.48).clamp(0.0, 1.0).toDouble(),
          );
          final fade = value < 0.72 ? 1.0 : (1 - ((value - 0.72) / 0.28));
          final shake = math.sin(value * math.pi * 8) * (1 - value) * 3.5;
          return Opacity(
            opacity: fade.clamp(0.0, 1.0).toDouble(),
            child: SizedBox(
              width: 280,
              height: 260,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _StopBurstPainter(progress: value),
                    ),
                  ),
                  Positioned(
                    top: 18 - (8 * intro),
                    child: Transform.rotate(
                      angle: -0.08 + (0.16 * intro),
                      child: const DevilLaughAnimation(
                        size: 86,
                        frameDuration: Duration(milliseconds: 115),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(shake, 42 - (18 * intro)),
                    child: Transform.scale(
                      scale: 0.74 + (0.26 * intro),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 250),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFE45E), Color(0xFFFF6B35)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.28),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF3D00).withOpacity(0.42),
                              blurRadius: 34,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              player.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.bebasNeue(
                                color: const Color(0xFF24070A),
                                fontSize: 32,
                                letterSpacing: 1.1,
                              ),
                            ),
                            Text(
                              'ARRET VALIDE',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF24070A),
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StopBurstPainter extends CustomPainter {
  final double progress;

  const _StopBurstPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final p = progress.clamp(0.0, 1.0).toDouble();
    final center = Offset(size.width / 2, size.height * 0.48);
    final pulse = math.sin(p * math.pi).clamp(0.0, 1.0).toDouble();

    canvas.drawCircle(
      center,
      size.width * (0.2 + 0.22 * p),
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFE45E).withOpacity(0.2 * pulse),
            const Color(0xFFFF6B35).withOpacity(0.26 * pulse),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: size.width)),
    );

    final sparkPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;
    for (var i = 0; i < 18; i++) {
      final angle = (math.pi * 2 / 18) * i + p * 0.28;
      final start = 42 + (p * 28);
      final end = 78 + (p * 82) + math.sin(i + p * 5) * 8;
      sparkPaint.color =
          (i.isEven ? const Color(0xFFFFE45E) : const Color(0xFFFF6B35))
              .withOpacity((1 - p).clamp(0.0, 0.72).toDouble());
      canvas.drawLine(
        Offset(
          center.dx + math.cos(angle) * start,
          center.dy + math.sin(angle) * start,
        ),
        Offset(
          center.dx + math.cos(angle) * end,
          center.dy + math.sin(angle) * end,
        ),
        sparkPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StopBurstPainter oldDelegate) {
    return oldDelegate.progress != progress;
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
    final stopped = total - remaining;
    final progress = total == 0 ? 0.0 : stopped / total;

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
          Row(
            children: [
              Expanded(
                child: Text(
                  '$remaining/$total boivent encore',
                  style: GoogleFonts.bebasNeue(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
              Text(
                '$stopped arretes',
                style: GoogleFonts.inter(
                  color: const Color(0xFFFFE45E),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 7,
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.08),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFFF6B35)),
            ),
          ),
          const SizedBox(height: 8),
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
                  ? const [Color(0xFF4A1116), Color(0xFF8A281C)]
                  : const [Color(0xFF202432), Color(0xFF171A24)],
            ),
            border: Border.all(
              color: isActive
                  ? const Color(0xFFFFB000)
                  : Colors.white.withOpacity(0.1),
              width: isActive ? 1.4 : 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF3D00).withOpacity(0.2),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(isActive ? 0.22 : 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFFFFE45E).withOpacity(0.44)
                        : const Color(0xFF7BD88F).withOpacity(0.24),
                  ),
                ),
                child: Icon(
                  isActive
                      ? Icons.local_fire_department_rounded
                      : Icons.check_circle_rounded,
                  color: isActive
                      ? const Color(0xFFFFB000)
                      : const Color(0xFF7BD88F),
                ),
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (rank == 0
                            ? const Color(0xFFFF6B35)
                            : const Color(0xFF7BD88F))
                        .withOpacity(0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    verdict,
                    style: GoogleFonts.bebasNeue(
                      color: rank == 0
                          ? const Color(0xFFFF6B35)
                          : const Color(0xFF7BD88F),
                      fontSize: 22,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE45E).withOpacity(0.16),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: const Color(0xFFFFE45E).withOpacity(0.32),
                    ),
                  ),
                  child: Text(
                    'TAPER',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFFFE45E),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
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
