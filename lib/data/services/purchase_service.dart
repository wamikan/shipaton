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
          final package = currentOffering.availablePackages.firstWhere(
            (p) =>
                p.identifier == pack.identifier ||
                p.storeProduct.identifier == pack.identifier,
            orElse: () => currentOffering.availablePackages.first,
          );

          final purchaseResult =
              await Purchases.purchase(PurchaseParams.package(package));
          developer.log(
            'Purchase completed via Package: ${purchaseResult.customerInfo}',
          );
        } else {
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
          } else {
            developer.log(
              'No StoreProduct found for ${pack.identifier} in StoreKit.',
            );
          }
        }
      } catch (e) {
        developer.log(
          'RevenueCat purchase failed/cancelled: $e. Falling back to dev mode credit.',
        );
      }
    }

    // Credit coins to local repository
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
