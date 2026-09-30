import 'dart:math' as math;
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

  // static const List<Map<String, String>> _activeFoods = [
  //   {'path': AppAssets.foodApple, 'name': 'Apple'},
  //   {'path': AppAssets.foodCinnamonRoll, 'name': 'Cinnamon Roll'},
  //   {'path': AppAssets.foodPancake, 'name': 'Pancake'},
  //   {'path': AppAssets.berryCloudberry, 'name': 'Cloudberry'},
  //   {'path': AppAssets.berryBlueberry, 'name': 'Blueberry'},
  // ];

  // static const List<String> _blooms = [
  //   AppAssets.flowerLilyValley,
  //   AppAssets.berryCloudberry,
  //   AppAssets.berryBlueberry,
  // ];

  // 
  static final List<Map<String, String>> _activeFoods = AppAssets.foods
      .map((path) => {'path': path, 'name': 'Food Item'})
      .toList();

  // 
  static final List<String> _blooms = AppAssets.plants;

  // 
  static final List<_FoodMountainItem> _mountainItems = List.generate(
    22,
    (index) => _FoodMountainItem(
      asset: AppAssets.foods[index % AppAssets.foods.length],
      offset: _mountainPositions[index].offset,
      scale: _mountainPositions[index].scale,
      rotation: _mountainPositions[index].rotation,
      fadeStart: _mountainPositions[index].fadeStart,
      fadeEnd: _mountainPositions[index].fadeEnd,
    ),
  );

    // 
  // final List<_FoodMountainItem> _mountainPositions = [
  // Layout for each tier of the mountain (asset here is a fallback;
  // _mountainItems below picks the asset from AppAssets.foods).
  static const List<_FoodMountainItem> _mountainPositions = [  
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
  // /// Mountain of stacked delicacies positioned in tiers behind the girl
  // static const List<_FoodMountainItem> _mountainItems = [
  //   // --- Tier 1: Peak (Top tier, fades out first between 1.0 and 0.68) ---
  //   _FoodMountainItem(
  //     asset: AppAssets.foodApple,
  //     offset: Offset(-34, -62),
  //     scale: 0.88,
  //     rotation: -0.15,
  //     fadeStart: 1.0,
  //     fadeEnd: 0.72,
  //   ),
  //   _FoodMountainItem(
  //     asset: AppAssets.foodCinnamonRoll,
  //     offset: Offset(0, -72),
  //     scale: 0.95,
  //     rotation: 0.08,
  //     fadeStart: 1.0,
  //     fadeEnd: 0.68,
  //   ),
  //   _FoodMountainItem(
  //     asset: AppAssets.foodPancake,
  //     offset: Offset(36, -60),
  //     scale: 0.90,
  //     rotation: 0.16,
  //     fadeStart: 1.0,
  //     fadeEnd: 0.70,
  //   ),

  //   // --- Tier 2: Upper-Mid (Fades out between 0.90 and 0.45) ---
  //   _FoodMountainItem(
  //     asset: AppAssets.berryCloudberry,
  //     offset: Offset(-76, -34),
  //     scale: 0.92,
  //     rotation: -0.22,
  //     fadeStart: 0.92,
  //     fadeEnd: 0.50,
  //   ),
  //   _FoodMountainItem(
  //     asset: AppAssets.foodPancake,
  //     offset: Offset(-38, -26),
  //     scale: 1.0,
  //     rotation: 0.06,
  //     fadeStart: 0.88,
  //     fadeEnd: 0.46,
  //   ),
  //   _FoodMountainItem(
  //     asset: AppAssets.berryBlueberry,
  //     offset: Offset(0, -22),
  //     scale: 0.86,
  //     rotation: -0.12,
  //     fadeStart: 0.82,
  //     fadeEnd: 0.44,
  //   ),
  //   _FoodMountainItem(
  //     asset: AppAssets.foodApple,
  //     offset: Offset(40, -28),
  //     scale: 0.95,
  //     rotation: -0.10,
  //     fadeStart: 0.88,
  //     fadeEnd: 0.48,
  //   ),
  //   _FoodMountainItem(
  //     asset: AppAssets.foodCinnamonRoll,
  //     offset: Offset(78, -32),
  //     scale: 0.92,
  //     rotation: 0.20,
  //     fadeStart: 0.90,
  //     fadeEnd: 0.48,
  //   ),

  //   // --- Tier 3: Mid-Lower (Fades out between 0.75 and 0.22) ---
  //   _FoodMountainItem(
  //     asset: AppAssets.foodCinnamonRoll,
  //     offset: Offset(-112, 6),
  //     scale: 1.05,
  //     rotation: -0.26,
  //     fadeStart: 0.78,
  //     fadeEnd: 0.32,
  //   ),
  //   _FoodMountainItem(
  //     asset: AppAssets.foodApple,
  //     offset: Offset(-72, 8),
  //     scale: 1.02,
  //     rotation: 0.14,
  //     fadeStart: 0.72,
  //     fadeEnd: 0.26,
  //   ),
  //   _FoodMountainItem(
  //     asset: AppAssets.foodPancake,
  //     offset: Offset(-28, 14),
  //     scale: 1.08,
  //     rotation: -0.06,
  //     fadeStart: 0.66,
  //     fadeEnd: 0.20,
  //   ),
  //   _FoodMountainItem(
  //     asset: AppAssets.berryCloudberry,
  //     offset: Offset(28, 12),
  //     scale: 0.98,
  //     rotation: 0.18,
  //     fadeStart: 0.68,
  //     fadeEnd: 0.22,
  //   ),
  //   _FoodMountainItem(
  //     asset: AppAssets.berryBlueberry,
  //     offset: Offset(74, 10),
  //     scale: 0.98,
  //     rotation: -0.16,
  //     fadeStart: 0.74,
  //     fadeEnd: 0.28,
  //   ),
  //   _FoodMountainItem(
  //     asset: AppAssets.foodApple,
  //     offset: Offset(114, 8),
  //     scale: 1.02,
  //     rotation: 0.22,
  //     fadeStart: 0.78,
  //     fadeEnd: 0.30,
  //   ),

  //   // --- Tier 4: Base Foundation (Fades out between 0.55 and 0.0) ---
  //   _FoodMountainItem(
  //     asset: AppAssets.foodPancake,
  //     offset: Offset(-142, 46),
  //     scale: 1.10,
  //     rotation: -0.12,
  //     fadeStart: 0.58,
  //     fadeEnd: 0.06,
  //   ),
  //   _FoodMountainItem(
  //     asset: AppAssets.berryBlueberry,
  //     offset: Offset(-102, 50),
  //     scale: 0.98,
  //     rotation: 0.12,
  //     fadeStart: 0.52,
  //     fadeEnd: 0.03,
  //   ),
  //   _FoodMountainItem(
  //     asset: AppAssets.foodCinnamonRoll,
  //     offset: Offset(-60, 52),
  //     scale: 1.12,
  //     rotation: 0.06,
  //     fadeStart: 0.46,
  //     fadeEnd: 0.0,
  //   ),
  //   _FoodMountainItem(
  //     asset: AppAssets.foodApple,
  //     offset: Offset(-18, 56),
  //     scale: 1.08,
  //     rotation: -0.14,
  //     fadeStart: 0.40,
  //     fadeEnd: 0.0,
  //   ),
  //   _FoodMountainItem(
  //     asset: AppAssets.foodPancake,
  //     offset: Offset(26, 54),
  //     scale: 1.14,
  //     rotation: 0.10,
  //     fadeStart: 0.44,
  //     fadeEnd: 0.0,
  //   ),
  //   _FoodMountainItem(
  //     asset: AppAssets.berryCloudberry,
  //     offset: Offset(70, 52),
  //     scale: 1.04,
  //     rotation: -0.08,
  //     fadeStart: 0.48,
  //     fadeEnd: 0.02,
  //   ),
  //   _FoodMountainItem(
  //     asset: AppAssets.foodCinnamonRoll,
  //     offset: Offset(112, 48),
  //     scale: 1.08,
  //     rotation: 0.18,
  //     fadeStart: 0.54,
  //     fadeEnd: 0.04,
  //   ),
  //   _FoodMountainItem(
  //     asset: AppAssets.foodApple,
  //     offset: Offset(146, 44),
  //     scale: 1.04,
  //     rotation: -0.20,
  //     fadeStart: 0.58,
  //     fadeEnd: 0.06,
  //   ),
  // ];

  @override
  void initState() {
    super.initState();
    _cycleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 9000),
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final path in _companionOriginalSizes.keys) {
      precacheImage(AssetImage(path), context);
    }
    for (final item in _activeFoods) {
      final path = item['path'];
      if (path != null) {
        precacheImage(AssetImage(path), context);
      }
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
                  // Anchored from bottom so feet stay grounded and height scales naturally
                  Positioned(
                    bottom: 44,
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

    // 1. Break mode: Always smiling
    if (isBreak) {
      return char.completedAssetPath ?? char.assetPath;
    }

    // 2. Completed: Celebration smiling pose
    if (isCompleted) {
      return char.completedAssetPath ?? char.assetPath;
    }

    // 3. Focus mode running:
    // Cycle: Idle (1.6s) -> Action Eating/Drinking (4.0s) -> Smiling (3.4s)
    if (isRunning) {
      if (t < 0.18) {
        return char.assetPath; // 1. Idle state
      } else if (t < 0.62) {
        return char.actionAssetPath ?? char.assetPath; // 2. Eating/Drinking action
      } else {
        return char.completedAssetPath ?? char.assetPath; // 3. Smiling
      }
    }

    // 4. Normal / Idle / Paused in focus mode:
    return char.assetPath;
  }

  /// Constant scale factor relative to original image pixel dimensions.
  /// Exactly 1/22.0 across ALL companion images (zero per-image size adjustments).
  static const double _uniformCompanionScale = 1.0 / 22.0;

  static const Map<String, Size> _companionOriginalSizes = {
    AppAssets.characterEnhancer: Size(3300, 4050),
    AppAssets.enhancerEating: Size(4422, 4800),
    AppAssets.enhancerSmiling: Size(3428, 4134),
    AppAssets.characterSuppressant: Size(3300, 3780),
    AppAssets.suppressantDrinking: Size(3151, 3780),
    AppAssets.suppressantFinished: Size(3365, 4200),
  };

  /// Builds the frameless hero character without any card box or outline.
  /// Displayed at the exact uniform scale factor (1/22.0) across all images,
  /// preserving the original proportional dimensions without any per-image scaling.
  Widget _buildFramelessHero(CharacterModel char, bool isEnhancer, double t) {
    final spritePath = _resolveCharacterSprite(char, isEnhancer, t);
    final isFocusRunning =
        widget.state.mode == PomodoroMode.focus && widget.state.isRunning;
    final isActionPhase = isFocusRunning && (t >= 0.18 && t < 0.62);
    final double actionPhaseT =
        isActionPhase ? ((t - 0.18) / 0.44).clamp(0.0, 1.0) : 0.0;

    // Display size derived strictly from original image dimensions multiplied by uniform scale
    // Stable 220x220 bounding box with strictly pinned bottom baseline
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Subtle soft ground contact shadow
          Positioned(
            bottom: 0,
            child: Container(
              width: 150.0 * 0.65,
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

          // Pre-rendered High-Res Character Sprites (Preloaded, GPU resident, 0ms swap, zero blank frame)
          for (final entry in _companionOriginalSizes.entries)
            Positioned(
              bottom: 0,
              child: Offstage(
                offstage: entry.key != spritePath,
                child: Image.asset(
                  entry.key,
                  width: entry.value.width * _uniformCompanionScale,
                  height: entry.value.height * _uniformCompanionScale,
                  fit: BoxFit.fill,
                  alignment: Alignment.bottomCenter,
                  filterQuality: FilterQuality.high,
                  gaplessPlayback: true,
                ),
              ),
            ),

          // Slime Eating Overlay for Enhancer Girl (Phase 1)
          if (isEnhancer && isActionPhase)
            _buildGirlEatingOverlay(actionPhaseT),

          // Sprout Bloom Overlay for Suppressant Boy (Phase 1)
          if (!isEnhancer && isActionPhase)
            _buildBoyBloomingOverlay(actionPhaseT),

          // Girl Slime digestion glow pulse during active eating phase
          if (isEnhancer && isActionPhase)
            Positioned(
              bottom: 218.18 - 36,
              child: Opacity(
                opacity: (math.sin(actionPhaseT * math.pi) * 0.55).clamp(0.0, 1.0),
                child: Container(
                  width: 72,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.amber,
                        blurRadius: 14,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Boy Head Sprout water absorption sparkles during active absorption phase
          if (!isEnhancer && isActionPhase)
            Positioned(
              bottom: 171.82 + 4,
              child: Opacity(
                opacity: (math.sin(actionPhaseT * math.pi) * 0.85).clamp(0.0, 1.0),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('✨', style: TextStyle(fontSize: 14, color: AppColors.primary)),
                    SizedBox(width: 8),
                    Text('💧', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 8),
                    Text('✨', style: TextStyle(fontSize: 14, color: AppColors.primary)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Girl (Appetite Enhancer): Slime head swallowing active food.
  /// Guaranteed to completely swallow and fade to opacity 0 by 84% of Phase 1,
  /// so she transitions into the smile pose with food 100% swallowed.
  Widget _buildGirlEatingOverlay(double phaseT) {
    final currentFood = _activeFoods[_itemIndex % _activeFoods.length]['path']!;

    double foodScale = 1.0;
    double foodOpacity = 1.0;
    double foodY = -24.0;

    if (phaseT < 0.22) {
      final subT = phaseT / 0.22;
      foodY += subT * 14.0;
      foodScale = 0.85 + subT * 0.20;
      foodOpacity = (subT * 1.5).clamp(0.0, 1.0);
    } else if (phaseT < 0.84) {
      final sinkT = (phaseT - 0.22) / 0.62;
      foodY += 14.0 + sinkT * 32.0;
      foodScale = (1.05 - sinkT * 0.85).clamp(0.1, 1.05);
      foodOpacity = (1.0 - sinkT * 1.15).clamp(0.0, 1.0);
    } else {
      // 100% swallowed! Fully absorbed inside slime head before smile begins.
      foodOpacity = 0.0;
      foodScale = 0.0;
    }

    if (foodOpacity <= 0.01) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 218.18 - 28,
      child: Transform.translate(
        offset: Offset(0, foodY),
        child: Transform.scale(
          scale: foodScale,
          child: Opacity(
            opacity: foodOpacity,
            child: SizedBox(
              width: 54,
              height: 54,
              child: Image.asset(currentFood, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  /// Boy (Appetite Suppressant): Sprout blooming on head as water is absorbed.
  /// Flower / Berry blossoms gloriously and dissolves into aura by 92% of Phase 1,
  /// so he transitions into the smiling pose with water absorption fully finished.
  Widget _buildBoyBloomingOverlay(double phaseT) {
    final currentBloom = _blooms[_itemIndex % _blooms.length];

    double bloomScale = 0.0;
    double bloomOpacity = 0.0;
    double bloomY = -28.0;

    if (phaseT < 0.25) {
      final subT = phaseT / 0.25;
      bloomScale = subT * 1.15;
      bloomOpacity = (subT * 1.5).clamp(0.0, 1.0);
    } else if (phaseT < 0.82) {
      final subT = (phaseT - 0.25) / 0.57;
      bloomScale = 1.0 + math.sin(subT * math.pi * 3) * 0.08;
      bloomOpacity = 1.0;
    } else if (phaseT < 0.94) {
      final fadeT = (phaseT - 0.82) / 0.12;
      bloomScale = 1.0 + fadeT * 0.20;
      bloomOpacity = (1.0 - fadeT).clamp(0.0, 1.0);
    } else {
      bloomOpacity = 0.0;
    }

    if (bloomOpacity <= 0.01) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 171.82 - 20,
      child: Transform.translate(
        offset: Offset(0, bloomY),
        child: Transform.scale(
          scale: bloomScale,
          child: Opacity(
            opacity: bloomOpacity,
            child: SizedBox(
              width: 52,
              height: 52,
              child: Image.asset(currentBloom, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
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
    final activebloom = _activeBlooms[_itemIndex % _activeBlooms.length];

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
        // children: [
        //   const Text('💧', style: TextStyle(fontSize: 12)),
        //   const SizedBox(width: 6),
        //   Text(
        //     waterPercent > 0
        //         ? (isRunning
        //             ? 'WATER LEVEL: $waterPercent% (ABSORBING)'
        //             : 'WATER LEVEL: $waterPercent% (READY)')
        //         : '✨ PURIFICATION COMPLETE! TRANQUILITY ACHIEVED',
        //     style: const TextStyle(
        //       color: AppColors.primaryDark,
        //       fontSize: 10,
        //       fontWeight: FontWeight.w800,
        //       letterSpacing: 0.6,
        //     ),
        //   ),
        // ],
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Image.asset(activebloom['path']!, fit: BoxFit.contain),
          ),
          const SizedBox(width: 8),
          Text(
            waterPercent > 0
                ? (isRunning
                    ? 'WATER LEVEL: $waterPercent% (ABSORBING)'
                    : 'WATER LEVEL: $waterPercent% (READY)')
                : '✨ PURIFICATION COMPLETE! TRANQUILITY ACHIEVED',
            style: TextStyle(
              color: waterPercent > 0 ? AppColors.boyWater : AppColors.primaryDark,
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
