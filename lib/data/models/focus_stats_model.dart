import 'dart:convert';

/// Represents a study/work activity category.
class FocusCategoryModel {
  final String id;
  final String name;
  final String icon;
  final int totalMinutes;
  final bool isCustom;

  const FocusCategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    this.totalMinutes = 0,
    this.isCustom = false,
  });

  FocusCategoryModel copyWith({
    String? id,
    String? name,
    String? icon,
    int? totalMinutes,
    bool? isCustom,
  }) {
    return FocusCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'totalMinutes': totalMinutes,
      'isCustom': isCustom,
    };
  }

  factory FocusCategoryModel.fromMap(Map<String, dynamic> map) {
    return FocusCategoryModel(
      id: map['id'] as String? ?? 'other',
      name: map['name'] as String? ?? 'その他',
      icon: map['icon'] as String? ?? '✨',
      totalMinutes: (map['totalMinutes'] as num?)?.toInt() ?? 0,
      isCustom: map['isCustom'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());
  factory FocusCategoryModel.fromJson(String source) =>
      FocusCategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Default categories available on fresh install
  static const List<FocusCategoryModel> defaultCategories = [
    FocusCategoryModel(id: 'math', name: '数学・理数', icon: '📐'),
    FocusCategoryModel(id: 'study', name: '勉強・読書', icon: '📚'),
    FocusCategoryModel(id: 'work', name: '仕事・開発', icon: '💻'),
    FocusCategoryModel(id: 'hobby', name: '趣味・創作', icon: '🎨'),
    FocusCategoryModel(id: 'exercise', name: '運動・健康', icon: '🏃'),
    FocusCategoryModel(id: 'other', name: 'その他', icon: '☕'),
  ];
}

/// Represents an unlockable voice/quote message from a fairy companion.
class FairyMessageModel {
  final String id;
  final String characterId; // 'enhancer' or 'suppressant'
  final int requiredLevel; // 1 to 5
  final String title;
  final String quote;
  final String description;

  const FairyMessageModel({
    required this.id,
    required this.characterId,
    required this.requiredLevel,
    required this.title,
    required this.quote,
    required this.description,
  });
}

/// Affection progression for a character companion based on focus minutes.
class FairyAffectionInfo {
  final String characterId;
  final int totalMinutes;
  final int level;
  final String levelName;
  final int levelThreshold;
  final int? nextLevelThreshold;
  final double progressToNext;

  const FairyAffectionInfo({
    required this.characterId,
    required this.totalMinutes,
    required this.level,
    required this.levelName,
    required this.levelThreshold,
    this.nextLevelThreshold,
    required this.progressToNext,
  });

  /// Calculates affection level (Lv.1 to Lv.5) from total focus minutes.
  /// Lv.1: 0 - 24 mins (出会い)
  /// Lv.2: 25 - 59 mins (仲良し - 1ポモドーロ)
  /// Lv.3: 60 - 119 mins (信頼 - 1時間)
  /// Lv.4: 120 - 239 mins (大親友 - 2時間)
  /// Lv.5: 240+ mins (魂の絆 - 4時間)
  factory FairyAffectionInfo.fromMinutes(String characterId, int totalMinutes) {
    if (totalMinutes >= 240) {
      return FairyAffectionInfo(
        characterId: characterId,
        totalMinutes: totalMinutes,
        level: 5,
        levelName: '魂の絆',
        levelThreshold: 240,
        nextLevelThreshold: null,
        progressToNext: 1.0,
      );
    } else if (totalMinutes >= 120) {
      final progress = (totalMinutes - 120) / (240 - 120);
      return FairyAffectionInfo(
        characterId: characterId,
        totalMinutes: totalMinutes,
        level: 4,
        levelName: '大親友',
        levelThreshold: 120,
        nextLevelThreshold: 240,
        progressToNext: progress.clamp(0.0, 1.0),
      );
    } else if (totalMinutes >= 60) {
      final progress = (totalMinutes - 60) / (120 - 60);
      return FairyAffectionInfo(
        characterId: characterId,
        totalMinutes: totalMinutes,
        level: 3,
        levelName: '深い信頼',
        levelThreshold: 60,
        nextLevelThreshold: 120,
        progressToNext: progress.clamp(0.0, 1.0),
      );
    } else if (totalMinutes >= 25) {
      final progress = (totalMinutes - 25) / (60 - 25);
      return FairyAffectionInfo(
        characterId: characterId,
        totalMinutes: totalMinutes,
        level: 2,
        levelName: '仲良し',
        levelThreshold: 25,
        nextLevelThreshold: 60,
        progressToNext: progress.clamp(0.0, 1.0),
      );
    } else {
      final progress = totalMinutes / 25;
      return FairyAffectionInfo(
        characterId: characterId,
        totalMinutes: totalMinutes,
        level: 1,
        levelName: 'はじめまして',
        levelThreshold: 0,
        nextLevelThreshold: 25,
        progressToNext: progress.clamp(0.0, 1.0),
      );
    }
  }
}
