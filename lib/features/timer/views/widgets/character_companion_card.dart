import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../data/models/character_model.dart';

/// Clean, minimal, non-animated Character Companion card.
/// Designed according to modern Apple HIG and Digital Agency Design System standards:
/// bold typography, high-contrast functional labels, zero fluff/poems, zero animations.
class CharacterCompanionCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final char = character;
    final isWarm = char.tone == CharacterTone.warm;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Static Avatar (No animation, crisp presentation)
          _buildCharacterAvatar(char, isWarm),
          const SizedBox(width: 14),

          // Companion Info: Bold, minimal, functional
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: char.primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isWarm ? '🔥 ${char.vibeLabel.toUpperCase()}' : '❄️ ${char.vibeLabel.toUpperCase()}',
                        style: TextStyle(
                          color: char.primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  char.name,
                  style: AppTypography.headerTitle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isRunning ? 'STATUS: IN SESSION' : 'STATUS: READY',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: isRunning ? AppColors.primaryDark : AppColors.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Switch companion button
          if (onSwitchCharacter != null)
            IconButton(
              tooltip: 'Switch Companion',
              onPressed: onSwitchCharacter,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surfaceSecondary,
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.cardBorder, width: 1),
                padding: const EdgeInsets.all(8),
              ),
              icon: const Icon(Icons.swap_horiz_rounded, size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildCharacterAvatar(CharacterModel char, bool isWarm) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: char.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: char.borderColor, width: 1.2),
      ),
      padding: const EdgeInsets.all(4),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        char.assetPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Text(
              isWarm ? '🔥' : '❄️',
              style: const TextStyle(fontSize: 28),
            ),
          );
        },
      ),
    );
  }
}
