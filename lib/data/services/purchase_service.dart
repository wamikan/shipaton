import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../features/gamification/notifiers/coin_notifier.dart';
import '../../features/shop/models/coin_pack_model.dart';

/// Configuration key for RevenueCat.
/// Public/Test API key configured from RevenueCat dashboard.
const String kRevenueCatApiKey = 'test_rRcJQxBcsXQvDezpzkXJFWPpTir';

/// Service managing In-App Purchases (RevenueCat) for Coin Packs.
class PurchaseService {
  final Ref _ref;
  bool _isConfigured = false;

  PurchaseService(this._ref);

  /// Initializes RevenueCat SDK. Safe to call even with empty key.
  Future<void> initialize() async {
    if (kRevenueCatApiKey.isEmpty) {
      developer.log(
        'PurchaseService: No RevenueCat API key provided. Operating in sandbox mock mode.',
      );
      return;
    }

    try {
      await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.info);
      final configuration = PurchasesConfiguration(kRevenueCatApiKey);
      await Purchases.configure(configuration);
      _isConfigured = true;
      developer.log('PurchaseService: RevenueCat successfully configured.');
    } catch (e) {
      developer.log('PurchaseService: Failed to configure RevenueCat: $e');
    }
  }

  /// Purchases a consumable Coin Pack and credits coins to balance.
  Future<bool> purchaseCoinPack(CoinPackModel pack) async {
    developer.log('PurchaseService: Initiating purchase for ${pack.identifier}');

    if (_isConfigured) {
      try {
        final offerings = await Purchases.getOfferings();
        final currentOffering = offerings.current;
        if (currentOffering != null &&
            currentOffering.availablePackages.isNotEmpty) {
          var package = currentOffering.availablePackages
              .where(
                (p) =>
                    p.identifier == pack.identifier ||
                    p.storeProduct.identifier == pack.identifier,
              )
              .firstOrNull;

          // If the RevenueCat test offering only has standard packages (e.g. monthly),
          // map to an available package so the RevenueCat Test Store sheet appears!
          if (package == null && currentOffering.availablePackages.isNotEmpty) {
            const packList = CoinPackModel.defaultPacks;
            final packIndex =
                packList.indexWhere((p) => p.identifier == pack.identifier);
            final safeIndex = packIndex >= 0
                ? packIndex % currentOffering.availablePackages.length
                : 0;
            package = currentOffering.availablePackages[safeIndex];
          }

          if (package != null) {
            final purchaseResult =
                await Purchases.purchase(PurchaseParams.package(package));
            developer.log(
              'Purchase completed via Package: ${purchaseResult.customerInfo}',
            );
            await _ref.read(coinNotifierProvider.notifier).addCoins(pack.coins);
            return true;
          }
        }

        // Local StoreKit Configuration fallback: direct StoreProduct lookup
        final products = await Purchases.getProducts(
          [pack.identifier],
          productCategory: ProductCategory.nonSubscription,
        );
        if (products.isNotEmpty) {
          final purchaseResult = await Purchases.purchase(
            PurchaseParams.storeProduct(products.first),
          );
          developer.log(
            'Purchase completed via StoreProduct: ${purchaseResult.customerInfo}',
          );
          await _ref.read(coinNotifierProvider.notifier).addCoins(pack.coins);
          return true;
        } else {
          developer.log(
            'No StoreProduct found for ${pack.identifier} in StoreKit.',
          );
          return false;
        }
      } catch (e) {
        developer.log(
          'RevenueCat purchase cancelled or failed: $e',
        );
        return false;
      }
    }

    // Only reached if RevenueCat was not configured at all (mock dev mode)
    await _ref.read(coinNotifierProvider.notifier).addCoins(pack.coins);
    return true;
  }

  /// Restores previous purchases via RevenueCat.
  Future<bool> restorePurchases() async {
    if (!_isConfigured) {
      developer.log('PurchaseService: Sandbox mock mode - restore simulated.');
      return true;
    }
    try {
      final customerInfo = await Purchases.restorePurchases();
      developer.log('PurchaseService: Purchases restored successfully: $customerInfo');
      return true;
    } catch (e) {
      developer.log('PurchaseService: Failed to restore purchases: $e');
      return false;
    }
  }
}

final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  final service = PurchaseService(ref);
  service.initialize();
  return service;
});
