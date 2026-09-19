import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../gamification/notifiers/coin_notifier.dart';

/// Top bar badge showing accumulated coin balance with shop link.
class CoinBalanceBadge extends ConsumerWidget {
  final VoidCallback? onTap;

  const CoinBalanceBadge({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinBalance = ref.watch(coinNotifierProvider);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.coinGoldLight.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.coinGold.withValues(alpha: 0.35),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: AppColors.coinGold,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.monetization_on_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 7),
            Text(
              '$coinBalance',
              style: AppTypography.badge.copyWith(
                color: AppColors.coinGoldDark,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 3),
            const Icon(
              Icons.add_circle_outline_rounded,
              size: 14,
              color: AppColors.coinGoldDark,
            ),
          ],
        ),
      ),
    );
  }
}
