import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import '../models/word_script.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';

const _accent = Color(0xFF7C6FFF);
const _surface = Color(0xFFFFFFFF);
const _textSub = Colors.black38;
const _borderColor = Color(0xFFE8E8F0);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 52),
              const Text(
                'IroTrick',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  color: _accent,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'ストループ効果で脳をトレーニング',
                style: TextStyle(fontSize: 14, color: _textSub),
              ),
              const Spacer(),
              _ModeCard(
                label: '文字色モード',
                description: '単語の文字色を答える',
                icon: Icons.palette_outlined,
                mode: GameMode.colorMode,
              ),
              const SizedBox(height: 12),
              _ModeCard(
                label: '文字内容モード',
                description: '単語の内容を答える',
                icon: Icons.text_fields_outlined,
                mode: GameMode.wordMode,
              ),
              const SizedBox(height: 12),
              _ModeCard(
                label: 'ミックスモード',
                description: 'ランダム切り替え・上級者向け',
                icon: Icons.shuffle_outlined,
                mode: GameMode.mixMode,
              ),
              const Spacer(),
              Center(
                child: TextButton.icon(
                  onPressed: () => _showScriptSettings(context),
                  icon: const Icon(Icons.tune_rounded,
                      size: 16, color: _textSub),
                  label: Text(
                    '文字設定: ${provider.wordScript.displayName}',
                    style: const TextStyle(color: _textSub, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showScriptSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _ScriptSettingsSheet(),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.label,
    required this.description,
    required this.icon,
    required this.mode,
  });

  final String label;
  final String description;
  final IconData icon;
  final GameMode mode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showModeModal(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: _accent, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(description,
                      style: const TextStyle(
                          fontSize: 13, color: _textSub)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: _textSub),
          ],
        ),
      ),
    );
  }

  void _showModeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ModeDetailSheet(mode: mode),
    );
  }
}

class _ModeDetailSheet extends StatelessWidget {
  const _ModeDetailSheet({required this.mode});

  final GameMode mode;

  String get _title {
    switch (mode) {
      case GameMode.colorMode:
        return '文字色モード';
      case GameMode.wordMode:
        return '文字内容モード';
      case GameMode.mixMode:
        return 'ミックスモード';
    }
  }

  String get _description {
    switch (mode) {
      case GameMode.colorMode:
        return '画面に表示された単語の「文字の色」を答えてください。単語に惑わされないように注意！';
      case GameMode.wordMode:
        return '画面に表示された単語を答えてください。文字の色に惑わされないように注意！';
      case GameMode.mixMode:
        return '「文字色」と「文字内容」どちらを答えるかがランダムに切り替わります。上級者向けモードです。';
    }
  }

  IconData get _icon {
    switch (mode) {
      case GameMode.colorMode:
        return Icons.palette_outlined;
      case GameMode.wordMode:
        return Icons.text_fields_outlined;
      case GameMode.mixMode:
        return Icons.shuffle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final record = context.watch<GameProvider>().bestRecordForMode(mode);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_icon, color: _accent, size: 22),
              ),
              const SizedBox(width: 14),
              Text(
                _title,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'ルール',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _textSub),
          ),
          const SizedBox(height: 6),
          Text(_description,
              style: const TextStyle(fontSize: 15, height: 1.6)),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _accent.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.emoji_events_outlined,
                        color: _accent, size: 14),
                    const SizedBox(width: 4),
                    const Text(
                      'ベストスコア',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _accent),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                record.hasRecord
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(
                            icon: Icons.star_rounded,
                            label: 'スコア',
                            value: '${record.score}',
                          ),
                          _StatItem(
                            icon: Icons.check_rounded,
                            label: '正解',
                            value:
                                '${record.correctCount}/${record.totalQuestions}',
                          ),
                          _StatItem(
                            icon: Icons.percent_rounded,
                            label: '正答率',
                            value:
                                '${(record.accuracy * 100).toStringAsFixed(0)}%',
                          ),
                          _StatItem(
                            icon: Icons.timer_outlined,
                            label: '平均',
                            value:
                                '${(record.avgResponseTimeMs / 1000).toStringAsFixed(2)}s',
                          ),
                        ],
                      )
                    : const Text(
                        'まだ記録なし',
                        style: TextStyle(fontSize: 15, color: _textSub),
                      ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _startGame(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'ゲームスタート',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startGame(BuildContext context) {
    Navigator.of(context).pop();
    context.read<GameProvider>().startGame(mode);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const GameScreen()),
    );
  }
}

class _ScriptSettingsSheet extends StatelessWidget {
  const _ScriptSettingsSheet();

  String _example(WordScript script) {
    switch (script) {
      case WordScript.kanji:
        return '赤、青、緑…';
      case WordScript.hiragana:
        return 'あか、あお、みどり…';
      case WordScript.katakana:
        return 'アカ、アオ、ミドリ…';
      case WordScript.english:
        return 'Red, Blue, Green…';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '文字設定',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            '問題と回答ボタンに使う文字の種類を選択',
            style: TextStyle(fontSize: 13, color: _textSub),
          ),
          const SizedBox(height: 20),
          ...WordScript.values.map(
            (script) => RadioListTile<WordScript>(
              title: Row(
                children: [
                  Text(script.displayName,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 12),
                  Text(
                    _example(script),
                    style: const TextStyle(fontSize: 13, color: _textSub),
                  ),
                ],
              ),
              value: script,
              groupValue: provider.wordScript,
              activeColor: _accent,
              onChanged: (v) {
                if (v != null) context.read<GameProvider>().setWordScript(v);
              },
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: _accent, size: 18),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: _textSub)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
