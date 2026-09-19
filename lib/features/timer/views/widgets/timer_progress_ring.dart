import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../models/timer_state.dart';

/// Minimalist circular countdown indicator.
class TimerProgressRing extends StatelessWidget {
  final TimerState state;
  final double size;

  const TimerProgressRing({
    super.key,
    required this.state,
    this.size = 260,
  });

  @override
  Widget build(BuildContext context) {
    final progress = state.progress;
    final timeFormatted = TimeFormatter.formatMinutesSeconds(state.remainingSeconds);

    Color activeColor;
    switch (state.mode) {
      case PomodoroMode.focus:
        activeColor = AppColors.primary; // Medium Turquoise #48D1CC
        break;
      case PomodoroMode.shortBreak:
        activeColor = AppColors.shortBreakMode;
        break;
      case PomodoroMode.longBreak:
        activeColor = AppColors.longBreakMode;
        break;
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular Progress Custom Paint
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: progress,
              activeColor: activeColor,
              trackColor: AppColors.surfaceSecondary,
              strokeWidth: 10,
            ),
          ),

          // Central Time and Status Information
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Session Status Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: activeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  state.mode.title.toUpperCase(),
                  style: AppTypography.timerStatus.copyWith(
                    color: activeColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Formatted Countdown
              Text(
                timeFormatted,
                style: AppTypography.timerDisplay.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),

              // Subtitle / Reward cue
              if (state.mode == PomodoroMode.focus)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.monetization_on_rounded,
                      size: 14,
                      color: AppColors.coinGold,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+${state.mode.coinReward} Coins on finish',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  'Relax and recharge',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color trackColor;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.activeColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track Paint
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    // Active Progress Arc
    if (progress > 0) {
      final activePaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // Start from the top (-pi/2) and sweep clockwise
      const startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.trackColor != trackColor;
  }
}
