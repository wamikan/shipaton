import 'package:flutter/material.dart';

enum ShopCategory {
  characters(title: 'Characters'),
  ambientBgm(title: 'Soundscapes'),
  accessories(title: 'Accessories');

  final String title;
  const ShopCategory({required this.title});
}

/// Represents an unlockable item inside the In-App Shop.
class ShopItemModel {
  final String id;
  final String name;
  final String description;
  final ShopCategory category;
  final int cost;
  final bool isUnlocked;
  final bool isEquipped;
  final IconData icon;
  final String? assetPath;
  final Color? themeColor;

  const ShopItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.cost,
    this.isUnlocked = false,
    this.isEquipped = false,
    required this.icon,
    this.assetPath,
    this.themeColor,
  });

  ShopItemModel copyWith({
    String? id,
    String? name,
    String? description,
    ShopCategory? category,
    int? cost,
    bool? isUnlocked,
    bool? isEquipped,
    IconData? icon,
    String? assetPath,
    Color? themeColor,
  }) {
    return ShopItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      cost: cost ?? this.cost,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isEquipped: isEquipped ?? this.isEquipped,
      icon: icon ?? this.icon,
      assetPath: assetPath ?? this.assetPath,
      themeColor: themeColor ?? this.themeColor,
    );
  }

  static List<ShopItemModel> get initialCatalog => [
        // Characters
        const ShopItemModel(
          id: 'enhancer',
          name: 'Appetite Enhancer',
          description: 'Warm & Cheerful Imp who brings vibrant encouragement to every session.',
          category: ShopCategory.characters,
          cost: 0,
          isUnlocked: true,
          isEquipped: true,
          icon: Icons.auto_awesome_rounded,
          themeColor: Color(0xFFFF715B),
        ),
        const ShopItemModel(
          id: 'suppressant',
          name: 'Appetite Suppressant',
          description: 'Cool & Calm Imp who brings icy stillness and uninterrupted focus.',
          category: ShopCategory.characters,
          cost: 300,
          isUnlocked: false,
          isEquipped: false,
          icon: Icons.ac_unit_rounded,
          themeColor: Color(0xFF3A98D3),
        ),

        // Soundscapes
        const ShopItemModel(
          id: 'rain',
          name: 'Nordic Rain',
          description: 'Gentle raindrops falling softly on pine needles.',
          category: ShopCategory.ambientBgm,
          cost: 0,
          isUnlocked: true,
          isEquipped: true,
          icon: Icons.water_drop_rounded,
        ),
        const ShopItemModel(
          id: 'forest',
          name: 'Pine Forest',
          description: 'Quiet morning breeze rustling through tall Nordic evergreens.',
          category: ShopCategory.ambientBgm,
          cost: 0,
          isUnlocked: true,
          isEquipped: false,
          icon: Icons.forest_rounded,
        ),
        const ShopItemModel(
          id: 'river',
          name: 'Glacier Stream',
          description: 'Arctic mountain spring flowing crystal clear over stones.',
          category: ShopCategory.ambientBgm,
          cost: 150,
          isUnlocked: false,
          isEquipped: false,
          icon: Icons.waves_rounded,
        ),
        const ShopItemModel(
          id: 'white_noise',
          name: 'Cosy Hearth',
          description: 'Deep crackling frequency designed to block distractions.',
          category: ShopCategory.ambientBgm,
          cost: 200,
          isUnlocked: false,
          isEquipped: false,
          icon: Icons.air_rounded,
        ),

        // Accessories / Outfits
        const ShopItemModel(
          id: 'nordic_scarf',
          name: 'Nordic Wool Scarf',
          description: 'Hand-knitted warm crimson scarf for your imp companion.',
          category: ShopCategory.accessories,
          cost: 100,
          isUnlocked: false,
          isEquipped: false,
          icon: Icons.dry_cleaning_rounded,
        ),
        const ShopItemModel(
          id: 'aurora_crown',
          name: 'Glacial Aurora Crown',
          description: 'Shimmering tiara infused with northern lights glow.',
          category: ShopCategory.accessories,
          cost: 250,
          isUnlocked: false,
          isEquipped: false,
          icon: Icons.military_tech_rounded,
        ),
      ];
}
