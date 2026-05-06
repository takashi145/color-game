import 'package:flutter/material.dart';

import '../models/color_pair.dart';
import '../models/game_state.dart';

class ColorWordDisplay extends StatelessWidget {
  const ColorWordDisplay({
    super.key,
    required this.pair,
    required this.instruction,
    required this.lastAnswerCorrect,
  });

  final ColorPair pair;
  final AnswerInstruction instruction;
  final bool? lastAnswerCorrect;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (instruction == AnswerInstruction.color)
          _instructionChip('文字の色は？')
        else
          _instructionChip('書いてある色は？'),
        const SizedBox(height: 24),
        Stack(
          alignment: Alignment.center,
          children: [
            Text(
              pair.textContent.label,
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: pair.textColor.color,
              ),
            ),
            if (lastAnswerCorrect != null)
              _feedbackOverlay(lastAnswerCorrect!),
          ],
        ),
      ],
    );
  }

  Widget _instructionChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _feedbackOverlay(bool correct) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: correct
            ? Colors.green.withValues(alpha: 0.7)
            : Colors.red.withValues(alpha: 0.7),
        shape: BoxShape.circle,
      ),
      child: Icon(
        correct ? Icons.circle_outlined : Icons.close,
        color: Colors.white,
        size: 60,
      ),
    );
  }
}