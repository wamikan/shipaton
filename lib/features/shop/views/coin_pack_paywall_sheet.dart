import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/services/purchase_service.dart';
import '../models/coin_pack_model.dart';

/// Nordic Paywall bottom sheet displaying consumable Coin Pack options.
class CoinPackPaywallSheet extends ConsumerStatefulWidget {
  const CoinPackPaywallSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const CoinPackPaywallSheet(),
    );
  }

  @override
  ConsumerState<CoinPackPaywallSheet> createState() =>
      _CoinPackPaywallSheetState();
}

class _CoinPackPaywallSheetState extends ConsumerState<CoinPackPaywallSheet> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final purchaseService = ref.read(purchaseServiceProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.coinGoldLight,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.monetization_on_rounded,
                    color: AppColors.coinGold,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Coin Store', style: AppTypography.headerTitle),
                    Text(
                      'Instantly unlock characters and soundscapes',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Coin Pack Cards
          ...CoinPackModel.defaultPacks.map((pack) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: pack.isPopular
                    ? AppColors.primarySubtle
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: pack.isPopular
                      ? AppColors.primary
                      : AppColors.cardBorder,
                  width: pack.isPopular ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Icon(
                      pack.icon,
                      color: AppColors.coinGoldDark,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              pack.title,
                              style: AppTypography.sectionTitle.copyWith(fontSize: 15),
                            ),
                            if (pack.isPopular) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'POPULAR',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          pack.description,
                          style: AppTypography.bodySmall.copyWith(fontSize: 11),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.monetization_on_rounded,
                                size: 14, color: AppColors.coinGold),
                            const SizedBox(width: 4),
                            Text(
                              '+${pack.coins} Coins',
                              style: AppTypography.badge.copyWith(
                                color: AppColors.coinGoldDark,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Purchase Button
                  ElevatedButton(
                    onPressed: _isProcessing
                        ? null
                        : () async {
                            setState(() => _isProcessing = true);
                            try {
                              final success =
                                  await purchaseService.purchaseCoinPack(pack);
                              if (success && mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Successfully added +${pack.coins} Coins to your balance!',
                                    ),
                                    backgroundColor: AppColors.primaryDark,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() => _isProcessing = false);
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pack.isPopular
                          ? AppColors.primary
                          : AppColors.surfaceSecondary,
                      foregroundColor: pack.isPopular
                          ? Colors.white
                          : AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(pack.priceString),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: _isProcessing
                  ? null
                  : () async {
                      setState(() => _isProcessing = true);
                      try {
                        final success = await purchaseService.restorePurchases();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Purchases successfully restored.'
                                    : 'No prior purchases found to restore.',
                              ),
                              backgroundColor: AppColors.primaryDark,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      } finally {
                        if (mounted) {
                          setState(() => _isProcessing = false);
                        }
                      }
                    },
              child: Text(
                'Restore Purchases',
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              'Consumable Coin Packs powered by RevenueCat SDK.',
              style: AppTypography.bodySmall.copyWith(
                fontSize: 10,
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
