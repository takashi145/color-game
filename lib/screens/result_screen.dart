import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/best_score_record.dart';
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

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late final ConfettiController _confettiController;
  late final AnimationController _fadeController;

  // 上から順に表示: スコア → テーブル → ボタン
  late final Animation<double> _fadeScore;
  late final Animation<double> _fadeTable;
  late final Animation<double> _fadeButtons;

  static const _total = Duration(milliseconds: 1500);

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _fadeController = AnimationController(vsync: this, duration: _total)
      ..forward();
    _fadeScore = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );
    _fadeTable = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.25, 0.7, curve: Curves.easeOut),
    );
    _fadeButtons = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );
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
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final state = provider.state;
    final record = provider.isNewHighScore
        ? (provider.previousBestRecord ?? provider.bestRecordForMode(state.mode))
        : provider.bestRecordForMode(state.mode);
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, color: _textSub),
                      onPressed: () =>
                          Navigator.of(context).popUntil((r) => r.isFirst),
                    ),
                  ),
                  FadeTransition(
                    opacity: _fadeScore,
                    child: Column(
                      children: [
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  FadeTransition(
                    opacity: _fadeTable,
                    child: _ComparisonTable(
                      state: state,
                      accuracy: accuracy,
                      avgResponseTimeMs: provider.avgResponseTimeMs,
                      record: record,
                    ),
                  ),
                  const Spacer(),
                  FadeTransition(
                    opacity: _fadeButtons,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _confirmRetry(context, state.mode),
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
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
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

  Future<void> _confirmRetry(BuildContext context, GameMode mode) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('もう一度プレイ'),
        content: const Text('もう一度プレイしますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('プレイ'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<GameProvider>().startGame(mode);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const GameScreen()),
      );
    }
  }
}

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable({
    required this.state,
    required this.accuracy,
    required this.avgResponseTimeMs,
    required this.record,
  });

  final GameState state;
  final double accuracy;
  final int avgResponseTimeMs;
  final BestScoreRecord record;

  String _avgTime(int ms) =>
      '${(ms / 1000).toStringAsFixed(2)} 秒';

  @override
  Widget build(BuildContext context) {
    final hasRecord = record.hasRecord;
    final bestAccuracy = record.accuracy * 100;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              const Expanded(flex: 3, child: SizedBox()),
              Expanded(
                flex: 3,
                child: Center(
                  child: Text('今回',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _accent.withValues(alpha: 0.8))),
                ),
              ),
              if (hasRecord)
                const Expanded(
                  flex: 3,
                  child: Center(
                    child: Text('ベスト',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _textSub)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE8E8F0), height: 1),
          const SizedBox(height: 12),
          _Row(
            label: 'スコア',
            current: '${state.score} pt',
            best: hasRecord ? '${record.score} pt' : null,
          ),
          const SizedBox(height: 12),
          _Row(
            label: '正解数',
            current: '${state.correctCount} / ${state.totalQuestions}',
            best: hasRecord
                ? '${record.correctCount} / ${record.totalQuestions}'
                : null,
          ),
          const SizedBox(height: 12),
          _Row(
            label: '正答率',
            current: '${accuracy.toStringAsFixed(1)}%',
            best: hasRecord ? '${bestAccuracy.toStringAsFixed(1)}%' : null,
          ),
          const SizedBox(height: 12),
          _Row(
            label: '平均',
            current: _avgTime(avgResponseTimeMs),
            best: hasRecord ? _avgTime(record.avgResponseTimeMs) : null,
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.current,
    this.best,
  });

  final String label;
  final String current;
  final String? best;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(label,
              style: const TextStyle(fontSize: 14, color: _textSub)),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Text(current,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
        if (best != null)
          Expanded(
            flex: 3,
            child: Center(
              child: Text(best!,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _textSub)),
            ),
          ),
      ],
    );
  }
}
