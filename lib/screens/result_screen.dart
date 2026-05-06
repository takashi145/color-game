import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final state = provider.state;
    final accuracy = state.totalQuestions == 0
        ? 0.0
        : state.correctCount / state.totalQuestions * 100;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (provider.isNewHighScore) ...[
                  const Icon(Icons.emoji_events,
                      color: Colors.amber, size: 72),
                  const SizedBox(height: 8),
                  const Text('ハイスコア更新！',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber)),
                  const SizedBox(height: 16),
                ] else ...[
                  const Text('ゲーム終了',
                      style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                ],
                _ResultCard(state: state, accuracy: accuracy, highScore: provider.highScore),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _retry(context, state.mode),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('もう一度',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context)
                        .popUntil((route) => route.isFirst),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('ホームへ',
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _retry(BuildContext context, GameMode mode) {
    context.read<GameProvider>().startGame(mode);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const GameScreen()),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.state,
    required this.accuracy,
    required this.highScore,
  });

  final GameState state;
  final double accuracy;
  final int highScore;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            _row('スコア', '${state.score}点',
                style: const TextStyle(
                    fontSize: 36, fontWeight: FontWeight.bold)),
            const Divider(height: 28),
            _row('ハイスコア', '$highScore点'),
            const SizedBox(height: 12),
            _row('正解数',
                '${state.correctCount} / ${state.totalQuestions}問'),
            const SizedBox(height: 12),
            _row('正答率', '${accuracy.toStringAsFixed(1)}%'),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {TextStyle? style}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, color: Colors.black54)),
        Text(value,
            style: style ??
                const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
      ],
    );
  }
}