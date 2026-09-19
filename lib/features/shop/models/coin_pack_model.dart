import 'package:flutter/material.dart';

/// Represents a consumable In-App Purchase Coin Pack via RevenueCat.
class CoinPackModel {
  final String identifier;
  final String title;
  final int coins;
  final String priceString;
  final String description;
  final bool isPopular;
  final IconData icon;

  const CoinPackModel({
    required this.identifier,
    required this.title,
    required this.coins,
    required this.priceString,
    required this.description,
    this.isPopular = false,
    required this.icon,
  });

  static const List<CoinPackModel> defaultPacks = [
    CoinPackModel(
      identifier: 'coin_pack_100',
      title: 'Handful of Coins',
      coins: 100,
      priceString: '\$0.99',
      description: 'Quick boost for unlocking premium BGM soundscapes',
      icon: Icons.monetization_on_outlined,
    ),
    CoinPackModel(
      identifier: 'coin_pack_500',
      title: 'Pouch of Coins',
      coins: 500,
      priceString: '\$3.99',
      description: 'Unlock Appetite Suppressant (300 Coins) and ambient tracks',
      isPopular: true,
      icon: Icons.savings_outlined,
    ),
    CoinPackModel(
      identifier: 'coin_pack_1200',
      title: 'Chest of Coins',
      coins: 1200,
      priceString: '\$7.99',
      description: 'Best Value! Unlock all characters, outfits, and future BGM',
      icon: Icons.diamond_outlined,
    ),
  ];
}
