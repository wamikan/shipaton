import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../data/models/character_model.dart';
import '../../models/timer_state.dart';

/// Configuration for individual food items in the girl's background food mountain
class _FoodMountainItem {
  final String asset;
  final Offset offset;
  final double scale;
  final double rotation;
  final double fadeStart;
  final double fadeEnd;

  const _FoodMountainItem({
    required this.asset,
    required this.offset,
    required this.scale,
    this.rotation = 0.0,
    required this.fadeStart,
    required this.fadeEnd,
  });
}

/// Central stage displaying the animated companion and organic time progress.
/// Replaces the circular progress ring when Focus Companion Animation is enabled:
/// - Enhancer (Girl): Frameless character standing in front of a giant mountain of stacked food
///   that seamlessly sinks and fades out as she feasts, with active eating at her slime head.
/// - Suppressant (Boy): Frameless character standing directly inside a massive arctic water puddle
///   that overflows the stage and smoothly shrinks inward as his cloak absorbs it, blooming flowers on his head.
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

  static const List<Map<String, String>> _activeFoods = [
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

  /// Mountain of stacked delicacies positioned in tiers behind the girl
  static const List<_FoodMountainItem> _mountainItems = [
    // --- Tier 1: Peak (Top tier, fades out first between 1.0 and 0.68) ---
    _FoodMountainItem(
      asset: AppAssets.foodApple,
      offset: Offset(-34, -62),
      scale: 0.88,
      rotation: -0.15,
      fadeStart: 1.0,
      fadeEnd: 0.72,
    ),
    _FoodMountainItem(
      asset: AppAssets.foodCinnamonRoll,
      offset: Offset(0, -72),
      scale: 0.95,
      rotation: 0.08,
      fadeStart: 1.0,
      fadeEnd: 0.68,
    ),
    _FoodMountainItem(
      asset: AppAssets.foodPancake,
      offset: Offset(36, -60),
      scale: 0.90,
      rotation: 0.16,
      fadeStart: 1.0,
      fadeEnd: 0.70,
    ),

    // --- Tier 2: Upper-Mid (Fades out between 0.90 and 0.45) ---
    _FoodMountainItem(
      asset: AppAssets.berryCloudberry,
      offset: Offset(-76, -34),
      scale: 0.92,
      rotation: -0.22,
      fadeStart: 0.92,
      fadeEnd: 0.50,
    ),
    _FoodMountainItem(
      asset: AppAssets.foodPancake,
      offset: Offset(-38, -26),
      scale: 1.0,
      rotation: 0.06,
      fadeStart: 0.88,
      fadeEnd: 0.46,
    ),
    _FoodMountainItem(
      asset: AppAssets.berryBlueberry,
      offset: Offset(0, -22),
      scale: 0.86,
      rotation: -0.12,
      fadeStart: 0.82,
      fadeEnd: 0.44,
    ),
    _FoodMountainItem(
      asset: AppAssets.foodApple,
      offset: Offset(40, -28),
      scale: 0.95,
      rotation: -0.10,
      fadeStart: 0.88,
      fadeEnd: 0.48,
    ),
    _FoodMountainItem(
      asset: AppAssets.foodCinnamonRoll,
      offset: Offset(78, -32),
      scale: 0.92,
      rotation: 0.20,
      fadeStart: 0.90,
      fadeEnd: 0.48,
    ),

    // --- Tier 3: Mid-Lower (Fades out between 0.75 and 0.22) ---
    _FoodMountainItem(
      asset: AppAssets.foodCinnamonRoll,
      offset: Offset(-112, 6),
      scale: 1.05,
      rotation: -0.26,
      fadeStart: 0.78,
      fadeEnd: 0.32,
    ),
    _FoodMountainItem(
      asset: AppAssets.foodApple,
      offset: Offset(-72, 8),
      scale: 1.02,
      rotation: 0.14,
      fadeStart: 0.72,
      fadeEnd: 0.26,
    ),
    _FoodMountainItem(
      asset: AppAssets.foodPancake,
      offset: Offset(-28, 14),
      scale: 1.08,
      rotation: -0.06,
      fadeStart: 0.66,
      fadeEnd: 0.20,
    ),
    _FoodMountainItem(
      asset: AppAssets.berryCloudberry,
      offset: Offset(28, 12),
      scale: 0.98,
      rotation: 0.18,
      fadeStart: 0.68,
      fadeEnd: 0.22,
    ),
    _FoodMountainItem(
      asset: AppAssets.berryBlueberry,
      offset: Offset(74, 10),
      scale: 0.98,
      rotation: -0.16,
      fadeStart: 0.74,
      fadeEnd: 0.28,
    ),
    _FoodMountainItem(
      asset: AppAssets.foodApple,
      offset: Offset(114, 8),
      scale: 1.02,
      rotation: 0.22,
      fadeStart: 0.78,
      fadeEnd: 0.30,
    ),

    // --- Tier 4: Base Foundation (Fades out between 0.55 and 0.0) ---
    _FoodMountainItem(
      asset: AppAssets.foodPancake,
      offset: Offset(-142, 46),
      scale: 1.10,
      rotation: -0.12,
      fadeStart: 0.58,
      fadeEnd: 0.06,
    ),
    _FoodMountainItem(
      asset: AppAssets.berryBlueberry,
      offset: Offset(-102, 50),
      scale: 0.98,
      rotation: 0.12,
      fadeStart: 0.52,
      fadeEnd: 0.03,
    ),
    _FoodMountainItem(
      asset: AppAssets.foodCinnamonRoll,
      offset: Offset(-60, 52),
      scale: 1.12,
      rotation: 0.06,
      fadeStart: 0.46,
      fadeEnd: 0.0,
    ),
    _FoodMountainItem(
      asset: AppAssets.foodApple,
      offset: Offset(-18, 56),
      scale: 1.08,
      rotation: -0.14,
      fadeStart: 0.40,
      fadeEnd: 0.0,
    ),
    _FoodMountainItem(
      asset: AppAssets.foodPancake,
      offset: Offset(26, 54),
      scale: 1.14,
      rotation: 0.10,
      fadeStart: 0.44,
      fadeEnd: 0.0,
    ),
    _FoodMountainItem(
      asset: AppAssets.berryCloudberry,
      offset: Offset(70, 52),
      scale: 1.04,
      rotation: -0.08,
      fadeStart: 0.48,
      fadeEnd: 0.02,
    ),
    _FoodMountainItem(
      asset: AppAssets.foodCinnamonRoll,
      offset: Offset(112, 48),
      scale: 1.08,
      rotation: 0.18,
      fadeStart: 0.54,
      fadeEnd: 0.04,
    ),
    _FoodMountainItem(
      asset: AppAssets.foodApple,
      offset: Offset(146, 44),
      scale: 1.04,
      rotation: -0.20,
      fadeStart: 0.58,
      fadeEnd: 0.06,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _cycleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    );

    _cycleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _itemIndex = (_itemIndex + 1) % _activeFoods.length;
        });
        if (widget.state.isRunning && widget.state.mode == PomodoroMode.focus) {
          _cycleController.forward(from: 0.0);
        }
      }
    });

    if (widget.state.isRunning && widget.state.mode == PomodoroMode.focus) {
      _cycleController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedFocusStage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final shouldAnimate =
        widget.state.isRunning && widget.state.mode == PomodoroMode.focus;
    final wasAnimating =
        oldWidget.state.isRunning && oldWidget.state.mode == PomodoroMode.focus;

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
        // 1. Companion Switch Pill (Interactive Header)
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

        const SizedBox(height: 10),

        // 2. Frameless Central Stage (Wide & Open Atmosphere)
        SizedBox(
          width: 360,
          height: 260,
          child: AnimatedBuilder(
            animation: _cycleController,
            builder: (context, child) {
              final t = _cycleController.value;
              final isFocusMode = widget.state.mode == PomodoroMode.focus;
              final isBreak = !isFocusMode;
              final progress = isFocusMode ? widget.state.progress : 0.0;

              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // --- GIRL (ENHANCER): Stacked Mountain of Food Behind Her (Focus mode only) ---
                  if (isEnhancer && isFocusMode)
                    Positioned(
                      top: 60,
                      child: _buildFoodMountain(progress, t),
                    ),

                  // --- BOY (SUPPRESSANT): Massive Seamless Water Puddle Beneath Him ---
                  if (!isEnhancer)
                    Positioned(
                      top: 155,
                      child: CustomPaint(
                        size: const Size(380, 100),
                        painter: _SeamlessWaterPondPainter(
                          progress: progress,
                          cycle: t,
                          isRunning: isFocusMode && widget.state.isRunning,
                          isAbsorbing: isFocusMode && widget.state.isRunning,
                        ),
                      ),
                    ),

                  // --- Frameless Hero Character (Standing Freely in Environment) ---
                  Positioned(
                    top: isEnhancer ? 20 : 25,
                    child: _buildFramelessHero(char, isEnhancer, t),
                  ),

                  // --- Girl: Serving Plate with Active Delicacy or Break Relaxation Status ---
                  if (isEnhancer)
                    Positioned(
                      bottom: 4,
                      child: isBreak
                          ? _buildGirlBreakStatus()
                          : _buildGirlFeastStatus(progress),
                    ),

                  // --- Boy: Seamless Water Purification Status or Break Relaxation Status ---
                  if (!isEnhancer)
                    Positioned(
                      bottom: 4,
                      child: isBreak
                          ? _buildBoyBreakStatus()
                          : _buildBoyWaterStatus(progress),
                    ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 14),

        // 3. Clear, Non-Overlapping Countdown Section (Below Stage)
        _buildTimerDisplaySection(timeFormatted, activeColor),
      ],
    );
  }

  /// Builds the background mountain of delicacies stacked behind the girl.
  /// Seamlessly sinks and fades out as focus time advances.
  Widget _buildFoodMountain(double progress, double t) {
    // Sinking down as progress decreases
    final sinkY = (1.0 - progress) * 32.0;

    return Transform.translate(
      offset: Offset(0, sinkY),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Background ambient feast glow
          Opacity(
            opacity: (0.15 + 0.55 * progress).clamp(0.0, 0.7),
            child: Container(
              width: 310,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.orange.withValues(alpha: 0.35),
                    Colors.amber.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),

          // Piled Food Items
          ..._mountainItems.map((item) {
            // Calculate individual seamless opacity based on progress range
            double itemOpacity = 1.0;
            if (progress >= item.fadeStart) {
              itemOpacity = 1.0;
            } else if (progress <= item.fadeEnd) {
              itemOpacity = 0.0;
            } else {
              itemOpacity = (progress - item.fadeEnd) / (item.fadeStart - item.fadeEnd);
            }

            if (itemOpacity <= 0.005) return const SizedBox.shrink();

            // Subtle feast breathing bob when timer is running
            final itemBob = widget.state.isRunning
                ? math.sin(t * math.pi * 2 + item.offset.dx * 0.05) * 1.5
                : 0.0;

            return Transform.translate(
              offset: Offset(item.offset.dx, item.offset.dy + itemBob),
              child: Transform.rotate(
                angle: item.rotation,
                child: Transform.scale(
                  scale: item.scale,
                  child: Opacity(
                    opacity: itemOpacity,
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: Image.asset(
                        item.asset,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Resolves the character sprite depending on timer status:
  /// - Break mode: Always smiling (enhancer_2 / suppressant_2), resting without consuming.
  /// - Focus session completed: Celebration smiling (enhancer_2 / suppressant_2).
  /// - Focus session running: Loops through Standard -> Action (eating/drinking) -> Smile.
  /// - Normal / Idle / Paused: Fixed at Standard default illustration.
  String _resolveCharacterSprite(CharacterModel char, bool isEnhancer, double t) {
    final isBreak = widget.state.mode != PomodoroMode.focus;
    final isRunning = widget.state.isRunning;
    final isCompleted =
        widget.state.isCompleted || widget.state.remainingSeconds == 0;

    // 1. 休憩中 (Break mode): Always smiling
    if (isBreak) {
      return char.completedAssetPath ?? char.assetPath;
    }

    // 2. セッション完了 (Completed): Celebration smiling pose
    if (isCompleted) {
      return char.completedAssetPath ?? char.assetPath;
    }

    // 3. 作業用タイマー実行中 (Focus mode running):
    // ループ: 標準状態 -> 食材捕食・水分吸収 -> 笑顔
    if (isRunning) {
      if (t < 0.33) {
        return char.assetPath; // 1. 標準状態
      } else if (t < 0.67) {
        return char.actionAssetPath ?? char.assetPath; // 2. 食材捕食・水分吸収
      } else {
        return char.completedAssetPath ?? char.assetPath; // 3. 笑顔
      }
    }

    // 4. 通常時 (Normal / Idle / Paused in focus mode):
    // 標準状態のまま
    return char.assetPath;
  }

  /// Builds the frameless hero character without any card box or outline.
  Widget _buildFramelessHero(CharacterModel char, bool isEnhancer, double t) {
    const double spriteSize = 150;
    final spritePath = _resolveCharacterSprite(char, isEnhancer, t);
    final isFocusRunning =
        widget.state.mode == PomodoroMode.focus && widget.state.isRunning;
    final isActionPhase = isFocusRunning && (t >= 0.33 && t < 0.67);

    // Subtle rhythmic munching/breathing scale during active eating/drinking phase
    final double spriteScale = isFocusRunning
        ? 1.0 +
            (isActionPhase
                ? math.sin(t * math.pi * 6) * 0.025
                : math.sin(t * math.pi * 2) * 0.01)
        : 1.0;
    final double spriteBob =
        isActionPhase ? math.sin(t * math.pi * 6) * 1.5 : 0.0;

    return SizedBox(
      width: spriteSize,
      height: spriteSize,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Subtle soft ground contact shadow
          Positioned(
            bottom: 4,
            child: Container(
              width: spriteSize * 0.65,
              height: 14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: isEnhancer
                        ? Colors.orange.withValues(alpha: 0.18)
                        : const Color(0xFF27ABA4).withValues(alpha: 0.35),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),

          // High-Res Frameless Character Sprite with dynamic state
          Transform.translate(
            offset: Offset(0, spriteBob),
            child: Transform.scale(
              scale: spriteScale,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Image.asset(
                  spritePath,
                  key: ValueKey(spritePath),
                  width: spriteSize,
                  height: spriteSize,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Text(
                      char.tone == CharacterTone.warm ? '🔥' : '❄️',
                      style: const TextStyle(fontSize: 54),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Girl Slime digestion glow pulse during active eating phase
          if (isEnhancer && isActionPhase)
            Positioned(
              top: spriteSize * 0.04,
              child: Opacity(
                opacity: (math.sin((t - 0.33) / 0.34 * math.pi) * 0.55).clamp(0.0, 1.0),
                child: Container(
                  width: spriteSize * 0.44,
                  height: spriteSize * 0.22,
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.amber,
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Boy Head Sprout water absorption sparkles during active absorption phase
          if (!isEnhancer && isActionPhase)
            Positioned(
              top: -spriteSize * 0.12,
              child: Opacity(
                opacity: (math.sin((t - 0.33) / 0.34 * math.pi) * 0.85).clamp(0.0, 1.0),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('✨', style: TextStyle(fontSize: 13, color: AppColors.primary)),
                    SizedBox(width: 8),
                    Text('💧', style: TextStyle(fontSize: 11)),
                    SizedBox(width: 8),
                    Text('✨', style: TextStyle(fontSize: 13, color: AppColors.primary)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Girl (食欲増進ちゃん): Slime head swallowing active food
  Widget _buildGirlEatingOverlay(double spriteSize, double t) {
    final currentFood = _activeFoods[_itemIndex % _activeFoods.length]['path']!;

    double foodScale = 1.0;
    double foodOpacity = 1.0;
    double foodY = -spriteSize * 0.38;

    if (t < 0.35) {
      final bob = math.sin(t / 0.35 * math.pi) * 3.0;
      foodY += bob;
      foodScale = 0.92 + (t / 0.35) * 0.15;
      foodOpacity = (t / 0.1).clamp(0.0, 1.0);
    } else if (t < 0.75) {
      final sinkProgress = (t - 0.35) / 0.40;
      foodY += sinkProgress * (spriteSize * 0.18);
      foodScale = (1.07 - sinkProgress * 0.75).clamp(0.2, 1.07);
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
                  width: spriteSize * 0.38,
                  height: spriteSize * 0.38,
                  child: Image.asset(currentFood, fit: BoxFit.contain),
                ),
              ),
            ),
          ),

        // Slime gel amber glow pulse during swallow
        if (t >= 0.35 && t <= 0.85)
          Positioned(
            top: spriteSize * 0.04,
            child: Opacity(
              opacity: math.sin((t - 0.35) / 0.50 * math.pi) * 0.65,
              child: Container(
                width: spriteSize * 0.48,
                height: spriteSize * 0.26,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.amber,
                      blurRadius: 12,
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
  Widget _buildBoyBloomingOverlay(double spriteSize, double t) {
    final currentBloom = _blooms[_itemIndex % _blooms.length];

    double bloomScale = 0.0;
    double bloomOpacity = 0.0;
    final double bloomY = -spriteSize * 0.42;

    if (t >= 0.35 && t < 0.85) {
      final bloomT = (t - 0.35) / 0.50;
      if (bloomT < 0.3) {
        bloomScale = (bloomT / 0.3) * 1.18;
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
                  width: spriteSize * 0.40,
                  height: spriteSize * 0.40,
                  child: Image.asset(currentBloom, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Girl: Break relaxation status pill (Smiling, no feast consumed)
  Widget _buildGirlBreakStatus() {
    final isShort = widget.state.mode == PomodoroMode.shortBreak;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.enhancerBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(isShort ? '☕' : '🌿', style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 8),
          Text(
            isShort ? 'SHORT BREAK: RELAX & SMILE' : 'LONG BREAK: PEACEFUL RECHARGE',
            style: const TextStyle(
              color: AppColors.enhancerPrimary,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  /// Boy: Break relaxation status pill (Smiling, no water absorbed)
  Widget _buildBoyBreakStatus() {
    final isShort = widget.state.mode == PomodoroMode.shortBreak;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(18),
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
          Text(isShort ? '☕' : '🌿', style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Text(
            isShort
                ? 'SHORT BREAK: TRANQUILITY (NO ABSORPTION)'
                : 'LONG BREAK: TRANQUILITY (NO ABSORPTION)',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  /// Girl: Feast status pill with active dish and percentage
  Widget _buildGirlFeastStatus(double progress) {
    final percent = (progress * 100).toInt();
    final activeFood = _activeFoods[_itemIndex % _activeFoods.length];
    final isRunning = widget.state.isRunning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.enhancerBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Image.asset(activeFood['path']!, fit: BoxFit.contain),
          ),
          const SizedBox(width: 8),
          Text(
            percent > 0
                ? (isRunning
                    ? 'FEAST IN PROGRESS: $percent% REMAINING'
                    : 'FEAST: $percent% REMAINING (READY)')
                : '🎉 ALL FEAST DEVOURED! FOCUS COMPLETE',
            style: TextStyle(
              color: percent > 0 ? AppColors.enhancerPrimary : AppColors.primaryDark,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  /// Boy: Water level status pill with seamless percentage
  Widget _buildBoyWaterStatus(double progress) {
    final waterPercent = (progress * 100).toInt();
    final isRunning = widget.state.isRunning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(18),
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
          const SizedBox(width: 6),
          Text(
            waterPercent > 0
                ? (isRunning
                    ? 'WATER LEVEL: $waterPercent% (ABSORBING)'
                    : 'WATER LEVEL: $waterPercent% (READY)')
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

/// Custom painter for Suppressant Boy's massive, seamless shrinking water pond.
/// The boy stands directly on top of this pool.
/// At progress = 1.0, it spans wide across the stage (~360px), and shrinks seamlessly
/// inward towards the cloak hem as time elapses.
class _SeamlessWaterPondPainter extends CustomPainter {
  final double progress; // 1.0 down to 0.0 (smoothly continuous)
  final double cycle;
  final bool isRunning;
  final bool isAbsorbing;

  _SeamlessWaterPondPainter({
    required this.progress,
    required this.cycle,
    required this.isRunning,
    this.isAbsorbing = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Initial pool spans wide (~360px width, 92px height),
    // and seamlessly shrinks inward to ~54px width, 18px height right under his cloak.
    const double maxRx = 175.0; // 350px width
    const double minRx = 27.0;  // 54px width
    const double maxRy = 46.0;  // 92px height
    const double minRy = 9.0;   // 18px height

    final currentRx = (minRx + (maxRx - minRx) * progress).clamp(minRx, maxRx);
    final currentRy = (minRy + (maxRy - minRy) * progress).clamp(minRy, maxRy);

    // 1. Vast Ambient Arctic Glow (extends even beyond the pond)
    final glowPaint = Paint()
      ..color = const Color(0xFF48D1CC).withValues(alpha: 0.28 * progress)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: currentRx * 2.25, height: currentRy * 2.25),
      glowPaint,
    );

    // 2. Base Water Pool Fill (Luminous Arctic Gradient)
    final poolRect = Rect.fromCenter(center: center, width: currentRx * 2, height: currentRy * 2);
    final poolGradient = RadialGradient(
      colors: [
        const Color(0xFFF0FDFB).withValues(alpha: 0.95 * progress + 0.05),
        const Color(0xFF48D1CC).withValues(alpha: 0.85 * progress + 0.10),
        const Color(0xFF1E8D87).withValues(alpha: 0.95 * progress + 0.05),
      ],
      stops: const [0.0, 0.55, 1.0],
    );
    final poolPaint = Paint()
      ..shader = poolGradient.createShader(poolRect)
      ..style = PaintingStyle.fill;
    canvas.drawOval(poolRect, poolPaint);

    // 3. Crisp Translucent Water Shoreline Border
    final borderPaint = Paint()
      ..color = const Color(0xFF6DEBE6).withValues(alpha: 0.9 * progress + 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;
    canvas.drawOval(poolRect, borderPaint);

    // 4. Inward Water Absorption Waves (smoothly flowing towards cape center)
    if (isRunning && isAbsorbing && progress > 0.03) {
      for (int i = 0; i < 4; i++) {
        final rippleT = (cycle + i / 4.0) % 1.0;
        final rippleScale = (1.0 - rippleT * 0.78).clamp(0.15, 1.0);
        final rippleAlpha = (math.sin(rippleT * math.pi) * 0.75 * progress).clamp(0.0, 1.0);

        final ripplePaint = Paint()
          ..color = Colors.white.withValues(alpha: rippleAlpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

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

    // 5. Water contact rim grounding the boy's cape directly into the pool
    final contactRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - 2),
      width: minRx * 2.2,
      height: minRy * 2.2,
    );
    final contactPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65 * progress + 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawOval(contactRect, contactPaint);
  }

  @override
  bool shouldRepaint(covariant _SeamlessWaterPondPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.cycle != cycle ||
        oldDelegate.isRunning != isRunning;
  }
}
