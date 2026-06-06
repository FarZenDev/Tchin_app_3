import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/clean_scroll_behavior.dart';
import '../widgets/devil_laugh_animation.dart';
import '../widgets/game_layout.dart';
import '../widgets/gradient_button.dart';

const _hellBarBackgroundAsset =
    'assets/devil_call/hell_bar_background_clean.png';
const _hellBarAtmosphereAsset =
    'assets/devil_call/hell_bar_atmosphere_overlay.png';
const _hellBarFlamesAsset = 'assets/devil_call/hell_bar_flame_edges.png';

class DevilCallScreen extends StatefulWidget {
  const DevilCallScreen({super.key});

  @override
  State<DevilCallScreen> createState() => _DevilCallScreenState();
}

class _DevilCallScreenState extends State<DevilCallScreen> {
  late final List<String> _players;
  late final Map<String, int> _startingLoserScores;
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
    final game = context.read<GameProvider>();
    _players = game.devilCallParticipants;
    _startingLoserScores = game.playerLoserScores;
    Future.delayed(const Duration(milliseconds: 4200), () {
      if (!mounted) return;
      setState(() => _introDone = true);
      _startChallengeTimer();
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

  void _startChallengeTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (mounted && !_resultApplied) {
        setState(() => _elapsed += const Duration(milliseconds: 250));
      }
    });
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
      showBubbles: false,
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
                  transitionBuilder: (child, animation) {
                    final curved = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    );
                    return FadeTransition(
                      opacity: curved,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.035),
                          end: Offset.zero,
                        ).animate(curved),
                        child: child,
                      ),
                    );
                  },
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
    if (_resultApplied) {
      return ScrollConfiguration(
        key: const ValueKey('challenge-result'),
        behavior: const CleanScrollBehavior(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            children: [
              _RulePanel(
                remaining: _players.length - _stopOrder.length,
                total: _players.length,
              ),
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
          ),
        ),
      );
    }

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
              child: ScrollConfiguration(
                behavior: const CleanScrollBehavior(),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 8),
                  itemCount: _players.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final player = _players[index];
                    final stoppedAt = _stopTimes[player];
                    final rank =
                        stoppedAt == null ? null : _stopOrder.indexOf(player);

                    return _HellPlayerTile(
                      slotNumber: index + 1,
                      name: player,
                      loserScore: _startingLoserScores[player] ?? 0,
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
            ),
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
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 13),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF311015), Color(0xFF17070C), Color(0xFF0B0508)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFC46B).withOpacity(0.34)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF3D00).withOpacity(0.18),
            blurRadius: 28,
            spreadRadius: 1,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.16),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFFFFE45E).withOpacity(0.36),
                  ),
                ),
                child: const Icon(
                  Icons.nightlife_rounded,
                  color: Color(0xFFFFE45E),
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LE TCHIN BAR',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: const Color(0xFFFFC46B),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.8,
                      ),
                    ),
                    Text(
                      'APPEL DU DIABLE',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.bebasNeue(
                        color: Colors.white,
                        fontSize: 29,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.44),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.09)),
                ),
                child: Column(
                  children: [
                    Text(
                      'CHRONO',
                      style: GoogleFonts.inter(
                        color: AppTheme.textSecondary,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                      ),
                    ),
                    Text(
                      elapsed,
                      style: GoogleFonts.robotoMono(
                        color: const Color(0xFFFFE45E),
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: const Color(0xFFFFC46B).withOpacity(0.18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  isChallenge ? 'SERVICE EN COURS' : 'INVOCATION EN COURS',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFFFE45E),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: const Color(0xFFFFC46B).withOpacity(0.18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_bar_rounded,
                size: 14,
                color: Color(0xFFFFC46B),
              ),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  isChallenge
                      ? 'Tape les noms quand les verres tombent'
                      : 'Le comptoir descend aux enfers',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
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
                    'LA TOURNEE DES DAMNES',
                    style: GoogleFonts.bebasNeue(
                      color: Colors.white,
                      fontSize: 30,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
                Text(
                  'PACTE EN COURS',
                  style: GoogleFonts.bebasNeue(
                    color: const Color(0xFFFFE45E),
                    fontSize: 34 + (p * 4),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 228,
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
                Opacity(
                  opacity: titleIn,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.28),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: const Color(0xFFFFC46B).withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_bar_rounded,
                          color: Color(0xFFFFC46B),
                          size: 15,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Dernier service avant la sentence',
                          textAlign: TextAlign.center,
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
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              _hellBarBackgroundAsset,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              gaplessPlayback: true,
            ),
            Container(
              color: const Color(0xFF050408).withOpacity(0.16),
            ),
            Opacity(
              opacity: 0.86,
              child: Image.asset(
                _hellBarAtmosphereAsset,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
                gaplessPlayback: true,
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _HellBarAssetOverlayPainter(
                    phase: _controller.value,
                  ),
                );
              },
            ),
            Opacity(
              opacity: 0.88,
              child: Image.asset(
                _hellBarFlamesAsset,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
                gaplessPlayback: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HellBarAssetOverlayPainter extends CustomPainter {
  final double phase;

  const _HellBarAssetOverlayPainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final pulse = math.sin(phase * math.pi * 2);

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.black.withOpacity(0.08),
            Colors.transparent,
            Colors.black.withOpacity(0.28),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect),
    );

    final readableCenter = Offset(size.width / 2, size.height * 0.5);
    canvas.drawCircle(
      readableCenter,
      size.width * 0.56,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.black.withOpacity(0.38),
            Colors.black.withOpacity(0.18),
            Colors.transparent,
          ],
          stops: const [0.0, 0.68, 1.0],
        ).createShader(
          Rect.fromCircle(center: readableCenter, radius: size.width * 0.62),
        ),
    );

    final warmGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFF6B35).withOpacity(0.11 + pulse.abs() * 0.04),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height * 0.83),
          radius: size.width * 0.72,
        ),
      );
    canvas.drawRect(rect, warmGlow);

    final emberPaint = Paint();
    for (var i = 0; i < 24; i++) {
      final drift = math.sin(phase * math.pi * 2 + i * 0.8) * 12;
      final x = ((i * 47.0) + drift) % size.width;
      final y = size.height * (0.18 + ((i * 23) % 72) / 100) - phase * 34;
      final color =
          i.isEven ? const Color(0xFFFFC46B) : const Color(0xFFFF6B35);
      emberPaint.color = color.withOpacity(0.07 + (i % 5) * 0.018);
      canvas.drawCircle(
        Offset(x, y < 0 ? y + size.height * 0.74 : y),
        1.4 + (i % 3) * 0.7,
        emberPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HellBarAssetOverlayPainter oldDelegate) {
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

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.2
      ..color = const Color(0xFFFFC46B).withOpacity(0.18 + 0.2 * p);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width * (0.33 + 0.04 * p)),
      -math.pi / 2 + p * 0.4,
      math.pi * 1.55,
      false,
      ringPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width * (0.41 + 0.04 * p)),
      math.pi / 2 - p * 0.32,
      math.pi * 1.2,
      false,
      ringPaint..strokeWidth = 1.4,
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
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF211218).withOpacity(0.94),
            const Color(0xFF12080D).withOpacity(0.96),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFC46B).withOpacity(0.24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.14),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: const Color(0xFFFFE45E).withOpacity(0.26),
                  ),
                ),
                child: const Icon(
                  Icons.sports_bar_rounded,
                  color: Color(0xFFFFC46B),
                  size: 19,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MANCHE INFERNALE',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFFFC46B),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.3,
                      ),
                    ),
                    Text(
                      '$remaining/$total boivent encore',
                      style: GoogleFonts.bebasNeue(
                        color: Colors.white,
                        fontSize: 27,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE45E).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: const Color(0xFFFFE45E).withOpacity(0.24),
                  ),
                ),
                child: Text(
                  '$stopped STOP',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFFFE45E),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.08),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFFF6B35)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Premier arret: pacte. Dernier debout: purification.',
                  style: GoogleFonts.inter(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.touch_app_rounded,
                color: Color(0xFFFFC46B),
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _BaremChip(
                label: '1ER ARRET',
                value: _formatDelta(total <= 1 ? -1 : total - 1),
                color: const Color(0xFFFF6B35),
              ),
              const SizedBox(width: 8),
              _BaremChip(
                label: 'DERNIER',
                value: _formatDelta(total <= 1 ? -1 : 1 - total),
                color: const Color(0xFF7BD88F),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDelta(int value) {
    if (value == 0) return '0';
    return value > 0 ? '+$value' : '$value';
  }
}

class _BaremChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _BaremChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: AppTheme.textSecondary,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: GoogleFonts.robotoMono(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HellPlayerTile extends StatelessWidget {
  final int slotNumber;
  final String name;
  final int loserScore;
  final bool isActive;
  final String? stoppedAt;
  final int? rank;
  final int totalPlayers;
  final VoidCallback onTap;

  const _HellPlayerTile({
    required this.slotNumber,
    required this.name,
    required this.loserScore,
    required this.isActive,
    required this.stoppedAt,
    required this.rank,
    required this.totalPlayers,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final verdict = rank == null ? null : _verdictForRank(rank!, totalPlayers);
    final orderLabel = rank == null ? '$slotNumber' : '${rank! + 1}';
    final delta = rank == null ? null : _deltaForRank(rank!, totalPlayers);
    final deltaLabel = delta == null
        ? null
        : delta == 0
            ? '0'
            : delta > 0
                ? '+$delta'
                : '$delta';

    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      scale: isActive ? 1 : 0.97,
      child: InkWell(
        onTap: isActive ? onTap : null,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: isActive
                  ? const [Color(0xFF521217), Color(0xFF8A281C)]
                  : const [Color(0xFF222A36), Color(0xFF141820)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
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
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(isActive ? 0.22 : 0.12),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFFFFE45E).withOpacity(0.44)
                        : const Color(0xFF7BD88F).withOpacity(0.24),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      isActive
                          ? Icons.local_fire_department_rounded
                          : Icons.check_circle_rounded,
                      color: isActive
                          ? const Color(0xFFFFB000)
                          : const Color(0xFF7BD88F),
                      size: 25,
                    ),
                    Positioned(
                      right: 4,
                      bottom: 2,
                      child: Text(
                        orderLabel,
                        style: GoogleFonts.robotoMono(
                          color: Colors.white.withOpacity(0.82),
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
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
                          ? 'verre en cours · $loserScore looser'
                          : '${_rankText(rank!, totalPlayers)} a $stoppedAt · $deltaLabel looser',
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
                    '$verdict $deltaLabel',
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
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE45E).withOpacity(0.16),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: const Color(0xFFFFE45E).withOpacity(0.32),
                    ),
                  ),
                  child: Text(
                    'STOP',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFFFE45E),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.6,
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

  int _deltaForRank(int rank, int totalPlayers) {
    if (totalPlayers <= 1) return -1;
    return totalPlayers - 1 - (rank * 2);
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
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF241015), Color(0xFF12070B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFFC46B).withOpacity(0.36)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF3D00).withOpacity(0.16),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withOpacity(0.14),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: const Color(0xFFFFE45E).withOpacity(0.28),
                    ),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: Color(0xFFFFC46B),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VERDICT DU DIABLE',
                        style: GoogleFonts.bebasNeue(
                          color: const Color(0xFFFFE45E),
                          fontSize: 28,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        'Le ticket de caisse est mis a jour',
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
            if (stopOrder.length > 1) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ResultSpotlight(
                      label: 'PACTE',
                      name: stopOrder.first,
                      color: const Color(0xFFFF6B35),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: _ResultSpotlight(
                      label: 'PURIFIE',
                      name: stopOrder.last,
                      color: const Color(0xFF7BD88F),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            ...stopOrder.asMap().entries.map((entry) {
              final rank = entry.key;
              final verdict = rank == 0
                  ? 'PACTE'
                  : rank == totalPlayers - 1
                      ? 'PURIFIE'
                      : 'SAUVE';
              return _ResultRow(
                rank: rank + 1,
                name: entry.value,
                verdict: verdict,
                delta: _deltaForRank(rank),
              );
            }),
          ],
        ),
      ),
    );
  }

  int _deltaForRank(int rank) {
    if (totalPlayers <= 1) return -1;
    return totalPlayers - 1 - (rank * 2);
  }
}

class _ResultSpotlight extends StatelessWidget {
  final String label;
  final String name;
  final Color color;

  const _ResultSpotlight({
    required this.label,
    required this.name,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final int rank;
  final String name;
  final String verdict;
  final int delta;

  const _ResultRow({
    required this.rank,
    required this.name,
    required this.verdict,
    required this.delta,
  });

  @override
  Widget build(BuildContext context) {
    final positive = delta > 0;
    final neutral = delta == 0;
    final color = positive
        ? const Color(0xFFFF6B35)
        : neutral
            ? const Color(0xFFFFC46B)
            : const Color(0xFF7BD88F);
    final deltaLabel = neutral
        ? '0'
        : positive
            ? '+$delta'
            : '$delta';

    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Row(
        children: [
          Text(
            '#$rank',
            style: GoogleFonts.robotoMono(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            verdict,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 43,
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.13),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              deltaLabel,
              textAlign: TextAlign.center,
              style: GoogleFonts.robotoMono(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
