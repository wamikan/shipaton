import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/character_model.dart';
import '../../../data/services/audio_service.dart';
import '../../shop/views/coin_pack_paywall_sheet.dart';
import '../models/timer_state.dart';
import '../notifiers/timer_notifier.dart';
import '../../settings/notifiers/settings_notifier.dart';
import '../../gamification/notifiers/focus_stats_notifier.dart';
import '../../gamification/views/fairy_compendium_sheet.dart';
import 'widgets/ambient_sound_sheet.dart';
import 'widgets/animated_focus_stage.dart';
import 'widgets/category_selector_sheet.dart';
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
    final settings = ref.watch(settingsNotifierProvider);
    final focusStatsState = ref.watch(focusStatsNotifierProvider);
    final activeCategory = focusStatsState.activeCategory;
    final showAnimation = settings.showFocusAnimation;

    // Listen for session completion to display reward celebration dialog
    ref.listen<TimerState>(timerNotifierProvider, (previous, next) async {
      if (next.isCompleted && next.lastRewardedCoins != null) {
        // Record focus session minutes to character and active category
        final completedMinutes = settings.focusMinutes;
        final reward = await ref
            .read(focusStatsNotifierProvider.notifier)
            .recordFocusSession(
              characterId: next.selectedCharacter.id,
              minutes: completedMinutes,
            );

        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => RewardDialog(
              coinsEarned: next.lastRewardedCoins!,
              character: next.selectedCharacter,
              reward: reward,
              onClaim: () {
                Navigator.of(dialogContext).pop();
                timerNotifier.dismissRewardAlert();
                timerNotifier.startBreak();
              },
              onViewCompendium: () {
                Navigator.of(dialogContext).pop();
                timerNotifier.dismissRewardAlert();
                timerNotifier.startBreak();
                FairyCompendiumSheet.show(
                  context,
                  initialCharacterId: next.selectedCharacter.id,
                );
              },
            ),
          );
        }
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
          // Fairy Message Compendium (言葉の図鑑)
          IconButton(
            tooltip: '言葉の図鑑',
            onPressed: () => FairyCompendiumSheet.show(
              context,
              initialCharacterId: timerState.selectedCharacter.id,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surface,
              foregroundColor: timerState.selectedCharacter.primaryColor,
              side: const BorderSide(color: AppColors.cardBorder),
            ),
            icon: const Text('📖', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 6),

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
                      if (showAnimation) ...[
                        const SizedBox(height: 6),

                        // Active Working Category Chip
                        InkWell(
                          onTap: () => CategorySelectorSheet.show(context),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.cardBorder),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(activeCategory.icon, style: const TextStyle(fontSize: 14)),
                                const SizedBox(width: 6),
                                Text(
                                  activeCategory.name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_drop_down_rounded,
                                  size: 18,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Mode Segmented Selector (Focus / Short Break / Long Break)
                        SessionModeSelector(
                          currentMode: timerState.mode,
                          onModeSelected: (mode) {
                            timerNotifier.switchMode(mode);
                          },
                        ),

                        const Spacer(flex: 1),

                        // Prominent Center Stage: Companion with disappearing food (Girl)
                        // or shrinking water pond (Boy), with non-overlapping clock below
                        AnimatedFocusStage(
                          state: timerState,
                          onSwitchCharacter: () =>
                              _toggleCharacter(ref, timerState),
                        ),

                        const Spacer(flex: 2),
                      ] else ...[
                        const SizedBox(height: 12),

                        // 1. Character Companion Card
                        CharacterCompanionCard(
                          character: timerState.selectedCharacter,
                          isRunning: timerState.isRunning,
                          mode: timerState.mode,
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

                        // 3. Circular Nordic Timer Ring (Minimalist Fallback)
                        TimerProgressRing(
                          state: timerState,
                          size: 260,
                        ),

                        const Spacer(flex: 2),
                      ],

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
