import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/character_model.dart';
import '../../../data/services/audio_service.dart';
import '../../shop/views/coin_pack_paywall_sheet.dart';
import '../models/timer_state.dart';
import '../notifiers/timer_notifier.dart';
import 'widgets/ambient_sound_sheet.dart';
import 'widgets/character_companion_card.dart';
import 'widgets/coin_balance_badge.dart';
import 'widgets/reward_dialog.dart';
import 'widgets/session_mode_selector.dart';
import 'widgets/timer_controls_bar.dart';
import 'widgets/timer_progress_ring.dart';

/// Main Timer Screen embodying Nordic minimalism and gamification.
class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerNotifierProvider);
    final timerNotifier = ref.read(timerNotifierProvider.notifier);
    final audioState = ref.watch(audioNotifierProvider);

    // Listen for session completion to display reward celebration dialog
    ref.listen<TimerState>(timerNotifierProvider, (previous, next) {
      if (next.isCompleted && next.lastRewardedCoins != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => RewardDialog(
            coinsEarned: next.lastRewardedCoins!,
            character: next.selectedCharacter,
            onClaim: () {
              Navigator.of(dialogContext).pop();
              timerNotifier.dismissRewardAlert();
              // Transition to break mode and auto-start immediately
              timerNotifier.startBreak();
            },
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nordic Focus', style: AppTypography.headerTitle),
            Text(
              'SESSION #${timerState.sessionsCompleted + 1}',
              style: const TextStyle(
                color: AppColors.textTertiary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        actions: [
          // Ambient Soundscape Selector Button
          IconButton(
            tooltip: 'Soundscapes',
            onPressed: () => AmbientSoundSheet.show(context),
            style: IconButton.styleFrom(
              backgroundColor: audioState.isPlaying
                  ? AppColors.primarySubtle
                  : AppColors.surface,
              foregroundColor: audioState.isPlaying
                  ? AppColors.primaryDark
                  : AppColors.textSecondary,
              side: BorderSide(
                color: audioState.isPlaying
                    ? AppColors.primary
                    : AppColors.cardBorder,
              ),
            ),
            icon: Text(
              audioState.isPlaying ? '🎵' : '🎧',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),

          // Coin Balance with Paywall modal trigger
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CoinBalanceBadge(
              onTap: () => CoinPackPaywallSheet.show(context),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),

                      // 1. Character Companion Card
                      CharacterCompanionCard(
                        character: timerState.selectedCharacter,
                        isRunning: timerState.isRunning,
                        onSwitchCharacter: () =>
                            _toggleCharacter(ref, timerState),
                      ),

                      const Spacer(flex: 1),

                      // 2. Mode Segmented Selector (Focus / Short Break / Long Break)
                      SessionModeSelector(
                        currentMode: timerState.mode,
                        onModeSelected: (mode) {
                          timerNotifier.switchMode(mode);
                        },
                      ),

                      const Spacer(flex: 1),

                      // 3. Circular Nordic Timer Ring
                      TimerProgressRing(
                        state: timerState,
                        size: 260,
                      ),

                      const Spacer(flex: 2),

                      // 4. Timer Controls (Reset, Start/Pause, Skip)
                      TimerControlsBar(
                        state: timerState,
                        onStart: () => timerNotifier.start(),
                        onPause: () => timerNotifier.pause(),
                        onReset: () => timerNotifier.reset(),
                        onSkip: () {
                          final nextMode = switch (timerState.mode) {
                            PomodoroMode.focus => PomodoroMode.shortBreak,
                            PomodoroMode.shortBreak => PomodoroMode.longBreak,
                            PomodoroMode.longBreak => PomodoroMode.focus,
                          };
                          timerNotifier.switchMode(nextMode);
                        },
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Toggles between Appetite Enhancer and Appetite Suppressant
  void _toggleCharacter(WidgetRef ref, TimerState state) {
    final nextCharacter = state.selectedCharacter.id == 'enhancer'
        ? CharacterModel.suppressant
        : CharacterModel.enhancer;
    ref.read(timerNotifierProvider.notifier).selectCharacter(nextCharacter);
  }
}
