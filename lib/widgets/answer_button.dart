import 'package:flutter/material.dart';

import '../models/game_color.dart';

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
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: gameColor.color,
        foregroundColor: gameColor.onColor,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      child: Text(
        gameColor.label,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}