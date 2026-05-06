import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/color_pair.dart';
import '../models/game_state.dart';
import '../providers/game_provider.dart';

const _accent = Color(0xFF7C6FFF);

class ColorWordDisplay extends StatelessWidget {
  const ColorWordDisplay({
    super.key,
    required this.pair,
    required this.mode,
    required this.instruction,
    required this.lastAnswerCorrect,
  });

  final ColorPair pair;
  final GameMode mode;
  final AnswerInstruction instruction;
  final bool? lastAnswerCorrect;

  @override
  Widget build(BuildContext context) {
    final wordScript = context.watch<GameProvider>().wordScript;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (mode == GameMode.mixMode)
          _instructionChip(
            instruction == AnswerInstruction.color ? '文字の色を答える' : '文字を答える',
          ),
        if (mode == GameMode.mixMode) const SizedBox(height: 24),
        Stack(
          alignment: Alignment.center,
          children: [
            Text(
              pair.textContent.labelFor(wordScript),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accent.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _accent,
        ),
      ),
    );
  }

  Widget _feedbackOverlay(bool correct) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: correct
            ? const Color(0xFF00C48C).withValues(alpha: 0.8)
            : const Color(0xFFE53935).withValues(alpha: 0.8),
        shape: BoxShape.circle,
      ),
      child: Icon(
        correct ? Icons.circle_outlined : Icons.close_rounded,
        color: Colors.white,
        size: 56,
      ),
    );
  }
}
