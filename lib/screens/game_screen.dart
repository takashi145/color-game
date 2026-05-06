import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/game_logic.dart';
import '../models/game_color.dart';
import '../models/game_state.dart';
import '../providers/game_provider.dart';
import '../widgets/answer_button.dart';
import '../widgets/color_word_display.dart';
import 'result_screen.dart';

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
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.grey[50],
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: state.phase == GamePhase.countdown
                ? _CountdownBody(
                    provider: provider,
                    state: state,
                  )
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
          const SizedBox(height: 8),
          _TimerBar(state: state),
          const Spacer(),
          Text(
            '${provider.countdownValue}',
            style: const TextStyle(
              fontSize: 96,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const Spacer(),
          AbsorbPointer(
            child: Opacity(
              opacity: 0.4,
              child: _AnswerGrid(state: state, provider: provider),
            ),
          ),
          const SizedBox(height: 24),
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
          const SizedBox(height: 8),
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
          const SizedBox(height: 24),
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
            Text('スコア',
                style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            Text('${state.score}',
                style: const TextStyle(
                    fontSize: 32, fontWeight: FontWeight.bold)),
          ],
        ),
        Chip(
          label: Text(
            state.mode.label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.grey[200],
          side: BorderSide.none,
          padding: EdgeInsets.zero,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('残り時間',
                style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            Text('${state.remainingSeconds}秒',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: state.remainingSeconds <= 10 ? Colors.red : null,
                )),
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

class _TimerBarState extends State<_TimerBar> with SingleTickerProviderStateMixin {
  late final AnimationController _blinkController;
  late final Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..repeat(reverse: true);
    _blinkAnimation = _blinkController.drive(Tween(begin: 0.2, end: 1.0));
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
            minHeight: 8,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation(
              value > 0.5 ? Colors.green : value > 0.25 ? Colors.orange : Colors.red,
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
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
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
