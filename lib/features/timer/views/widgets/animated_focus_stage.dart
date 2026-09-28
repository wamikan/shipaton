import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../data/models/character_model.dart';
import '../../models/timer_state.dart';

/// Central stage displaying the animated companion and organic time progress.
/// Replaces the circular progress ring when Focus Companion Animation is enabled:
/// - Enhancer (Girl): Banquet tray of 5 delicacies that are eaten and decrease as time elapses.
/// - Suppressant (Boy): Surrounding pond of arctic water that shrinks inward as he absorbs it.
/// - Countdown timer digits and mode info are displayed cleanly BELOW the stage with zero overlap.
class AnimatedFocusStage extends StatefulWidget {
  final TimerState state;
  final VoidCallback onSwitchCharacter;

  const AnimatedFocusStage({
    super.key,
    required this.state,
    required this.onSwitchCharacter,
  });

  @override
  State<AnimatedFocusStage> createState() => _AnimatedFocusStageState();
}

class _AnimatedFocusStageState extends State<AnimatedFocusStage>
    with SingleTickerProviderStateMixin {
  late AnimationController _cycleController;
  int _itemIndex = 0;

  static const List<Map<String, String>> _foods = [
    {'path': AppAssets.foodApple, 'name': 'Apple'},
    {'path': AppAssets.foodCinnamonRoll, 'name': 'Cinnamon Roll'},
    {'path': AppAssets.foodPancake, 'name': 'Pancake'},
    {'path': AppAssets.berryCloudberry, 'name': 'Cloudberry'},
    {'path': AppAssets.berryBlueberry, 'name': 'Blueberry'},
  ];

  static const List<String> _blooms = [
    AppAssets.flowerLilyValley,
    AppAssets.berryCloudberry,
    AppAssets.berryBlueberry,
  ];

  @override
  void initState() {
    super.initState();
    _cycleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    _cycleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _itemIndex = (_itemIndex + 1) % 3;
        });
        if (widget.state.isRunning) {
          _cycleController.forward(from: 0.0);
        }
      }
    });

    if (widget.state.isRunning) {
      _cycleController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedFocusStage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final shouldAnimate = widget.state.isRunning;
    final wasAnimating = oldWidget.state.isRunning;

    if (shouldAnimate && !wasAnimating) {
      _cycleController.forward(from: 0.0);
    } else if (!shouldAnimate && wasAnimating) {
      _cycleController.stop();
      _cycleController.reset();
    }
  }

  @override
  void dispose() {
    _cycleController.dispose();
    super.dispose();
  }

  /// Number of food delicacies remaining on the banquet plate (0 to 5)
  int get _foodsRemaining {
    if (widget.state.isCompleted || widget.state.remainingSeconds == 0) return 0;
    return (widget.state.progress * 5).ceil().clamp(0, 5);
  }

  @override
  Widget build(BuildContext context) {
    final char = widget.state.selectedCharacter;
    final isEnhancer = char.id == 'enhancer';
    final isWarm = char.tone == CharacterTone.warm;
    final timeFormatted = TimeFormatter.formatMinutesSeconds(widget.state.remainingSeconds);

    Color activeColor;
    switch (widget.state.mode) {
      case PomodoroMode.focus:
        activeColor = AppColors.primary;
        break;
      case PomodoroMode.shortBreak:
        activeColor = AppColors.shortBreakMode;
        break;
      case PomodoroMode.longBreak:
        activeColor = AppColors.longBreakMode;
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Companion Switch Pill (Clean, Bold, Interactive)
        InkWell(
          onTap: widget.onSwitchCharacter,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: char.backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: char.borderColor, width: 1.2),
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
                Text(isWarm ? '🔥' : '❄️', style: const TextStyle(fontSize: 13)),
                const SizedBox(width: 6),
                Text(
                  char.name.toUpperCase(),
                  style: TextStyle(
                    color: char.primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.swap_horiz, size: 16, color: char.primaryColor),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // 2. Central Animation Stage (Center Prominence)
        SizedBox(
          width: 320,
          height: 250,
          child: AnimatedBuilder(
            animation: _cycleController,
            builder: (context, child) {
              final t = _cycleController.value;
              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Suppressant: Concentric Shrinking Water Pond (Beneath Cape)
                  if (!isEnhancer)
                    Positioned(
                      bottom: 40,
                      child: CustomPaint(
                        size: const Size(300, 80),
                        painter: _WaterPondPainter(
                          progress: widget.state.progress,
                          cycle: t,
                          isRunning: widget.state.isRunning,
                        ),
                      ),
                    ),

                  // Hero Character Avatar Frame
                  Positioned(
                    top: isEnhancer ? 10 : 20,
                    child: _buildHeroCharacter(char, isEnhancer, t),
                  ),

                  // Enhancer: Food Banquet Tray with 5 Delicacies Decreasing Over Time
                  if (isEnhancer)
                    Positioned(
                      bottom: 0,
                      child: _buildFoodBanquetPlate(t),
                    ),

                  // Suppressant: Water Absorption Subtitle & Status
                  if (!isEnhancer)
                    Positioned(
                      bottom: 4,
                      child: _buildWaterStatusIndicator(),
                    ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // 3. Clear, Non-Overlapping Countdown Section (Below Stage)
        _buildTimerDisplaySection(timeFormatted, activeColor),
      ],
    );
  }

  /// Builds the large central hero character with head slime eating or sprout blooming overlays
  Widget _buildHeroCharacter(CharacterModel char, bool isEnhancer, double t) {
    const double avatarSize = 140;

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: char.backgroundColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: char.borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: char.primaryColor.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      clipBehavior: Clip.none,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Base Character Sprite
          Image.asset(
            char.assetPath,
            fit: BoxFit.contain,
            width: avatarSize - 16,
            height: avatarSize - 16,
            errorBuilder: (context, error, stackTrace) => Center(
              child: Text(
                char.tone == CharacterTone.warm ? '🔥' : '❄️',
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),

          // Girl Slime Eating Overlay (when running)
          if (isEnhancer && widget.state.isRunning)
            _buildGirlEatingOverlay(avatarSize, t),

          // Boy Head Sprout Blooming Overlay (when running)
          if (!isEnhancer && widget.state.isRunning)
            _buildBoyBloomingOverlay(avatarSize, t),
        ],
      ),
    );
  }

  /// Girl (食欲増進ちゃん): Slime head swallowing active food
  Widget _buildGirlEatingOverlay(double avatarSize, double t) {
    final currentFood = _foods[_itemIndex % _foods.length]['path']!;

    double foodScale = 1.0;
    double foodOpacity = 1.0;
    double foodY = -avatarSize * 0.38;

    if (t < 0.35) {
      final bob = math.sin(t / 0.35 * math.pi) * 3.0;
      foodY += bob;
      foodScale = 0.9 + (t / 0.35) * 0.15;
      foodOpacity = (t / 0.1).clamp(0.0, 1.0);
    } else if (t < 0.75) {
      final sinkProgress = (t - 0.35) / 0.40;
      foodY += sinkProgress * (avatarSize * 0.16);
      foodScale = (1.05 - sinkProgress * 0.70).clamp(0.2, 1.05);
      foodOpacity = (1.0 - sinkProgress * 0.85).clamp(0.0, 1.0);
    } else {
      foodOpacity = 0.0;
    }

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Sinking delicacy into slime head
        if (foodOpacity > 0.01)
          Transform.translate(
            offset: Offset(0, foodY),
            child: Transform.scale(
              scale: foodScale,
              child: Opacity(
                opacity: foodOpacity,
                child: SizedBox(
                  width: avatarSize * 0.38,
                  height: avatarSize * 0.38,
                  child: Image.asset(currentFood, fit: BoxFit.contain),
                ),
              ),
            ),
          ),

        // Slime gel amber glow pulse during swallow
        if (t >= 0.35 && t <= 0.85)
          Positioned(
            top: avatarSize * 0.04,
            child: Opacity(
              opacity: math.sin((t - 0.35) / 0.50 * math.pi) * 0.6,
              child: Container(
                width: avatarSize * 0.48,
                height: avatarSize * 0.26,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.amber,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Boy (食欲減退君): Sprout blooming on head as water is absorbed
  Widget _buildBoyBloomingOverlay(double avatarSize, double t) {
    final currentBloom = _blooms[_itemIndex % _blooms.length];

    double bloomScale = 0.0;
    double bloomOpacity = 0.0;
    final double bloomY = -avatarSize * 0.40;

    if (t >= 0.35 && t < 0.85) {
      final bloomT = (t - 0.35) / 0.50;
      if (bloomT < 0.3) {
        bloomScale = (bloomT / 0.3) * 1.15;
        bloomOpacity = (bloomT / 0.2).clamp(0.0, 1.0);
      } else {
        bloomScale = 1.0 + math.sin((bloomT - 0.3) * math.pi * 3) * 0.06;
        bloomOpacity = 1.0;
      }
    } else if (t >= 0.85) {
      final fadeT = (t - 0.85) / 0.15;
      bloomScale = 1.0 + fadeT * 0.25;
      bloomOpacity = (1.0 - fadeT).clamp(0.0, 1.0);
    }

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Blooming Flower / Berry atop Sprout
        if (bloomOpacity > 0.01)
          Transform.translate(
            offset: Offset(0, bloomY),
            child: Transform.scale(
              scale: bloomScale,
              child: Opacity(
                opacity: bloomOpacity,
                child: SizedBox(
                  width: avatarSize * 0.40,
                  height: avatarSize * 0.40,
                  child: Image.asset(currentBloom, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Enhancer Girl: 5-delicacy banquet plate showing food decreasing over time
  Widget _buildFoodBanquetPlate(double t) {
    final remaining = _foodsRemaining;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row of 5 food slots
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              final isPresent = index < remaining;
              final isBeingEaten = isPresent && (index == remaining - 1) && widget.state.isRunning;
              final food = _foods[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isPresent
                        ? (isBeingEaten ? const Color(0xFFFFF3DB) : const Color(0xFFFFF8F5))
                        : AppColors.surfaceSecondary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isPresent
                          ? (isBeingEaten ? AppColors.coinGold : AppColors.enhancerBorder)
                          : AppColors.cardBorder.withValues(alpha: 0.6),
                      width: isBeingEaten ? 2.0 : 1.2,
                    ),
                    boxShadow: isBeingEaten
                        ? [
                            BoxShadow(
                              color: AppColors.coinGold.withValues(alpha: 0.4),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: isPresent
                        ? Transform.scale(
                            scale: isBeingEaten
                                ? 1.0 + math.sin(t * math.pi * 2) * 0.08
                                : 1.0,
                            child: Image.asset(
                              food['path']!,
                              width: 26,
                              height: 26,
                              fit: BoxFit.contain,
                            ),
                          )
                        : const Text(
                            '🍽️',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textTertiary,
                            ),
                          ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),

          // Food Count Text
          Text(
            remaining > 0
                ? '$remaining OF 5 DELICACIES REMAINING'
                : '🎉 ALL DELICACIES EATEN! FOCUS COMPLETE',
            style: TextStyle(
              color: remaining > 0 ? AppColors.enhancerPrimary : AppColors.primaryDark,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  /// Suppressant Boy: Water Absorption Status Subtitle
  Widget _buildWaterStatusIndicator() {
    final waterPercent = (widget.state.progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('💧', style: TextStyle(fontSize: 12)),
          const SizedBox(width: 5),
          Text(
            waterPercent > 0
                ? 'WATER LEVEL: $waterPercent% (ABSORBING)'
                : '✨ PURIFICATION COMPLETE! TRANQUILITY ACHIEVED',
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the bold countdown numbers and mode badges below the stage (Zero Overlap)
  Widget _buildTimerDisplaySection(String timeFormatted, Color activeColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Mode Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: activeColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            widget.state.mode.title.toUpperCase(),
            style: AppTypography.timerStatus.copyWith(
              color: activeColor,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),

        const SizedBox(height: 6),

        // Bold Countdown Digits (Unobstructed, High Contrast)
        Text(
          timeFormatted,
          style: AppTypography.timerDisplay.copyWith(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -1.0,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),

        const SizedBox(height: 4),

        // Reward / Subtitle Indicator
        if (widget.state.mode == PomodoroMode.focus)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🪙', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 5),
              Text(
                '+${widget.state.mode.coinReward} COINS REWARD',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: AppColors.coinGoldDark,
                ),
              ),
            ],
          )
        else
          Text(
            widget.state.mode == PomodoroMode.shortBreak
                ? '☕ SHORT BREAK RELAXATION'
                : '🌿 LONG BREAK RECHARGE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: activeColor,
            ),
          ),
      ],
    );
  }
}

/// Custom painter for Suppressant Boy's shrinking water pond
class _WaterPondPainter extends CustomPainter {
  final double progress; // 1.0 down to 0.0
  final double cycle;
  final bool isRunning;

  _WaterPondPainter({
    required this.progress,
    required this.cycle,
    required this.isRunning,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 10);

    // Dynamic radius based on time progress:
    // Shrinks from ~130px width down to ~45px width
    final maxRx = size.width * 0.44;
    final minRx = size.width * 0.15;
    final currentRx = (minRx + (maxRx - minRx) * progress).clamp(minRx, maxRx);
    final currentRy = currentRx * 0.28;

    // 1. Ambient Glow
    final glowPaint = Paint()
      ..color = const Color(0xFF48D1CC).withValues(alpha: 0.22 * progress)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: currentRx * 2.2, height: currentRy * 2.2),
      glowPaint,
    );

    // 2. Base Water Pool Gradient Fill
    final poolRect = Rect.fromCenter(center: center, width: currentRx * 2, height: currentRy * 2);
    final poolGradient = RadialGradient(
      colors: [
        const Color(0xFFE4F8F7).withValues(alpha: 0.9 * progress + 0.1),
        const Color(0xFF48D1CC).withValues(alpha: 0.75 * progress + 0.1),
        const Color(0xFF27ABA4).withValues(alpha: 0.9 * progress + 0.1),
      ],
      stops: const [0.0, 0.55, 1.0],
    );
    final poolPaint = Paint()
      ..shader = poolGradient.createShader(poolRect)
      ..style = PaintingStyle.fill;
    canvas.drawOval(poolRect, poolPaint);

    // 3. Water Shore Border
    final borderPaint = Paint()
      ..color = const Color(0xFF48D1CC).withValues(alpha: 0.85 * progress + 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawOval(poolRect, borderPaint);

    // 4. Inward Water Absorption Waves (when running)
    if (isRunning && progress > 0.05) {
      for (int i = 0; i < 3; i++) {
        final rippleT = (cycle + i / 3.0) % 1.0;
        final rippleScale = (1.0 - rippleT * 0.70).clamp(0.2, 1.0);
        final rippleAlpha = (math.sin(rippleT * math.pi) * 0.7 * progress).clamp(0.0, 1.0);

        final ripplePaint = Paint()
          ..color = Colors.white.withValues(alpha: rippleAlpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4;

        canvas.drawOval(
          Rect.fromCenter(
            center: center,
            width: currentRx * 2 * rippleScale,
            height: currentRy * 2 * rippleScale,
          ),
          ripplePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WaterPondPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.cycle != cycle ||
        oldDelegate.isRunning != isRunning;
  }
}
