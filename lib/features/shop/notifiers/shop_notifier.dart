import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/character_model.dart';
import '../../../data/models/shop_item_model.dart';
import '../../../data/repositories/shop_repository.dart';
import '../../../data/services/audio_service.dart';
import '../../gamification/notifiers/coin_notifier.dart';
import '../../timer/notifiers/timer_notifier.dart';

final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ShopRepository(prefs);
});

class ShopNotifier extends StateNotifier<List<ShopItemModel>> {
  final Ref _ref;
  final ShopRepository _repository;

  ShopNotifier(this._ref, this._repository) : super([]) {
    _loadCatalog();
  }

  void _loadCatalog() {
    final unlockedIds = _repository.getUnlockedItemIds();
    final equippedCharId = _repository.getEquippedCharacterId();

    state = ShopItemModel.initialCatalog.map((item) {
      final isUnlocked = unlockedIds.contains(item.id);
      final isEquipped = item.category == ShopCategory.characters &&
          item.id == equippedCharId;
      return item.copyWith(
        isUnlocked: isUnlocked,
        isEquipped: isEquipped,
      );
    }).toList();
  }

  /// Unlocks an item using coins.
  Future<bool> purchaseItem(ShopItemModel item) async {
    if (item.isUnlocked) return true;

    final currentCoins = _ref.read(coinNotifierProvider);
    if (currentCoins < item.cost) {
      return false;
    }

    final deducted =
        await _ref.read(coinNotifierProvider.notifier).deductCoins(item.cost);
    if (!deducted) return false;

    // Save unlocked status
    await _repository.unlockItem(item.id);

    // If character, auto-equip
    if (item.category == ShopCategory.characters) {
      await equipCharacter(item.id);
    }

    // Play chime feedback
    _ref.read(audioNotifierProvider.notifier).playCoinChime();

    _loadCatalog();
    return true;
  }

  /// Equips an unlocked character.
  Future<void> equipCharacter(String characterId) async {
    await _repository.setEquippedCharacterId(characterId);

    final character = characterId == 'suppressant'
        ? CharacterModel.suppressant
        : CharacterModel.enhancer;

    _ref.read(timerNotifierProvider.notifier).selectCharacter(character);
    _loadCatalog();
  }
}

final shopNotifierProvider =
    StateNotifierProvider<ShopNotifier, List<ShopItemModel>>((ref) {
  final repository = ref.watch(shopRepositoryProvider);
  return ShopNotifier(ref, repository);
});
