import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../data/models/ambient_sound_model.dart';
import '../../../../data/services/audio_service.dart';

/// Nordic bottom sheet for adjusting ambient soundscapes and volume.
class AmbientSoundSheet extends ConsumerWidget {
  const AmbientSoundSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const AmbientSoundSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioNotifierProvider);
    final audioNotifier = ref.read(audioNotifierProvider.notifier);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ambient Soundscapes', style: AppTypography.headerTitle),
                  SizedBox(height: 2),
                  Text(
                    'Soothing background audio for deep focus',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
              IconButton(
                onPressed: () => audioNotifier.togglePlayback(),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primarySubtle,
                  foregroundColor: AppColors.primary,
                ),
                icon: Icon(
                  audioState.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Volume Slider
          Row(
            children: [
              const Icon(Icons.volume_down_rounded,
                  size: 20, color: AppColors.textTertiary),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.surfaceSecondary,
                    thumbColor: AppColors.primary,
                    overlayColor: AppColors.primary.withValues(alpha: 0.15),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: audioState.volume,
                    onChanged: (val) => audioNotifier.setVolume(val),
                  ),
                ),
              ),
              const Icon(Icons.volume_up_rounded,
                  size: 20, color: AppColors.textTertiary),
            ],
          ),
          const SizedBox(height: 16),

          // Sound List
          ...AmbientSoundModel.defaultSoundscapes.map((sound) {
            final isSelected = audioState.currentSound.id == sound.id;
            final isLocked = !sound.isUnlocked;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primarySubtle
                    : AppColors.surfaceSecondary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.4)
                      : Colors.transparent,
                ),
              ),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    sound.icon,
                    size: 20,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                title: Text(
                  sound.title,
                  style: AppTypography.button.copyWith(
                    fontSize: 14,
                    color: isSelected
                        ? AppColors.primaryDark
                        : AppColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  isLocked ? 'Unlock in Shop (${sound.unlockCost} Coins)' : sound.description,
                  style: AppTypography.bodySmall.copyWith(
                    color: isLocked ? AppColors.coinGoldDark : AppColors.textTertiary,
                    fontSize: 11.5,
                  ),
                ),
                trailing: isLocked
                    ? const Icon(Icons.lock_outline_rounded,
                        size: 18, color: AppColors.coinGold)
                    : (isSelected && audioState.isPlaying
                        ? const Icon(Icons.graphic_eq_rounded,
                            color: AppColors.primary)
                        : null),
                onTap: isLocked
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Visit the In-App Shop to unlock ${sound.title}!'),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    : () {
                        audioNotifier.selectSound(sound);
                      },
              ),
            );
          }),
        ],
      ),
    );
  }
}
