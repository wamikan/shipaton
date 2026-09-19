import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../models/timer_state.dart';

/// Nordic minimalist control bar with Start/Pause hero button,
/// Reset, and Skip actions.
class TimerControlsBar extends StatelessWidget {
  final TimerState state;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final VoidCallback onSkip;

  const TimerControlsBar({
    super.key,
    required this.state,
    required this.onStart,
    required this.onPause,
    required this.onReset,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final isRunning = state.isRunning;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Reset Button
          _buildSecondaryButton(
            icon: Icons.refresh_rounded,
            tooltip: 'Reset Timer',
            onPressed: onReset,
          ),
          const SizedBox(width: 20),

          // Primary Hero Play/Pause Button
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: isRunning ? onPause : onStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: AppColors.primary.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 26,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isRunning ? 'PAUSE' : (state.isPaused ? 'RESUME' : 'START FOCUS'),
                      style: AppTypography.button.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),

          // Skip Button
          _buildSecondaryButton(
            icon: Icons.skip_next_rounded,
            tooltip: 'Skip to Next',
            onPressed: onSkip,
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.textSecondary, size: 22),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }
}
