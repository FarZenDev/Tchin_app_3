import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import '../services/sound_service.dart';
import '../models/question_model.dart';
import '../data/questions_data.dart';

class PlayedCard {
  final String text;
  final QuestionType type;

  PlayedCard({required this.text, required this.type});
}

class GameProvider extends ChangeNotifier {
  // Game State
  final List<String> _players = [];
  GameMode? _currentMode;
  List<PlayedCard> _currentQuestionHistory = [];
  int _historyIndex = -1;

  // Stats
  Map<String, int> _playerSips = {};
  Map<String, int> _playerLoserScores = {};

  // Logic
  List<QuestionData> _availableQuestions = [];
  List<QuestionData> _usedQuestions = [];

  // Central Glass Logic
  int _poursRemaining = 0;
  final QuestionData _pourQuestion = QuestionData(
      text: "🍷 {player1}, verse un peu de ton verre dans le verre du milieu.",
      players: 1,
      type: QuestionType.centralGlass);
  final QuestionData _drinkQuestion = QuestionData(
      text: "👑 {player1}, le verre du milieu est pour toi ! Cul sec ! ☠️",
      players: 1,
      type: QuestionType.centralGlass);

  // Getters
  List<String> get players => List.unmodifiable(_players);
  GameMode? get currentMode => _currentMode;
  String get currentQuestionText =>
      _historyIndex >= 0 && _historyIndex < _currentQuestionHistory.length
          ? _currentQuestionHistory[_historyIndex].text
          : "Prêt ?";

  String get currentQuestionDisplayText {
    var text = currentQuestionText;
    final playersWithLoserScore = _players
        .where((player) => (_playerLoserScores[player] ?? 0) > 0)
        .toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    for (final player in playersWithLoserScore) {
      text = text.replaceAll(player, '$player (LOOSER)');
    }

    return text;
  }

  QuestionType get currentQuestionType =>
      _historyIndex >= 0 && _historyIndex < _currentQuestionHistory.length
          ? _currentQuestionHistory[_historyIndex].type
          : QuestionType.normal;

  int get playerCount => _players.length;
  bool get canStartGame => _players.length >= 2;
  bool get isGameOver => _currentMode != null && _availableQuestions.isEmpty;
  bool get canSkipWithDevil =>
      _currentMode != null && !isGameOver && _historyIndex > 0;

  // Stats Getters
  Map<String, int> get playerSips => _playerSips;
  Map<String, int> get playerLoserScores =>
      Map.unmodifiable(_playerLoserScores);
  bool get hasLoserScores =>
      _playerLoserScores.values.any((score) => score > 0);
  List<String> get devilCallParticipants {
    final playersWithScore = _players
        .where((player) => (_playerLoserScores[player] ?? 0) > 0)
        .toList();
    playersWithScore.sort(
      (a, b) =>
          (_playerLoserScores[b] ?? 0).compareTo(_playerLoserScores[a] ?? 0),
    );
    return playersWithScore;
  }

  List<String> get currentQuestionPlayers {
    final text = currentQuestionText;
    return _players.where((player) => text.contains(player)).toList();
  }

  void addPlayer(String name) {
    name = name.trim();
    if (name.isNotEmpty && name.length <= 12 && !_players.contains(name)) {
      _players.add(name);
      notifyListeners();
    }
  }

  void removePlayer(String name) {
    _players.remove(name);
    notifyListeners();
  }

  void setGameMode(GameMode mode) {
    _currentMode = mode;
    _resetQuestionsForMode(mode);
    SoundService.playBeerOpen();
    startGameTimer(); // Start timer!
    notifyListeners();
  }

  void _resetQuestionsForMode(GameMode mode) {
    String modeKey = mode.toString().split('.').last; // classic, hard, etc.

    // Copy the list to avoid modifying the original data
    _availableQuestions = List.from(AppData.allQuestions[modeKey] ?? []);
    _usedQuestions = [];
    _currentQuestionHistory = [
      PlayedCard(
          text: "Prêt à jouer ? Appuyez sur Suivant !",
          type: QuestionType.normal)
    ];
    _historyIndex = 0;
    _playerSips = {};
    _playerLoserScores = {};

    // Central Glass Initialization
    // Reduce frequency: roughly half the players, min 2, max 5
    int targetPours = (_players.length / 2).ceil().clamp(2, 5);
    _poursRemaining = targetPours;

    // Add "Pour" questions
    for (int i = 0; i < _poursRemaining; i++) {
      _availableQuestions.add(_pourQuestion);
    }
    // Shuffle to mix them in
    _availableQuestions.shuffle();
  }

  void nextQuestion() {
    if (_historyIndex < _currentQuestionHistory.length - 1) {
      _historyIndex++;
      notifyListeners();
      return;
    }

    _generateNewQuestion();
  }

  void previousQuestion() {
    if (_historyIndex > 0) {
      _historyIndex--;
      notifyListeners();
    }
  }

  void _generateNewQuestion() {
    if (_currentMode == null || _players.length < 2) return;

    // Filter applicable questions
    final validQuestions =
        _availableQuestions.where((q) => q.players <= _players.length).toList();

    if (validQuestions.isEmpty) {
      // Game Over
      _gameTimer?.cancel();
      _happyHourTimer?.cancel();
      _isHappyHour = false;
      _sipMultiplier = 1;
      _currentQuestionHistory.add(PlayedCard(
          text: "🏁 Fin de la partie ! Plus de questions.",
          type: QuestionType.normal));
      _historyIndex++;
      notifyListeners();
      return;
    }

    // Weighted Random Logic (Simplified from JS)
    // 60% chance for 1 player, 40% for multi-player if enough players
    QuestionData selected;
    final random = Random();

    final singlePlayerQuestions =
        validQuestions.where((q) => q.players == 1).toList();
    final multiPlayerQuestions =
        validQuestions.where((q) => q.players > 1).toList();

    // Attempt to pick a question
    // Retry logic to avoid back-to-back Central Glass questions
    int attempts = 0;
    do {
      if (multiPlayerQuestions.isNotEmpty && random.nextDouble() > 0.6) {
        selected =
            multiPlayerQuestions[random.nextInt(multiPlayerQuestions.length)];
      } else if (singlePlayerQuestions.isNotEmpty) {
        selected =
            singlePlayerQuestions[random.nextInt(singlePlayerQuestions.length)];
      } else {
        selected = validQuestions[random.nextInt(validQuestions.length)];
      }
      attempts++;
    } while (currentQuestionType == QuestionType.centralGlass &&
        selected.type == QuestionType.centralGlass &&
        attempts < 5);

    // Process selection
    _availableQuestions.remove(selected);
    _usedQuestions.add(selected);

    // Central Glass Logic Check
    if (selected == _pourQuestion) {
      _poursRemaining--;
      if (_poursRemaining <= 0) {
        // Time to drink! Add the drink question to the NEXT available slot (or very soon)
        // To make it appear random but soon, we can put it in availableQuestions and shuffle,
        // OR just insert it at a random index in the remaining questions.
        // The user request said "towards the end / middle", but "immediately after full" makes sense logic-wise
        // OR "until you finish it".
        // Let's add it to availableQuestions so it comes up naturally but definitely comes up.
        _availableQuestions.add(_drinkQuestion);
        _availableQuestions.shuffle();
      }
    }

    // Format text
    String formattedText = _formatQuestionText(selected);

    // Update stats
    _updateStats(formattedText);

    _currentQuestionHistory
        .add(PlayedCard(text: formattedText, type: selected.type));
    _historyIndex++;
    notifyListeners();
  }

  String _formatQuestionText(QuestionData question) {
    String text = question.text;
    List<String> available = List.from(_players);
    final random = Random();

    // Replace {player1}
    if (text.contains("{player1}")) {
      if (available.isEmpty)
        available = List.from(_players); // Should not happen with validation
      String p1 = available.removeAt(random.nextInt(available.length));
      text = text.replaceAll("{player1}", p1);
    }

    // Replace {player2}
    if (text.contains("{player2}")) {
      if (available.isEmpty)
        available = List.from(_players); // Recycle if needed
      String p2 = available.removeAt(random.nextInt(available.length));
      text = text.replaceAll("{player2}", p2);
    }
    // Replace {player3}
    if (text.contains("{player3}")) {
      if (available.isEmpty) available = List.from(_players);
      String p3 = available.removeAt(random.nextInt(available.length));
      text = text.replaceAll("{player3}", p3);
    }

    return text;
  }

  // Happy Hour & Timer Logic
  Timer? _gameTimer;
  Timer? _happyHourTimer;
  Duration _gameDuration = Duration.zero;
  bool _isHappyHour = false;
  int _sipMultiplier = 1;

  Duration get gameDuration => _gameDuration;
  bool get isHappyHour => _isHappyHour;
  int get sipMultiplier => _sipMultiplier;

  @override
  void dispose() {
    _gameTimer?.cancel();
    _happyHourTimer?.cancel();
    super.dispose();
  }

  void startGameTimer() {
    _gameTimer?.cancel();
    _happyHourTimer?.cancel();
    _gameDuration = Duration.zero;
    _isHappyHour = false;
    _sipMultiplier = 1;

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _gameDuration += const Duration(seconds: 1);
      _checkHappyHour();
      notifyListeners();
    });
  }

  void _checkHappyHour() {
    // Only trigger if enough time passed (e.g., > 30s) and not already active
    if (!_isHappyHour) {
      // Chance to START:
      // Fixed small probability check every second
      // Currently ~1/300 chance per second (avg 5 mins)
      if (_gameDuration.inSeconds > 30 && Random().nextInt(300) == 0) {
        _triggerHappyHour();
      }
    }
  }

  void _triggerHappyHour() {
    _isHappyHour = true;
    _sipMultiplier = 2; // DOUBLE SIPS!
    notifyListeners();

    // Auto-end after 45 seconds (Adjusted for better flow)
    _happyHourTimer?.cancel();
    _happyHourTimer = Timer(const Duration(seconds: 45), () {
      _isHappyHour = false;
      _sipMultiplier = 1;
      notifyListeners();
    });
  }

  // Modified update stats to use multiplier
  void _updateStats(String text) {
    int sips = 0;
    if (text.toLowerCase().contains("cul sec")) {
      sips = 5;
    } else if (text.toLowerCase().contains("shot"))
      sips = 2;
    else {
      final highlightRegex = RegExp(r'(\d+) gorgée');
      final match = highlightRegex.firstMatch(text);
      if (match != null) {
        sips = int.parse(match.group(1)!);
      } else if (text.toLowerCase().contains("boit") ||
          text.toLowerCase().contains("buvez")) {
        sips = 1;
      }
    }

    // APPLY MULTIPLIER
    sips *= _sipMultiplier;

    for (var player in _players) {
      if (text.contains(player)) {
        _playerSips[player] = (_playerSips[player] ?? 0) + sips;
      }
    }
  }

  void skipCurrentQuestionWithDevil() {
    if (!canSkipWithDevil || _players.isEmpty) return;

    final targets = currentQuestionPlayers.isEmpty
        ? List<String>.from(_players)
        : currentQuestionPlayers;

    for (final player in targets) {
      _playerLoserScores[player] = (_playerLoserScores[player] ?? 0) + 1;
    }

    nextQuestion();
  }

  int devilCallDeltaForRank(int rank, int totalPlayers) {
    if (totalPlayers <= 1) return -1;
    return totalPlayers - 1 - (rank * 2);
  }

  void applyDevilCallResult(List<String> stopOrder) {
    if (stopOrder.isEmpty) return;

    for (var i = 0; i < stopOrder.length; i++) {
      final player = stopOrder[i];
      final delta = devilCallDeltaForRank(i, stopOrder.length);
      final currentScore = _playerLoserScores[player] ?? 0;
      _playerLoserScores[player] = max(0, currentScore + delta);
    }

    notifyListeners();
  }

  void resetGame() {
    _gameTimer?.cancel();
    _gameDuration = Duration.zero;
    _isHappyHour = false;
    _sipMultiplier = 1;

    _players.clear();
    _currentMode = null;
    _currentQuestionHistory.clear();
    _historyIndex = -1;
    _playerSips.clear();
    _playerLoserScores.clear();
    notifyListeners();
  }
}
