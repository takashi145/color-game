import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_color.dart';
import '../providers/game_provider.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    super.key,
    required this.gameColor,
    required this.onTap,
  });

  final GameColor gameColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final wordScript = context.watch<GameProvider>().wordScript;
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: gameColor.color.withValues(alpha: 0.85),
        foregroundColor: gameColor.onColor,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
      ),
      child: Text(
        gameColor.labelFor(wordScript),
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
