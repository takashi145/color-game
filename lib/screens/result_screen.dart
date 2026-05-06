import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';

const _accent = Color(0xFF7C6FFF);
const _textSub = Colors.black38;

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.read<GameProvider>().isNewHighScore) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final state = provider.state;
    final accuracy = state.totalQuestions == 0
        ? 0.0
        : state.correctCount / state.totalQuestions * 100;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const SizedBox(height: 48),
                  if (provider.isNewHighScore) ...[
                    const Icon(Icons.emoji_events_rounded,
                        color: Color(0xFFFFC107), size: 48),
                    const SizedBox(height: 8),
                    const Text(
                      'ハイスコア更新！',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF59E0B)),
                    ),
                    const SizedBox(height: 4),
                  ] else ...[
                    const Text(
                      'ゲーム終了',
                      style: TextStyle(fontSize: 13, color: _textSub),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    '${state.score}',
                    style: const TextStyle(
                      fontSize: 88,
                      fontWeight: FontWeight.w800,
                      color: _accent,
                      letterSpacing: -4,
                    ),
                  ),
                  const Text(
                    'スコア',
                    style: TextStyle(fontSize: 13, color: _textSub),
                  ),
                  const SizedBox(height: 40),
                  _StatRow(
                    label: 'ハイスコア',
                    value: '${provider.highScore} pt',
                  ),
                  const Divider(color: Color(0xFFE8E8F0), height: 28),
                  _StatRow(
                    label: '正解数',
                    value: '${state.correctCount} / ${state.totalQuestions}',
                  ),
                  const Divider(color: Color(0xFFE8E8F0), height: 28),
                  _StatRow(
                    label: '正答率',
                    value: '${accuracy.toStringAsFixed(1)}%',
                  ),
                  const Divider(color: Color(0xFFE8E8F0), height: 28),
                  _StatRow(
                    label: '平均回答時間',
                    value:
                        '${(provider.avgResponseTimeMs / 1000).toStringAsFixed(2)} 秒',
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _retry(context, state.mode),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('もう一度',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.of(context).popUntil((r) => r.isFirst),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black54,
                        side: const BorderSide(color: Color(0xFFE8E8F0)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('ホームへ',
                          style: TextStyle(fontSize: 17)),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 30,
              gravity: 0.2,
              colors: const [
                Color(0xFFFFC107),
                Color(0xFFFF6B6B),
                Color(0xFF7C6FFF),
                Color(0xFF06D6A0),
                Color(0xFF74C0FC),
              ],
            ),
          ),
        ],
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

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 15, color: _textSub)),
        Text(value,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
