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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Icon(
                      pack.icon,
                      color: AppColors.coinGoldDark,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          children: [
                            Text(
                              pack.title,
                              style: AppTypography.sectionTitle.copyWith(fontSize: 14),
                            ),
                            if (pack.isPopular)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'POPULAR',
                                  style: TextStyle(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
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
                  const SizedBox(width: 8),

                  // Purchase Button
                  ElevatedButton(
                    onPressed: _isProcessing
                        ? null
                        : () async {
                            final nav = Navigator.of(context);
                            final messenger = ScaffoldMessenger.of(context);
                            setState(() => _isProcessing = true);
                            try {
                              final success =
                                  await purchaseService.purchaseCoinPack(pack);
                              if (success && mounted) {
                                nav.pop();
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Successfully added +${pack.coins} Coins to your balance!',
                                    ),
                                    backgroundColor: AppColors.primaryDark,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              } else if (!success && mounted) {
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('Purchase was not completed.'),
                                    backgroundColor: AppColors.textSecondary,
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 2),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: const Size(64, 38),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      pack.priceString,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
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
                      final messenger = ScaffoldMessenger.of(context);
                      setState(() => _isProcessing = true);
                      try {
                        final success = await purchaseService.restorePurchases();
                        if (mounted) {
                          messenger.showSnackBar(
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
