
enum Suit { clubs, diamonds, hearts, spades }
enum Rank { ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king }

class PlayingCard {
  final Suit suit;
  final Rank rank;
  bool isFaceUp;

  PlayingCard({
    required this.suit,
    required this.rank,
    this.isFaceUp = false,
  });

  int get value {
    switch (rank) {
      case Rank.ace: return 14;
      case Rank.king: return 13;
      case Rank.queen: return 12;
      case Rank.jack: return 11;
      case Rank.ten: return 10;
      case Rank.nine: return 9;
      case Rank.eight: return 8;
      case Rank.seven: return 7;
      case Rank.six: return 6;
      case Rank.five: return 5;
      case Rank.four: return 4;
      case Rank.three: return 3;
      case Rank.two: return 2;
    }
  }

  String get suitSvg {
    switch (suit) {
      case Suit.clubs: return '♣';
      case Suit.diamonds: return '♦';
      case Suit.hearts: return '♥';
      case Suit.spades: return '♠';
    }
  }

  String get rankText {
    switch (rank) {
      case Rank.ace: return 'A';
      case Rank.king: return 'K';
      case Rank.queen: return 'Q';
      case Rank.jack: return 'J';
      case Rank.ten: return '10';
      default: return value.toString();
    }
  }
}
