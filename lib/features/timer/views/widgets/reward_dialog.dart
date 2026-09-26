import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../data/models/character_model.dart';

/// Celebratory dialog shown when a Pomodoro focus session completes.
class RewardDialog extends StatelessWidget {
  final int coinsEarned;
  final CharacterModel character;
  final VoidCallback onClaim;

  const RewardDialog({
    super.key,
    required this.coinsEarned,
    required this.character,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final isWarm = character.tone == CharacterTone.warm;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Character Celebration Header
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: character.backgroundColor,
                shape: BoxShape.circle,
                border: Border.all(color: character.borderColor, width: 2),
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                character.assetPath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(
                    isWarm ? Icons.celebration_rounded : Icons.star_rounded,
                    size: 44,
                    color: character.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Title
            const Text(
              'Session Completed 🔔',
              style: AppTypography.headerTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),

            const Text(
              'Focus cycle ended. Rest break starts next.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Coin Award Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.coinGoldLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.coinGold.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🪙', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Text(
                    '+$coinsEarned Coins',
                    style: AppTypography.headerTitle.copyWith(
                      color: AppColors.coinGoldDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Claim Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onClaim,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: const Text('Claim & Start Break', style: AppTypography.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
