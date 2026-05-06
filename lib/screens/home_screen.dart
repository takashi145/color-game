import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import '../models/word_script.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'IroTrick',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ストループ効果を使った脳トレゲーム',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 60),
                _ModeButton(
                  label: '文字色モード',
                  icon: Icons.palette,
                  mode: GameMode.colorMode,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 16),
                _ModeButton(
                  label: '文字内容モード',
                  icon: Icons.text_fields,
                  mode: GameMode.wordMode,
                  color: Colors.teal,
                ),
                const SizedBox(height: 16),
                _ModeButton(
                  label: 'ミックスモード',
                  icon: Icons.shuffle,
                  mode: GameMode.mixMode,
                  color: Colors.deepOrange,
                ),
                const SizedBox(height: 32),
                OutlinedButton.icon(
                  onPressed: () => _showScriptSettings(context),
                  icon: const Icon(Icons.settings, size: 18),
                  label: Text('文字設定: ${provider.wordScript.displayName}'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showScriptSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _ScriptSettingsSheet(),
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
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '文字設定',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '問題と回答ボタンに使う文字の種類を変更します',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
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
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ],
              ),
              value: script,
              groupValue: provider.wordScript,
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

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.icon,
    required this.mode,
    required this.color,
  });

  final String label;
  final IconData icon;
  final GameMode mode;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showModeModal(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
        ),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  void _showModeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ModeDetailSheet(mode: mode, color: color),
    );
  }
}

class _ModeDetailSheet extends StatelessWidget {
  const _ModeDetailSheet({required this.mode, required this.color});

  final GameMode mode;
  final Color color;

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
        return Icons.palette;
      case GameMode.wordMode:
        return Icons.text_fields;
      case GameMode.mixMode:
        return Icons.shuffle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final record = context.watch<GameProvider>().bestRecordForMode(mode);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(_icon, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                _title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'ルール',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 6),
          Text(_description, style: const TextStyle(fontSize: 15, height: 1.6)),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.emoji_events, color: color, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'ベストスコア',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                record.hasRecord
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(
                            icon: Icons.star,
                            label: 'スコア',
                            value: '${record.score} pt',
                            color: color,
                          ),
                          _StatItem(
                            icon: Icons.check_circle_outline,
                            label: '正解数',
                            value: '${record.correctCount} / ${record.totalQuestions}',
                            color: color,
                          ),
                          _StatItem(
                            icon: Icons.percent,
                            label: '正答率',
                            value: '${(record.accuracy * 100).toStringAsFixed(0)}%',
                            color: color,
                          ),
                          _StatItem(
                            icon: Icons.timer_outlined,
                            label: '平均',
                            value: '${(record.avgResponseTimeMs / 1000).toStringAsFixed(2)}秒',
                            color: color,
                          ),
                        ],
                      )
                    : Text(
                        'まだ記録なし',
                        style: TextStyle(fontSize: 15, color: Colors.grey[600]),
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
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
              child: const Text(
                'ゲームスタート',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}