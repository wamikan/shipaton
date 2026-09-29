import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../data/models/character_model.dart';
import '../../models/timer_state.dart';

/// Animated avatar widget for the focus timer companion.
/// When timer is running and animation is enabled, displays:
/// - Enhancer (Girl): Food items (Apple, Cinnamon Roll, Pancake) sinking and being enveloped into her slime head.
/// - Suppressant (Boy): Upward water stream through his cape and blooming flowers/berries (Lily of Valley, Cloudberry, Blueberry) atop his sprout.
class CompanionAnimatedAvatar extends StatefulWidget {
  final CharacterModel character;
  final bool isRunning;
  final bool showAnimation;
  final double size;
  final PomodoroMode mode;

  const CompanionAnimatedAvatar({
    super.key,
    required this.character,
    this.isRunning = false,
    this.showAnimation = true,
    this.size = 68,
    this.mode = PomodoroMode.focus,
  });

  @override
  State<CompanionAnimatedAvatar> createState() => _CompanionAnimatedAvatarState();
}

class _CompanionAnimatedAvatarState extends State<CompanionAnimatedAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _cycleController;
  int _itemIndex = 0;

  static const List<String> _foods = [
    AppAssets.foodApple,
    AppAssets.foodCinnamonRoll,
    AppAssets.foodPancake,
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
      duration: const Duration(milliseconds: 4500),
    );

    _cycleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _itemIndex = (_itemIndex + 1) % 3;
        });
        if (widget.isRunning &&
            widget.mode == PomodoroMode.focus &&
            widget.showAnimation) {
          _cycleController.forward(from: 0.0);
        }
      }
    });

    if (widget.isRunning &&
        widget.mode == PomodoroMode.focus &&
        widget.showAnimation) {
      _cycleController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant CompanionAnimatedAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final shouldAnimate = widget.isRunning &&
        widget.mode == PomodoroMode.focus &&
        widget.showAnimation;
    final wasAnimating = oldWidget.isRunning &&
        oldWidget.mode == PomodoroMode.focus &&
        oldWidget.showAnimation;

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
    final char = widget.character;
    final isWarm = char.tone == CharacterTone.warm;
    final isEnhancer = char.id == 'enhancer';
    final isBreak = widget.mode != PomodoroMode.focus;
    final shouldAnimate =
        widget.isRunning && widget.mode == PomodoroMode.focus && widget.showAnimation;

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: char.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: char.borderColor, width: 1.2),
      ),
      padding: const EdgeInsets.all(4),
      clipBehavior: Clip.antiAlias,
      child: AnimatedBuilder(
        animation: _cycleController,
        builder: (context, child) {
          final t = _cycleController.value;
          String sprite;
          if (isBreak) {
            sprite = char.completedAssetPath ?? char.assetPath;
          } else if (widget.isRunning && widget.mode == PomodoroMode.focus) {
            if (t < 0.33) {
              sprite = char.assetPath;
            } else if (t < 0.67) {
              sprite = char.actionAssetPath ?? char.assetPath;
            } else {
              sprite = char.completedAssetPath ?? char.assetPath;
            }
          } else {
            sprite = char.assetPath;
          }

          final isActionPhase = widget.isRunning &&
              widget.mode == PomodoroMode.focus &&
              (t >= 0.33 && t < 0.67);

          return Stack(
            alignment: Alignment.center,
            children: [
              // Base Character Sprite
              Image.asset(
                sprite,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Text(
                    isWarm ? '🔥' : '❄️',
                    style: TextStyle(fontSize: widget.size * 0.4),
                  ),
                ),
              ),

              // Animated Overlay Elements when IN ACTION PHASE OF FOCUS SESSION
              if (shouldAnimate && isActionPhase)
                isEnhancer
                    ? _buildEnhancerEatingLayer(t)
                    : _buildSuppressantWaterLayer(t),
            ],
          );
        },
      ),
    );
  }

  /// Enhancer Girl eating animation:
  /// Food floats above head, sinks into slime, and is enveloped!
  Widget _buildEnhancerEatingLayer(double t) {
    final currentFood = _foods[_itemIndex % _foods.length];

    // Phases:
    // 0.0 - 0.35: Food appears & hovers slightly above slime
    // 0.35 - 0.75: Sinks into the slime & scales down
    // 0.75 - 1.0: Slime gleam & swallow pulse
    double foodScale = 1.0;
    double foodOpacity = 1.0;
    double foodY = -widget.size * 0.32; // On top of head slime

    if (t < 0.35) {
      // Gentle bobbing before eating
      final bob = math.sin(t / 0.35 * math.pi) * 2.0;
      foodY += bob;
      foodScale = 0.9 + (t / 0.35) * 0.1;
      foodOpacity = (t / 0.1).clamp(0.0, 1.0);
    } else if (t < 0.75) {
      // Sinking into slime
      final sinkProgress = (t - 0.35) / 0.40;
      foodY += sinkProgress * (widget.size * 0.12);
      foodScale = (1.0 - sinkProgress * 0.65).clamp(0.2, 1.0);
      foodOpacity = (1.0 - sinkProgress * 0.85).clamp(0.0, 1.0);
    } else {
      // Swallowed
      foodOpacity = 0.0;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Sinking Food Item
        if (foodOpacity > 0.01)
          Transform.translate(
            offset: Offset(0, foodY),
            child: Transform.scale(
              scale: foodScale,
              child: Opacity(
                opacity: foodOpacity,
                child: SizedBox(
                  width: widget.size * 0.34,
                  height: widget.size * 0.34,
                  child: Image.asset(
                    currentFood,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

        // Slime Gel Highlight Pulse (at swallowing peak)
        if (t >= 0.35 && t <= 0.85)
          Positioned(
            top: widget.size * 0.06,
            child: Opacity(
              opacity: math.sin((t - 0.35) / 0.50 * math.pi) * 0.55,
              child: Container(
                width: widget.size * 0.40,
                height: widget.size * 0.22,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.6),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Suppressant Boy water absorption & blooming animation:
  /// Water flows up from ground, and flower/berry blooms on his sprout!
  Widget _buildSuppressantWaterLayer(double t) {
    final currentBloom = _blooms[_itemIndex % _blooms.length];

    // Phases:
    // 0.0 - 0.45: Water ascends through cape (ground ripple + water stream)
    // 0.45 - 0.85: Sprout blooms into flower/berry atop head
    // 0.85 - 1.0: Crystal sparkles & harvest fade
    double bloomScale = 0.0;
    double bloomOpacity = 0.0;
    final double bloomY = -widget.size * 0.34; // Atop head sprout

    if (t >= 0.35 && t < 0.85) {
      final bloomT = (t - 0.35) / 0.50;
      if (bloomT < 0.3) {
        // Pop up
        bloomScale = (bloomT / 0.3) * 1.1;
        bloomOpacity = (bloomT / 0.2).clamp(0.0, 1.0);
      } else {
        // Full bloom shimmer
        bloomScale = 1.0 + math.sin((bloomT - 0.3) * math.pi * 3) * 0.05;
        bloomOpacity = 1.0;
      }
    } else if (t >= 0.85) {
      // Fade & crystal disperse
      final fadeT = (t - 0.85) / 0.15;
      bloomScale = 1.0 + fadeT * 0.2;
      bloomOpacity = (1.0 - fadeT).clamp(0.0, 1.0);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Ground Water Absorption Wave (at base of cape)
        if (t < 0.55)
          Positioned(
            bottom: widget.size * 0.04,
            child: Opacity(
              opacity: math.sin((t / 0.55) * math.pi) * 0.65,
              child: Container(
                width: widget.size * 0.50,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF48D1CC),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF48D1CC),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Blooming Flower / Berry atop Sprout
        if (bloomOpacity > 0.01)
          Transform.translate(
            offset: Offset(0, bloomY),
            child: Transform.scale(
              scale: bloomScale,
              child: Opacity(
                opacity: bloomOpacity,
                child: SizedBox(
                  width: widget.size * 0.36,
                  height: widget.size * 0.36,
                  child: Image.asset(
                    currentBloom,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
