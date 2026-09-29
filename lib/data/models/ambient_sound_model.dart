import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';

/// Metadata for ambient background soundscapes.
class AmbientSoundModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final String assetPath;
  final bool isUnlocked;
  final int unlockCost;

  const AmbientSoundModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.assetPath,
    required this.isUnlocked,
    required this.unlockCost,
  });

  AmbientSoundModel copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    String? assetPath,
    bool? isUnlocked,
    int? unlockCost,
  }) {
    return AmbientSoundModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      assetPath: assetPath ?? this.assetPath,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockCost: unlockCost ?? this.unlockCost,
    );
  }

  static const List<AmbientSoundModel> defaultSoundscapes = [
    AmbientSoundModel(
      id: 'rain',
      title: 'Nordic Rain & Piano',
      description: 'Soft raindrops paired with warm lo-fi focus piano chords',
      icon: Icons.water_drop_rounded,
      assetPath: AppAssets.ambientRain,
      isUnlocked: true,
      unlockCost: 0,
    ),
    AmbientSoundModel(
      id: 'forest',
      title: 'Pine Forest & Bells',
      description: 'Gentle breeze through Nordic trees with crystal bells',
      icon: Icons.forest_rounded,
      assetPath: AppAssets.ambientForest,
      isUnlocked: true,
      unlockCost: 0,
    ),
    AmbientSoundModel(
      id: 'rain_nature',
      title: 'Rain & Nature',
      description: 'Gentle forest rain harmonized with ambient woodland nature',
      icon: Icons.grain_rounded,
      assetPath: AppAssets.ambientRainNature,
      isUnlocked: false,
      unlockCost: 150,
    ),
    AmbientSoundModel(
      id: 'positive',
      title: 'Positive Flow',
      description: 'Uplifting acoustic harmonies to boost positivity and energy',
      icon: Icons.auto_awesome_rounded,
      assetPath: AppAssets.ambientPositive,
      isUnlocked: false,
      unlockCost: 200,
    ),
    AmbientSoundModel(
      id: 'none',
      title: 'Silent Calm',
      description: 'Pure silence without background music',
      icon: Icons.volume_off_rounded,
      assetPath: '',
      isUnlocked: true,
      unlockCost: 0,
    ),
  ];
}
