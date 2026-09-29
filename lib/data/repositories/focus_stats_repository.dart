import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/focus_stats_model.dart';

/// Repository managing persistence of focus time per character and per category.
class FocusStatsRepository {
  static const String _keyCategories = 'focus_categories_list';
  static const String _keyActiveCategory = 'focus_active_category_id';
  static const String _keyPrefixCharMinutes = 'character_focus_minutes_';

  final SharedPreferences _prefs;

  FocusStatsRepository(this._prefs);

  /// Loads categories list or returns default categories.
  List<FocusCategoryModel> loadCategories() {
    final raw = _prefs.getString(_keyCategories);
    if (raw == null || raw.isEmpty) {
      return FocusCategoryModel.defaultCategories;
    }
    try {
      final decoded = json.decode(raw) as List<dynamic>;
      return decoded
          .map((item) => FocusCategoryModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return FocusCategoryModel.defaultCategories;
    }
  }

  /// Saves categories list to SharedPreferences.
  Future<void> saveCategories(List<FocusCategoryModel> categories) async {
    final jsonString = json.encode(categories.map((c) => c.toMap()).toList());
    await _prefs.setString(_keyCategories, jsonString);
  }

  /// Loads the active selected category ID.
  String loadActiveCategoryId() {
    return _prefs.getString(_keyActiveCategory) ?? 'math';
  }

  /// Saves the active category ID.
  Future<void> saveActiveCategoryId(String id) async {
    await _prefs.setString(_keyActiveCategory, id);
  }

  /// Loads total focus minutes accumulated with a specific character.
  int loadCharacterMinutes(String characterId) {
    return _prefs.getInt('$_keyPrefixCharMinutes$characterId') ?? 0;
  }

  /// Saves total focus minutes for a character.
  Future<void> saveCharacterMinutes(String characterId, int minutes) async {
    await _prefs.setInt('$_keyPrefixCharMinutes$characterId', minutes);
  }
}
