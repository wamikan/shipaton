import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../data/models/character_model.dart';
import '../../../gamification/notifiers/focus_stats_notifier.dart';

/// Celebratory dialog shown when a Pomodoro focus session completes.
class RewardDialog extends StatelessWidget {
  final int coinsEarned;
  final CharacterModel character;
  final SessionCompletionReward? reward;
  final VoidCallback onClaim;
  final VoidCallback? onViewCompendium;

  const RewardDialog({
    super.key,
    required this.coinsEarned,
    required this.character,
    this.reward,
    required this.onClaim,
    this.onViewCompendium,
  });

  @override
  Widget build(BuildContext context) {
    final isWarm = character.tone == CharacterTone.warm;
    final primaryColor = character.primaryColor;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Character Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: character.backgroundColor,
                shape: BoxShape.circle,
                border: Border.all(color: character.borderColor, width: 2),
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                character.completedAssetPath ?? character.assetPath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(
                    isWarm ? Icons.celebration_rounded : Icons.star_rounded,
                    size: 40,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Title
            const Text(
              'Session Completed 🔔',
              style: AppTypography.headerTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),

            const Text(
              'Focus session complete! Time for a well-deserved break.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Fairy Quote Bubble
            if (reward != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isWarm ? AppColors.enhancerBg : AppColors.suppressantBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '"${reward!.featuredMessage.quote}"',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                        color: isWarm ? AppColors.enhancerPrimary : const Color(0xFF16605D),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '— ${character.name}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: primaryColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Level Up or New Message Celebration Alerts
            if (reward != null && reward!.didLevelUp) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber, width: 1.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🎉', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Friendship reached Lv.${reward!.newAffection.level} [${reward!.newAffection.levelName}]!',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF8A5B00),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (reward != null && reward!.newlyUnlockedMessages.isNotEmpty) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('✨', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '${reward!.newlyUnlockedMessages.length} new quote(s) unlocked in archive!',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Stats breakdown (Coins & Affection)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('🪙', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Coins Earned',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Text(
                        '+$coinsEarned Coins',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.coinGoldDark,
                        ),
                      ),
                    ],
                  ),
                  if (reward != null) ...[
                    const Divider(height: 14),
                    Row(
                      children: [
                        const Text('🏷️', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            reward!.categoryName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+${reward!.minutesGained} mins Focus',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 14),
                    Row(
                      children: [
                        Text(isWarm ? '🍓' : '💧', style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${character.name} Friendship',
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Lv.${reward!.newAffection.level} (${reward!.newAffection.totalMinutes}m)',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onClaim,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Start Break', style: AppTypography.button),
              ),
            ),

            if (onViewCompendium != null) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: onViewCompendium,
                  icon: const Icon(Icons.menu_book_rounded, size: 18),
                  label: const Text('Open Fairy Archive', style: TextStyle(fontWeight: FontWeight.w700)),
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
