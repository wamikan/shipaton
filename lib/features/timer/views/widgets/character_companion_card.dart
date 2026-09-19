import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../data/models/character_model.dart';

/// Character Companion card showing the active imp companion.
/// Uses standard local [AssetImage] with an automatic fallback
/// placeholder so the user can easily drop their hand-drawn PNGs
/// into `assets/images/`.
class CharacterCompanionCard extends StatefulWidget {
  final CharacterModel character;
  final bool isRunning;
  final VoidCallback? onSwitchCharacter;

  const CharacterCompanionCard({
    super.key,
    required this.character,
    required this.isRunning,
    this.onSwitchCharacter,
  });

  @override
  State<CharacterCompanionCard> createState() => _CharacterCompanionCardState();
}

class _CharacterCompanionCardState extends State<CharacterCompanionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final char = widget.character;
    final isWarm = char.tone == CharacterTone.warm;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: char.backgroundColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: char.borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: char.primaryColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Animated Floating Character Slot (with AssetImage + Placeholder fallback)
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              final double offsetY = widget.isRunning
                  ? -4 * math.sin(_floatController.value * math.pi)
                  : -2 * math.sin(_floatController.value * math.pi);
              return Transform.translate(
                offset: Offset(0, offsetY),
                child: child,
              );
            },
            child: _buildCharacterAvatar(char, isWarm),
          ),
          const SizedBox(width: 14),

          // Companion Info & Vibe
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: char.primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        char.vibeLabel,
                        style: AppTypography.bodySmall.copyWith(
                          color: char.primaryColor,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  char.name,
                  style: AppTypography.sectionTitle.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.isRunning
                      ? (isWarm ? 'Cheering for you! ✨' : 'Staying calm and focused ❄️')
                      : 'Tap to switch your companion',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Switch companion button
          if (widget.onSwitchCharacter != null)
            IconButton(
              tooltip: 'Switch Companion',
              onPressed: widget.onSwitchCharacter,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: char.primaryColor,
                side: BorderSide(color: char.borderColor, width: 1),
                padding: const EdgeInsets.all(8),
              ),
              icon: const Icon(Icons.swap_horiz_rounded, size: 20),
            ),
        ],
      ),
    );
  }

  /// Renders either user's local AssetImage or a Nordic SVG-style placeholder
  Widget _buildCharacterAvatar(CharacterModel char, bool isWarm) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: char.borderColor, width: 1.2),
      ),
      padding: const EdgeInsets.all(4),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        char.assetPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Graceful Nordic vector placeholder when user has not yet dropped the PNG
          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Soft background aura
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: char.primaryColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                ),
                // Stylized Imp Icon representation
                Icon(
                  isWarm ? Icons.auto_awesome_rounded : Icons.ac_unit_rounded,
                  size: 28,
                  color: char.primaryColor,
                ),
                Positioned(
                  bottom: 4,
                  child: Text(
                    isWarm ? 'Warm' : 'Cool',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: char.primaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
