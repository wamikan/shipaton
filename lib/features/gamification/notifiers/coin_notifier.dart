import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/repositories/coin_repository.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main()');
});

final coinRepositoryProvider = Provider<CoinRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return CoinRepository(prefs);
});

class CoinNotifier extends StateNotifier<int> {
  final CoinRepository _repository;

  CoinNotifier(this._repository) : super(_repository.getCoins());

  Future<void> addCoins(int amount) async {
    final newBalance = await _repository.addCoins(amount);
    state = newBalance;
  }

  Future<bool> deductCoins(int amount) async {
    final success = await _repository.deductCoins(amount);
    if (success) {
      state = _repository.getCoins();
    }
    return success;
  }
}

final coinNotifierProvider = StateNotifierProvider<CoinNotifier, int>((ref) {
  final repository = ref.watch(coinRepositoryProvider);
  return CoinNotifier(repository);
});
