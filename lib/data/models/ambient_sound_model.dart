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
      id: 'none',
      title: 'Silent Calm',
      description: 'Peaceful pure silence without soundscapes',
      icon: Icons.volume_off_rounded,
      assetPath: '',
      isUnlocked: true,
      unlockCost: 0,
    ),
    AmbientSoundModel(
      id: 'rain',
      title: 'Nordic Rain',
      description: 'Soft raindrops falling gently on pine needles',
      icon: Icons.water_drop_rounded,
      assetPath: AppAssets.ambientRain,
      isUnlocked: true,
      unlockCost: 0,
    ),
    AmbientSoundModel(
      id: 'forest',
      title: 'Pine Forest',
      description: 'Gentle morning wind through Nordic trees',
      icon: Icons.forest_rounded,
      assetPath: AppAssets.ambientForest,
      isUnlocked: true,
      unlockCost: 0,
    ),
    AmbientSoundModel(
      id: 'river',
      title: 'Glacier Stream',
      description: 'Clear arctic mountain water flowing over stones',
      icon: Icons.waves_rounded,
      assetPath: AppAssets.ambientRiver,
      isUnlocked: false,
      unlockCost: 150,
    ),
    AmbientSoundModel(
      id: 'white_noise',
      title: 'Cosy Hearth',
      description: 'Deep soothing frequency for intense concentration',
      icon: Icons.air_rounded,
      assetPath: AppAssets.ambientWhiteNoise,
      isUnlocked: false,
      unlockCost: 200,
    ),
  ];
}
