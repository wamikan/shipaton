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
      name: map['name'] as String? ?? 'Other',
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
    FocusCategoryModel(id: 'math', name: 'Math & Logic', icon: '📐'),
    FocusCategoryModel(id: 'study', name: 'Study & Reading', icon: '📚'),
    FocusCategoryModel(id: 'work', name: 'Work & Code', icon: '💻'),
    FocusCategoryModel(id: 'hobby', name: 'Creative & Hobby', icon: '🎨'),
    FocusCategoryModel(id: 'exercise', name: 'Fitness & Health', icon: '🏃'),
    FocusCategoryModel(id: 'other', name: 'Other', icon: '☕'),
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
  /// Lv.1: 0 - 24 mins (Acquaintance)
  /// Lv.2: 25 - 59 mins (Good Friend)
  /// Lv.3: 60 - 119 mins (Trusted Ally)
  /// Lv.4: 120 - 239 mins (Best Companion)
  /// Lv.5: 240+ mins (Soulbound)
  factory FairyAffectionInfo.fromMinutes(String characterId, int totalMinutes) {
    if (totalMinutes >= 240) {
      return FairyAffectionInfo(
        characterId: characterId,
        totalMinutes: totalMinutes,
        level: 5,
        levelName: 'Irreplaceable',
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
        levelName: 'Dependent',
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
        levelName: 'Attached',
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
        levelName: 'Familiar',
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
        levelName: 'Curious',
        levelThreshold: 0,
        nextLevelThreshold: 25,
        progressToNext: progress.clamp(0.0, 1.0),
      );
    }
  }
}
