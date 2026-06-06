enum GameMode {
  classic(isFree: true, displayName: 'Classique'),
  hard(isFree: true, displayName: 'Confirmer'),
  duo(isFree: false, displayName: 'Duo'),
  bar(isFree: false, displayName: 'Bar'),
  chill(isFree: false, displayName: 'Chill'),
  hot(isFree: false, displayName: 'Hot'),
  express(isFree: false, displayName: 'Express'),
  borderline(isFree: false, displayName: 'BorderLine');

  final bool isFree;
  final String displayName;

  const GameMode({required this.isFree, required this.displayName});
}

enum BorderlineIntensity {
  sale(displayName: 'Sale', level: 1),
  tresSale(displayName: 'Très sale', level: 2),
  aucunFiltre(displayName: 'Aucun filtre', level: 3);

  final String displayName;
  final int level;

  const BorderlineIntensity({
    required this.displayName,
    required this.level,
  });
}

enum QuestionTag {
  sexe,
  drogue,
  mensonge,
  ex,
  argent,
  trahison,
  dm,
  proces,
  choixImpossible,
  balance,
  toxicite,
  after,
  telephone,
  ego,
  honte,
}

enum QuestionType {
  normal,
  ticTacToe,
  dice,
  centralGlass,
  wheel,
  slotMachine,
}

class Question {
  final String text;
  final int players;
  final QuestionType type;

  const Question({
    required this.text,
    required this.players,
    this.type = QuestionType.normal,
  });

  // Helper to extract sip count for stats
  int get sipCount {
    final sipPatterns = [
      RegExp(r'bois (\d+) gorgée?s?', caseSensitive: false), // bois X gorgées
      RegExp(r'bois (\d+) verre?s?',
          caseSensitive: false), // bois X verres (x3 default)
      RegExp(r'cul sec', caseSensitive: false), // x5
      RegExp(r'shot', caseSensitive: false), // x2
      RegExp(r'(\d+) gorgée?s?', caseSensitive: false), // X gorgées
    ];

    // Simple extraction logic similar to JS
    // Note: complex multipliers are hard to regex perfectly without the full logic,
    // but this covers the basics for the MVP stats.

    // Default values matching JS logic roughly
    if (text.toLowerCase().contains("cul sec")) return 5;
    if (text.toLowerCase().contains("shot")) return 2;

    for (var pattern in sipPatterns) {
      final match = pattern.firstMatch(text);
      if (match != null && match.groupCount >= 1) {
        return int.tryParse(match.group(1) ?? '0') ?? 0;
      }
    }

    // Default fallback if "boit" is present but no number
    if (text.toLowerCase().contains("boit") ||
        text.toLowerCase().contains("bois")) {
      return 1;
    }

    return 0;
  }
}
