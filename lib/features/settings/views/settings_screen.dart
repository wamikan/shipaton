import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/timer_settings_model.dart';
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
                  min: 1,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
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
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Break BGM Playback', style: AppTypography.sectionTitle),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              switch (settings.bgmBreakMode) {
                                BgmBreakMode.always => 'ALWAYS',
                                BgmBreakMode.focusOnly => 'FOCUS ONLY',
                                BgmBreakMode.breakOnly => 'BREAK ONLY',
                              },
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryDark,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        switch (settings.bgmBreakMode) {
                          BgmBreakMode.always => 'Music plays seamlessly during both focus and breaks',
                          BgmBreakMode.focusOnly => 'Music plays during focus; muted during breaks',
                          BgmBreakMode.breakOnly => 'Music plays during breaks only; muted during focus',
                        },
                        style: AppTypography.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          children: [
                            _buildBgmModeOption(
                              label: 'Always',
                              selected: settings.bgmBreakMode == BgmBreakMode.always,
                              onTap: () => settingsNotifier.updateBgmBreakMode(BgmBreakMode.always),
                            ),
                            const SizedBox(width: 4),
                            _buildBgmModeOption(
                              label: 'Focus Only',
                              selected: settings.bgmBreakMode == BgmBreakMode.focusOnly,
                              onTap: () => settingsNotifier.updateBgmBreakMode(BgmBreakMode.focusOnly),
                            ),
                            const SizedBox(width: 4),
                            _buildBgmModeOption(
                              label: 'Break Only',
                              selected: settings.bgmBreakMode == BgmBreakMode.breakOnly,
                              onTap: () => settingsNotifier.updateBgmBreakMode(BgmBreakMode.breakOnly),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Section: Companion Animation
          _buildSectionHeader('COMPANION & ANIMATION'),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              title: const Text('Focus Companion Animation', style: AppTypography.sectionTitle),
              subtitle: const Text(
                'Show eating & water absorption animations while timer is running',
                style: AppTypography.bodySmall,
              ),
              activeThumbColor: AppColors.primary,
              value: settings.showFocusAnimation,
              onChanged: (val) => settingsNotifier.toggleFocusAnimation(val),
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

          const SizedBox(height: 28),

          // Section: Audio Credits & Licenses
          _buildSectionHeader('AUDIO CREDITS & LICENSES'),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primarySubtle,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.library_music_rounded, color: AppColors.primary, size: 22),
              ),
              title: const Text('Sound Track Attributions', style: AppTypography.sectionTitle),
              subtitle: const Text(
                'Attribution notices for On-Jin, tunee.ai & soundscapes',
                style: AppTypography.bodySmall,
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textTertiary, size: 16),
              onTap: () => _showAudioCreditsDialog(context),
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

  Widget _buildBgmModeOption({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              color: selected ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  void _showAudioCreditsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Text('🎵', style: TextStyle(fontSize: 22)),
            SizedBox(width: 8),
            Text('Audio Credits & Licenses', style: AppTypography.sectionTitle),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rain & Nature (On-Jin)
              _buildCreditItem(
                title: 'Rain & Nature (rainnature.mp3)',
                sourceName: 'On-Jin ～音人～',
                url: 'https://on-jin.com/',
                description:
                    'Used under the On-Jin material embedded work guidelines. All copyright and neighboring rights are retained by On-Jin ～音人～.\n'
                    '※当アプリ内の音源の二次配布、無断利用、および抽出利用は固く禁止されています。',
              ),
              const Divider(height: 24),

              // Positive Flow (tunee.ai)
              _buildCreditItem(
                title: 'Positive Flow (positive.mp3)',
                sourceName: 'tunee.ai',
                url: 'https://tunee.ai/',
                description:
                    'AI-assisted ambient concentration track composed with tunee.ai for deep focus and uplifting motivation.',
              ),
              const Divider(height: 24),

              // Nordic Ambient & SFX
              _buildCreditItem(
                title: 'Nordic Ambience & SFX',
                sourceName: 'Royalty-Free & In-House Assets',
                url: '',
                description:
                    'Nordic Rain & Piano, Pine Forest & Bells, 528Hz Temple Bell completion chime, and Coin SFX.',
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditItem({
    required String title,
    required String sourceName,
    required String url,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        if (url.isNotEmpty)
          Text(
            'Source: $sourceName ($url)',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          )
        else
          Text(
            'Source: $sourceName',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        const SizedBox(height: 6),
        Text(
          description,
          style: const TextStyle(
            fontSize: 12,
            height: 1.45,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
