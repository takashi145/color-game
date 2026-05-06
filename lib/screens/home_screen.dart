import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  'カラーゲーム',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ストループ効果チャレンジ',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 60),
                _ModeButton(
                  label: '文字色モード',
                  description: '表示された文字の色を答える',
                  icon: Icons.palette,
                  mode: GameMode.colorMode,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 16),
                _ModeButton(
                  label: '文字内容モード',
                  description: '書いてある色の名前を答える',
                  icon: Icons.text_fields,
                  mode: GameMode.wordMode,
                  color: Colors.teal,
                ),
                const SizedBox(height: 16),
                _ModeButton(
                  label: 'ミックスモード',
                  description: 'ランダムに切り替わる上級モード',
                  icon: Icons.shuffle,
                  mode: GameMode.mixMode,
                  color: Colors.deepOrange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.description,
    required this.icon,
    required this.mode,
    required this.color,
  });

  final String label;
  final String description;
  final IconData icon;
  final GameMode mode;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _startGame(context),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                Text(description,
                    style:
                        const TextStyle(fontSize: 13, color: Colors.white70)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _startGame(BuildContext context) {
    context.read<GameProvider>().startGame(mode);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const GameScreen()),
    );
  }
}