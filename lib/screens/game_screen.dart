import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/game_logic.dart';
import '../models/game_color.dart';
import '../models/game_state.dart';
import '../providers/game_provider.dart';
import '../widgets/answer_button.dart';
import '../widgets/color_word_display.dart';
import 'result_screen.dart';

const _accent = Color(0xFF7C6FFF);
const _textSub = Colors.black38;

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        final state = provider.state;

        if (state.phase == GamePhase.finished) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ResultScreen()),
            );
          });
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close_rounded, color: _textSub),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: state.phase == GamePhase.countdown
                ? _CountdownBody(provider: provider, state: state)
                : _GameBody(state: state, provider: provider),
          ),
        );
      },
    );
  }
}

class _CountdownBody extends StatelessWidget {
  const _CountdownBody({required this.provider, required this.state});
  final GameProvider provider;
  final GameState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _Header(state: state),
          const SizedBox(height: 12),
          _TimerBar(state: state),
          const Spacer(),
          Text(
            '${provider.countdownValue}',
            style: const TextStyle(
              fontSize: 120,
              fontWeight: FontWeight.w800,
              color: _accent,
              letterSpacing: -4,
            ),
          ),
          const Spacer(),
          AbsorbPointer(
            child: Opacity(
              opacity: 0.25,
              child: _AnswerGrid(state: state, provider: provider),
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

class _GameBody extends StatelessWidget {
  const _GameBody({required this.state, required this.provider});
  final GameState state;
  final GameProvider provider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _Header(state: state),
          const SizedBox(height: 12),
          _TimerBar(state: state),
          const Spacer(),
          ColorWordDisplay(
            pair: state.currentPair,
            mode: state.mode,
            instruction: state.instruction,
            lastAnswerCorrect: state.lastAnswerCorrect,
          ),
          const Spacer(),
          _AnswerGrid(state: state, provider: provider),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.state});
  final GameState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('スコア',
                style: TextStyle(fontSize: 12, color: _textSub)),
            Text('${state.score}',
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1)),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: _accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            state.mode.label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _accent),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('残り',
                style: TextStyle(fontSize: 12, color: _textSub)),
            Text(
              '${state.remainingSeconds}s',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
                color: state.remainingSeconds <= 10
                    ? const Color(0xFFE53935)
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TimerBar extends StatefulWidget {
  const _TimerBar({required this.state});
  final GameState state;

  @override
  State<_TimerBar> createState() => _TimerBarState();
}

class _TimerBarState extends State<_TimerBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _blinkController;
  late final Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..repeat(reverse: true);
    _blinkAnimation = _blinkController.drive(Tween(begin: 0.3, end: 1.0));
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ratio = widget.state.remainingSeconds / kGameDurationSeconds;
    final isLow = ratio <= 0.25;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: ratio),
      duration: const Duration(seconds: 1),
      builder: (context, value, _) {
        final bar = ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: const Color(0xFFE8E8F0),
            valueColor: AlwaysStoppedAnimation(
              value > 0.5
                  ? _accent
                  : value > 0.25
                      ? const Color(0xFFFF9800)
                      : const Color(0xFFE53935),
            ),
          ),
        );

        if (isLow) {
          return FadeTransition(opacity: _blinkAnimation, child: bar);
        }
        return bar;
      },
    );
  }
}

class _AnswerGrid extends StatelessWidget {
  const _AnswerGrid({required this.state, required this.provider});
  final GameState state;
  final GameProvider provider;

  @override
  Widget build(BuildContext context) {
    final colors = GameColor.values;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.8,
      children: colors
          .map((c) => AnswerButton(
                gameColor: c,
                onTap: () => provider.answer(c),
              ))
          .toList(),
    );
  }
}
