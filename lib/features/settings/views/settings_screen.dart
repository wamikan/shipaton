import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../notifiers/settings_notifier.dart';

/// Settings screen allowing users to customize session lengths and preferences.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final settingsNotifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Preferences', style: AppTypography.headerTitle),
        actions: [
          TextButton(
            onPressed: () => settingsNotifier.resetToDefaults(),
            child: Text(
              'Reset',
              style: AppTypography.button.copyWith(
                fontSize: 14,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Section: Timer Durations
          _buildSectionHeader('TIMER DURATIONS'),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cardBorder),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                _buildDurationSlider(
                  context: context,
                  label: 'Focus Session',
                  value: settings.focusMinutes.toDouble(),
                  min: 5,
                  max: 60,
                  suffix: 'mins',
                  accentColor: AppColors.primary,
                  onChanged: (val) =>
                      settingsNotifier.updateFocusMinutes(val.round()),
                ),
                const Divider(),
                _buildDurationSlider(
                  context: context,
                  label: 'Short Break',
                  value: settings.shortBreakMinutes.toDouble(),
                  min: 1,
                  max: 20,
                  suffix: 'mins',
                  accentColor: AppColors.shortBreakMode,
                  onChanged: (val) =>
                      settingsNotifier.updateShortBreakMinutes(val.round()),
                ),
                const Divider(),
                _buildDurationSlider(
                  context: context,
                  label: 'Long Break',
                  value: settings.longBreakMinutes.toDouble(),
                  min: 5,
                  max: 45,
                  suffix: 'mins',
                  accentColor: AppColors.longBreakMode,
                  onChanged: (val) =>
                      settingsNotifier.updateLongBreakMinutes(val.round()),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Section: Audio & Alerts
          _buildSectionHeader('AUDIO & ALERTS'),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              title: const Text('Sound Alerts on Finish', style: AppTypography.sectionTitle),
              subtitle: const Text(
                'Play chime and alarm notifications upon completion',
                style: AppTypography.bodySmall,
              ),
              activeThumbColor: AppColors.primary,
              value: settings.soundAlertsEnabled,
              onChanged: (val) => settingsNotifier.toggleSoundAlerts(val),
            ),
          ),

          const SizedBox(height: 28),

          // Section: About
          _buildSectionHeader('ABOUT SHIPATON TIMER'),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cardBorder),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.workspace_premium_rounded,
                        color: AppColors.primary, size: 24),
                    SizedBox(width: 10),
                    Text(
                      'Shipaton 2026 Next Gen Award',
                      style: AppTypography.sectionTitle,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Blending serene Nordic minimalism with rewarding gamification companions. Crafted for pure focus and creative flow.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('Version 1.0.0 (Build 2026.1)',
                      style: AppTypography.bodySmall),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: AppTypography.timerStatus.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  Widget _buildDurationSlider({
    required BuildContext context,
    required String label,
    required double value,
    required double min,
    required double max,
    required String suffix,
    required Color accentColor,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.sectionTitle.copyWith(fontSize: 14)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${value.round()} $suffix',
                style: AppTypography.badge.copyWith(
                  color: accentColor,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: accentColor,
            inactiveTrackColor: AppColors.surfaceSecondary,
            thumbColor: accentColor,
            overlayColor: accentColor.withValues(alpha: 0.15),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
