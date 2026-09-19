import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/shop_item_model.dart';
import '../../gamification/notifiers/coin_notifier.dart';
import '../../timer/views/widgets/coin_balance_badge.dart';
import '../notifiers/shop_notifier.dart';
import 'coin_pack_paywall_sheet.dart';

/// In-App Shop screen for unlocking characters, BGM, and purchasing Coin Packs.
class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: ShopCategory.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(shopNotifierProvider);
    final userCoins = ref.watch(coinNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('In-App Shop', style: AppTypography.headerTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CoinBalanceBadge(
              onTap: () => CoinPackPaywallSheet.show(context),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryDark,
          unselectedLabelColor: AppColors.textTertiary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: AppTypography.button.copyWith(fontSize: 14),
          tabs: ShopCategory.values
              .map((category) => Tab(text: category.title))
              .toList(),
        ),
      ),
      body: Column(
        children: [
          // Top Banner for Coin Packs (RevenueCat Paywall shortcut)
          Container(
            margin: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primarySubtle,
                  AppColors.coinGoldLight.withValues(alpha: 0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: AppColors.coinGold,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.diamond_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Need More Coins?',
                        style: AppTypography.sectionTitle,
                      ),
                      Text(
                        'Unlock companions & soundscapes instantly',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => CoinPackPaywallSheet.show(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coinGoldDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    textStyle: AppTypography.button.copyWith(fontSize: 12),
                  ),
                  child: const Text('Get Coins'),
                ),
              ],
            ),
          ),

          // Tab Views for Items
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: ShopCategory.values.map((category) {
                final items =
                    catalog.where((item) => item.category == category).toList();
                return _buildItemList(items, userCoins);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemList(List<ShopItemModel> items, int userCoins) {
    if (items.isEmpty) {
      return const Center(
        child: Text('No items available in this category.',
            style: AppTypography.body),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final canAfford = userCoins >= item.cost;
        final themeColor = item.themeColor ?? AppColors.primary;

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: item.isEquipped
                  ? themeColor
                  : AppColors.cardBorder,
              width: item.isEquipped ? 1.8 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Item Icon / Avatar
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: item.assetPath != null
                    ? Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset(
                          item.assetPath!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(item.icon, color: themeColor, size: 28),
                        ),
                      )
                    : Icon(item.icon, color: themeColor, size: 28),
              ),
              const SizedBox(width: 14),

              // Title and description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.name,
                            style: AppTypography.sectionTitle.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (item.isEquipped) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: themeColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'EQUIPPED',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.description,
                      style: AppTypography.bodySmall.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 6),

                    // Cost or Unlocked state
                    if (!item.isUnlocked)
                      Row(
                        children: [
                          const Icon(
                            Icons.monetization_on_rounded,
                            size: 15,
                            color: AppColors.coinGold,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${item.cost} Coins',
                            style: AppTypography.badge.copyWith(
                              color: AppColors.coinGoldDark,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Icon(Icons.check_circle_rounded,
                              size: 14, color: themeColor),
                          const SizedBox(width: 4),
                          Text(
                            'Unlocked',
                            style: AppTypography.bodySmall.copyWith(
                              color: themeColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Action button
              _buildItemActionButton(item, canAfford, themeColor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItemActionButton(
    ShopItemModel item,
    bool canAfford,
    Color themeColor,
  ) {
    final shopNotifier = ref.read(shopNotifierProvider.notifier);

    if (!item.isUnlocked) {
      return ElevatedButton(
        onPressed: () async {
          if (canAfford) {
            final success = await shopNotifier.purchaseItem(item);
            if (success && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Successfully unlocked ${item.name}!'),
                  backgroundColor: AppColors.primaryDark,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          } else {
            CoinPackPaywallSheet.show(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: canAfford ? AppColors.primary : AppColors.surfaceSecondary,
          foregroundColor: canAfford ? Colors.white : AppColors.textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          canAfford ? 'Unlock' : 'Get Coins',
          style: AppTypography.button.copyWith(fontSize: 12),
        ),
      );
    }

    if (item.category == ShopCategory.characters) {
      if (item.isEquipped) {
        return OutlinedButton(
          onPressed: null,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text('Active', style: TextStyle(fontSize: 12)),
        );
      } else {
        return ElevatedButton(
          onPressed: () => shopNotifier.equipCharacter(item.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surfaceSecondary,
            foregroundColor: AppColors.textPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text('Equip', style: TextStyle(fontSize: 12)),
        );
      }
    }

    return const SizedBox.shrink();
  }
}
