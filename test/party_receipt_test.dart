import 'package:flutter_test/flutter_test.dart';
import 'package:tchin_app_3/providers/game_provider.dart';

void main() {
  test('PartyReceipt keeps frozen ticket data through json', () {
    final receipt = PartyReceipt(
      ticketNumber: '123456',
      endedAt: DateTime(2026, 6, 6, 20, 15),
      modeLabel: 'Borderline',
      duration: const Duration(minutes: 12, seconds: 34),
      players: const ['Mathis', 'Alex', 'Sam'],
      playerSips: const {
        'Mathis': 8,
        'Alex': 12,
        'Sam': 3,
      },
      playerLoserScores: const {
        'Mathis': 2,
        'Sam': 5,
      },
      questionsPlayed: 18,
      phaseLabel: 'Chaos au bar',
      chaosScore: 89,
    );

    final restored = PartyReceipt.fromJson(receipt.toJson());

    expect(restored.ticketNumber, '123456');
    expect(restored.duration, const Duration(minutes: 12, seconds: 34));
    expect(restored.totalSips, 23);
    expect(restored.totalLoser, 7);
    expect(restored.sortedPlayers.first.key, 'Alex');
    expect(restored.loserRows.first.key, 'Sam');
  });
}
