import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';

enum CharacterTone { warm, cool }

/// Represents an unlockable imp companion.
class CharacterModel {
  final String id;
  final String name;
  final String vibeLabel;
  final String description;
  final CharacterTone tone;
  final String assetPath;
  final Color primaryColor;
  final Color backgroundColor;
  final Color borderColor;
  final int unlockCost;
  final bool isUnlocked;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.vibeLabel,
    required this.description,
    required this.tone,
    required this.assetPath,
    required this.primaryColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.unlockCost,
    this.isUnlocked = false,
  });

  CharacterModel copyWith({
    String? id,
    String? name,
    String? vibeLabel,
    String? description,
    CharacterTone? tone,
    String? assetPath,
    Color? primaryColor,
    Color? backgroundColor,
    Color? borderColor,
    int? unlockCost,
    bool? isUnlocked,
  }) {
    return CharacterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      vibeLabel: vibeLabel ?? this.vibeLabel,
      description: description ?? this.description,
      tone: tone ?? this.tone,
      assetPath: assetPath ?? this.assetPath,
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      unlockCost: unlockCost ?? this.unlockCost,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  /// Initial default character roster
  static const CharacterModel enhancer = CharacterModel(
    id: 'enhancer',
    name: 'Appetite Enhancer',
    vibeLabel: 'Warm & Cheerful Imp',
    description: 'A lively, warm-hearted imp who fills your study sessions with radiant energy.',
    tone: CharacterTone.warm,
    assetPath: AppAssets.characterEnhancer,
    primaryColor: AppColors.enhancerPrimary,
    backgroundColor: AppColors.enhancerBg,
    borderColor: AppColors.enhancerBorder,
    unlockCost: 0,
    isUnlocked: true,
  );

  static const CharacterModel suppressant = CharacterModel(
    id: 'suppressant',
    name: 'Appetite Suppressant',
    vibeLabel: 'Cool & Calm Imp',
    description: 'A serene, composed young imp who brings deep focus and chilly tranquility.',
    tone: CharacterTone.cool,
    assetPath: AppAssets.characterSuppressant,
    primaryColor: AppColors.suppressantPrimary,
    backgroundColor: AppColors.suppressantBg,
    borderColor: AppColors.suppressantBorder,
    unlockCost: 300,
    isUnlocked: false,
  );

  static List<CharacterModel> get defaultRoster => [enhancer, suppressant];
}
