import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/card_model.dart';
import '../providers/premium_provider.dart';
import '../services/ad_service.dart';
import '../theme/app_theme.dart';
import '../widgets/game_layout.dart';
import '../widgets/poker_card_widget.dart';

class AutorouteGameScreen extends StatefulWidget {
  final int cardCount;
  final bool isHardMode;

  const AutorouteGameScreen({
    super.key,
    required this.cardCount,
    required this.isHardMode,
  });

  @override
  State<AutorouteGameScreen> createState() => _AutorouteGameScreenState();
}

class _AutorouteGameScreenState extends State<AutorouteGameScreen> {
  final math.Random _random = math.Random.secure();

  List<PlayingCard> _drawPile = [];
  List<PlayingCard> _road = [];
  Map<int, PlayingCard> _sipCards = {};
  int _currentIndex = 0;
  int _deckCycle = 0;
  int _dealToken = 0;
  bool _isGameOver = false;
  bool _isResolving = true;
  bool _allowExitPop = false;
  bool _isExitInterstitialShowing = false;
  bool _hasShownGameOverInterstitial = false;
  bool _isGameOverInterstitialShowing = false;
  String _message = "Prêt ? La première carte est posée.";
  _MessageTone _messageTone = _MessageTone.neutral;

  bool get _isMobilePlatform {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  void initState() {
    super.initState();
    _lockLandscape();
    _initGame();
  }

  @override
  void dispose() {
    _restoreOrientation();
    super.dispose();
  }

  void _lockLandscape() {
    if (!_isMobilePlatform) return;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _restoreOrientation() {
    if (!_isMobilePlatform) return;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  Future<void> _showInterstitialIfNeeded() async {
    final premium = context.read<PremiumProvider>();
    await context.read<AdService>().showInterstitialIfReady(
          isPremium: premium.isPremium,
          context: context,
        );
  }

  Future<void> _leaveGame() async {
    if (_isExitInterstitialShowing) return;
    _isExitInterstitialShowing = true;

    await _showInterstitialIfNeeded();

    if (!mounted) return;
    setState(() => _allowExitPop = true);
    Navigator.pop(context);
  }

  Future<void> _showGameOverInterstitialOnce() async {
    if (_hasShownGameOverInterstitial ||
        _isGameOverInterstitialShowing ||
        _isExitInterstitialShowing) {
      return;
    }

    _hasShownGameOverInterstitial = true;
    _isGameOverInterstitialShowing = true;

    await _showInterstitialIfNeeded();

    if (mounted) {
      _isGameOverInterstitialShowing = false;
    }
  }

  void _initGame() {
    _resetDrawPile();
    _dealNewRoad(
      message: "Paquet mélangé. La première carte est posée.",
      tone: _MessageTone.neutral,
    );
  }

  void _resetDrawPile({Set<String> excludedCardKeys = const {}}) {
    _deckCycle++;
    _drawPile = _createFullDeck()
        .where((card) => !excludedCardKeys.contains(_cardKey(card)))
        .toList()
      ..shuffle(_random);
  }

  List<PlayingCard> _createFullDeck() {
    return [
      for (final suit in Suit.values)
        for (final rank in Rank.values) PlayingCard(suit: suit, rank: rank),
    ];
  }

  List<int> _sipStopIndexes() {
    return [
      for (var index = 3; index < widget.cardCount; index += 4) index,
    ];
  }

  List<PlayingCard> _drawCards(int count) {
    final drawnCards = <PlayingCard>[];
    final drawnKeys = <String>{};

    while (drawnCards.length < count) {
      if (_drawPile.isEmpty) {
        _resetDrawPile(excludedCardKeys: drawnKeys);
      }

      final card = _drawPile.removeLast();
      final key = _cardKey(card);
      if (!drawnKeys.add(key)) continue;

      card.isFaceUp = false;
      drawnCards.add(card);
    }

    return drawnCards;
  }

  String _cardKey(PlayingCard card) {
    return '${card.suit.name}-${card.rank.name}';
  }

  void _dealNewRoad({
    required String message,
    required _MessageTone tone,
  }) {
    final sipStops = _sipStopIndexes();
    final drawnCards = _drawCards(widget.cardCount + sipStops.length);
    final road = drawnCards.take(widget.cardCount).toList();
    final sipDraws = drawnCards.skip(widget.cardCount).toList();
    final sipCards = <int, PlayingCard>{};

    for (var i = 0; i < sipStops.length; i++) {
      sipCards[sipStops[i]] = sipDraws[i]..isFaceUp = true;
    }

    final token = ++_dealToken;

    setState(() {
      _road = road;
      _sipCards = sipCards;
      _currentIndex = 0;
      _isGameOver = false;
      _isResolving = true;
      _hasShownGameOverInterstitial = false;
      _isGameOverInterstitialShowing = false;
      _message = message;
      _messageTone = tone;
      for (final card in _road) {
        card.isFaceUp = false;
      }
    });

    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted || token != _dealToken || _road.isEmpty) return;
      setState(() {
        _road.first.isFaceUp = true;
        _isResolving = false;
      });
    });
  }

  bool _isSipStop(int index) => _sipCards.containsKey(index);

  void _handleGuess(bool isPlus) {
    if (_isResolving || _isGameOver || _currentIndex >= _road.length - 1) {
      return;
    }

    final currentCard = _road[_currentIndex];
    final nextIndex = _currentIndex + 1;
    final nextCard = _road[nextIndex];
    final isCorrect = isPlus
        ? nextCard.value >= currentCard.value
        : nextCard.value <= currentCard.value;

    setState(() {
      _isResolving = true;
      nextCard.isFaceUp = true;
      _message = isPlus ? 'On tente plus haut...' : 'On tente plus bas...';
      _messageTone = _MessageTone.neutral;
    });

    Future.delayed(const Duration(milliseconds: 360), () {
      if (!mounted) return;

      if (isCorrect) {
        HapticFeedback.lightImpact();
        final reachedSipStop = _isSipStop(nextIndex);
        final completedRoad = nextIndex == _road.length - 1;
        setState(() {
          _currentIndex = nextIndex;
          _isGameOver = completedRoad;
          _isResolving = false;
          if (_isGameOver) {
            _message = "Autoroute terminee. La table a survecu.";
            _messageTone = _MessageTone.win;
          } else if (reachedSipStop) {
            _message = "Carte gorgée : une gorgée obligatoire, puis continue.";
            _messageTone = _MessageTone.sip;
          } else {
            _message = "Bien joue. Carte suivante.";
            _messageTone = _MessageTone.success;
          }
        });
        if (completedRoad) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _showGameOverInterstitialOnce();
            }
          });
        }
        return;
      }

      HapticFeedback.mediumImpact();
      setState(() {
        _message = widget.isHardMode
            ? "Raté. Gorgée, puis route redistribuée."
            : "Raté. La route est redistribuée.";
        _messageTone = _MessageTone.error;
      });

      Future.delayed(const Duration(milliseconds: 850), () {
        if (!mounted) return;

        _dealNewRoad(
          message: "Nouvelle route, nouvelle première carte.",
          tone: _MessageTone.neutral,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _allowExitPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _leaveGame();
      },
      child: GameLayout(
        showBubbles: true,
        maxFrameWidth: 1040,
        outerPadding: 8,
        framePadding: 14,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxHeight < 420;

            return Column(
              children: [
                _buildHeader(isCompact: isCompact),
                SizedBox(height: isCompact ? 8 : 12),
                Expanded(child: _buildRoadBoard()),
                SizedBox(height: isCompact ? 8 : 12),
                _buildFooter(isCompact: isCompact),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader({required bool isCompact}) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Retour',
          onPressed: _leaveGame,
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 19,
            color: Colors.white,
          ),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.08),
            fixedSize: Size(isCompact ? 38 : 42, isCompact ? 38 : 42),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            "L'AUTOROUTE",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: isCompact ? 18 : 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
        _SmallPill(
          label:
              '${(_currentIndex + 1).toString().padLeft(2, '0')}/${widget.cardCount.toString().padLeft(2, '0')}',
          color: Colors.blueAccent,
        ),
        const SizedBox(width: 8),
        _SmallPill(
          label: 'Cycle $_deckCycle',
          color: Colors.amber,
        ),
        const SizedBox(width: 8),
        _SmallPill(
          label: widget.isHardMode ? 'Hard' : 'Easy',
          color: widget.isHardMode ? Colors.redAccent : Colors.greenAccent,
        ),
      ],
    );
  }

  Widget _buildRoadBoard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = _road.length;
        if (count == 0) return const SizedBox.shrink();

        final gap = math.max(3.0, math.min(8.0, constraints.maxWidth * 0.008));
        final widthByCount = (constraints.maxWidth - gap * (count - 1)) / count;
        final widthByHeight = constraints.maxHeight / 2.25;
        final cardWidth = math.max(
          28.0,
          math.min(78.0, math.min(widthByCount, widthByHeight)),
        );
        final cardHeight = cardWidth * 1.42;
        final sipWidth = cardWidth * 0.82;
        final sipHeight = sipWidth * 1.42;
        final mainTop = sipHeight * 0.66;
        final boardHeight = mainTop + cardHeight + 22;
        final boardWidth = count * cardWidth + (count - 1) * gap;

        return Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: boardWidth,
              height: boardHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: cardWidth * 0.5,
                    right: cardWidth * 0.5,
                    top: mainTop + cardHeight * 0.52,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  for (var index = 0; index < count; index++)
                    if (_sipCards[index] != null)
                      Positioned(
                        left: index * (cardWidth + gap) +
                            (cardWidth - sipWidth) / 2,
                        top: 0,
                        child: Transform.rotate(
                          angle: index.isEven ? -0.045 : 0.045,
                          child: PokerCardWidget(
                            card: _sipCards[index]!,
                            isFaceUp: true,
                            width: sipWidth,
                            height: sipHeight,
                            cardNumber: index + 1,
                            isSipCard: true,
                          ),
                        ),
                      ),
                  for (var index = 0; index < count; index++)
                    Positioned(
                      left: index * (cardWidth + gap),
                      top: mainTop,
                      child: RepaintBoundary(
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          scale: index == _currentIndex ? 1 : 0.94,
                          child: PokerCardWidget(
                            card: _road[index],
                            isFaceUp: _road[index].isFaceUp,
                            width: cardWidth,
                            height: cardHeight,
                            cardNumber: index + 1,
                            isCurrent: index == _currentIndex,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter({required bool isCompact}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 640) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMessagePanel(isCompact: true),
              const SizedBox(height: 8),
              _isGameOver
                  ? _buildGameOverActions(isCompact: true)
                  : _buildActionButtons(isCompact: true),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              flex: 6,
              child: _buildMessagePanel(isCompact: isCompact),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 5,
              child: _isGameOver
                  ? _buildGameOverActions(isCompact: isCompact)
                  : _buildActionButtons(isCompact: isCompact),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMessagePanel({required bool isCompact}) {
    final accent = switch (_messageTone) {
      _MessageTone.error => Colors.redAccent,
      _MessageTone.success => Colors.greenAccent,
      _MessageTone.sip => Colors.amber,
      _MessageTone.win => Colors.amber,
      _MessageTone.neutral => Colors.blueAccent,
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: Container(
        key: ValueKey(_message),
        width: double.infinity,
        constraints: BoxConstraints(minHeight: isCompact ? 54 : 62),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.glassCardBg.withOpacity(0.82),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: accent.withOpacity(0.46), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.14),
              blurRadius: 22,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withOpacity(0.16),
                border: Border.all(color: accent.withOpacity(0.4)),
              ),
              child: Icon(_messageTone.icon, color: accent, size: 19),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: isCompact ? 12 : 13,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 180.ms).slideY(begin: 0.08, end: 0),
    );
  }

  Widget _buildActionButtons({required bool isCompact}) {
    return Row(
      children: [
        Expanded(
          child: _ChoiceButton(
            label: 'MOINS',
            icon: Icons.remove_rounded,
            color: Colors.redAccent,
            isDisabled: _isResolving,
            isCompact: isCompact,
            onTap: () => _handleGuess(false),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ChoiceButton(
            label: 'PLUS',
            icon: Icons.add_rounded,
            color: Colors.greenAccent,
            isDisabled: _isResolving,
            isCompact: isCompact,
            onTap: () => _handleGuess(true),
          ),
        ),
      ],
    );
  }

  Widget _buildGameOverActions({required bool isCompact}) {
    return Row(
      children: [
        Expanded(
          child: _ChoiceButton(
            label: 'MENU',
            icon: Icons.arrow_back_rounded,
            color: Colors.blueAccent,
            isCompact: isCompact,
            onTap: _leaveGame,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ChoiceButton(
            label: 'REJOUER',
            icon: Icons.restart_alt_rounded,
            color: Colors.amber,
            isCompact: isCompact,
            onTap: () async {
              await _showInterstitialIfNeeded();
              if (!mounted) return;
              _initGame();
            },
          ),
        ),
      ],
    );
  }
}

enum _MessageTone { neutral, success, error, sip, win }

extension on _MessageTone {
  IconData get icon {
    return switch (this) {
      _MessageTone.neutral => Icons.route_rounded,
      _MessageTone.success => Icons.check_rounded,
      _MessageTone.error => Icons.local_bar_rounded,
      _MessageTone.sip => Icons.local_bar_rounded,
      _MessageTone.win => Icons.flag_rounded,
    };
  }
}

class _SmallPill extends StatelessWidget {
  final String label;
  final Color color;

  const _SmallPill({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.42)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isDisabled;
  final bool isCompact;

  const _ChoiceButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isDisabled = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isDisabled ? AppTheme.textMuted : color;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: isDisabled ? 0.48 : 1,
          child: Container(
            height: isCompact ? 50 : 58,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppTheme.glassCardBg.withOpacity(0.82),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: effectiveColor.withOpacity(0.52),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: effectiveColor.withOpacity(0.18),
                  blurRadius: 18,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: effectiveColor, size: isCompact ? 20 : 22),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: isCompact ? 12 : 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
