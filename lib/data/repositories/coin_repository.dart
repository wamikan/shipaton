import 'package:shared_preferences/shared_preferences.dart';

/// Manages persistence of the user's coin balance.
class CoinRepository {
  static const String _coinKey = 'user_coin_balance';
  final SharedPreferences _prefs;

  CoinRepository(this._prefs);

  /// Retrieves the current coin balance.
  int getCoins() {
    return _prefs.getInt(_coinKey) ?? 0;
  }

  /// Updates and persists the coin balance.
  Future<bool> setCoins(int coins) async {
    return await _prefs.setInt(_coinKey, coins);
  }

  /// Adds coins to the current balance.
  Future<int> addCoins(int amount) async {
    final current = getCoins();
    final updated = current + amount;
    await setCoins(updated);
    return updated;
  }

  /// Deducts coins if sufficient balance is available.
  Future<bool> deductCoins(int amount) async {
    final current = getCoins();
    if (current < amount) return false;
    await setCoins(current - amount);
    return true;
  }
}
