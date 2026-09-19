import 'package:shared_preferences/shared_preferences.dart';

/// Repository managing persistence of unlocked and equipped shop items.
class ShopRepository {
  static const String _unlockedItemsKey = 'shop_unlocked_items_list';
  static const String _equippedCharacterKey = 'shop_equipped_character_id';

  final SharedPreferences _prefs;

  ShopRepository(this._prefs);

  /// Retrieves list of unlocked item IDs.
  Set<String> getUnlockedItemIds() {
    final list = _prefs.getStringList(_unlockedItemsKey);
    if (list == null || list.isEmpty) {
      // Default free items
      return {'enhancer', 'rain', 'forest'};
    }
    return list.toSet();
  }

  /// Persists a newly unlocked item ID.
  Future<void> unlockItem(String id) async {
    final items = getUnlockedItemIds();
    items.add(id);
    await _prefs.setStringList(_unlockedItemsKey, items.toList());
  }

  /// Gets currently equipped character ID.
  String getEquippedCharacterId() {
    return _prefs.getString(_equippedCharacterKey) ?? 'enhancer';
  }

  /// Sets equipped character ID.
  Future<void> setEquippedCharacterId(String id) async {
    await _prefs.setString(_equippedCharacterKey, id);
  }
}
