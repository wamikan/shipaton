import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/constants/fairy_messages_catalog.dart';
import '../../../data/models/focus_stats_model.dart';
import '../../../data/repositories/focus_stats_repository.dart';
import 'coin_notifier.dart';

/// Summary reward generated after completing a focus session.
class SessionCompletionReward {
  final String characterId;
  final String categoryName;
  final int minutesGained;
  final FairyAffectionInfo oldAffection;
  final FairyAffectionInfo newAffection;
  final bool didLevelUp;
  final List<FairyMessageModel> newlyUnlockedMessages;
  final FairyMessageModel featuredMessage;

  const SessionCompletionReward({
    required this.characterId,
    required this.categoryName,
    required this.minutesGained,
    required this.oldAffection,
    required this.newAffection,
    required this.didLevelUp,
    required this.newlyUnlockedMessages,
    required this.featuredMessage,
  });
}

/// Immutable state holding focus categories and character progress.
class FocusStatsState {
  final List<FocusCategoryModel> categories;
  final String activeCategoryId;
  final Map<String, int> characterMinutes;
  final SessionCompletionReward? lastReward;

  const FocusStatsState({
    required this.categories,
    required this.activeCategoryId,
    required this.characterMinutes,
    this.lastReward,
  });

  FocusCategoryModel get activeCategory {
    return categories.firstWhere(
      (c) => c.id == activeCategoryId,
      orElse: () => categories.first,
    );
  }

  FairyAffectionInfo getAffection(String characterId) {
    final minutes = characterMinutes[characterId] ?? 0;
    return FairyAffectionInfo.fromMinutes(characterId, minutes);
  }

  FocusStatsState copyWith({
    List<FocusCategoryModel>? categories,
    String? activeCategoryId,
    Map<String, int>? characterMinutes,
    SessionCompletionReward? lastReward,
    bool clearReward = false,
  }) {
    return FocusStatsState(
      categories: categories ?? this.categories,
      activeCategoryId: activeCategoryId ?? this.activeCategoryId,
      characterMinutes: characterMinutes ?? this.characterMinutes,
      lastReward: clearReward ? null : (lastReward ?? this.lastReward),
    );
  }
}

/// Notifier managing category selection, custom categories, and fairy affection minutes.
class FocusStatsNotifier extends StateNotifier<FocusStatsState> {
  final FocusStatsRepository _repository;

  FocusStatsNotifier(this._repository)
      : super(
          FocusStatsState(
            categories: _repository.loadCategories(),
            activeCategoryId: _repository.loadActiveCategoryId(),
            characterMinutes: {
              'enhancer': _repository.loadCharacterMinutes('enhancer'),
              'suppressant': _repository.loadCharacterMinutes('suppressant'),
            },
          ),
        );

  /// Selects the active working category.
  void selectCategory(String categoryId) {
    if (state.categories.any((c) => c.id == categoryId)) {
      state = state.copyWith(activeCategoryId: categoryId);
      _repository.saveActiveCategoryId(categoryId);
    }
  }

  /// Adds a new user-defined custom category.
  Future<void> addCustomCategory({
    required String name,
    String icon = '✨',
  }) async {
    final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    final newCategory = FocusCategoryModel(
      id: id,
      name: name.trim().isEmpty ? 'カスタム作業' : name.trim(),
      icon: icon.trim().isEmpty ? '✨' : icon.trim(),
      totalMinutes: 0,
      isCustom: true,
    );

    final updated = [...state.categories, newCategory];
    state = state.copyWith(categories: updated, activeCategoryId: id);
    await _repository.saveCategories(updated);
    await _repository.saveActiveCategoryId(id);
  }

  /// Records a completed focus session, distributing minutes to the selected fairy and category.
  Future<SessionCompletionReward> recordFocusSession({
    required String characterId,
    required int minutes,
  }) async {
    // 1. Update character minutes & affection
    final currentMinutes = state.characterMinutes[characterId] ?? 0;
    final updatedCharMinutes = currentMinutes + minutes;

    final oldAffection = FairyAffectionInfo.fromMinutes(characterId, currentMinutes);
    final newAffection = FairyAffectionInfo.fromMinutes(characterId, updatedCharMinutes);
    final didLevelUp = newAffection.level > oldAffection.level;

    // Check newly unlocked messages
    final newlyUnlocked = FairyMessagesCatalog.getNewlyUnlockedMessages(
      characterId,
      oldAffection.level,
      newAffection.level,
    );

    // Pick featured quote
    final availableMessages = FairyMessagesCatalog.getUnlockedMessages(
      characterId,
      newAffection.level,
    );
    final featured = newlyUnlocked.isNotEmpty
        ? newlyUnlocked.first
        : (availableMessages.isNotEmpty
            ? availableMessages[Random().nextInt(availableMessages.length)]
            : FairyMessagesCatalog.allMessages.first);

    // 2. Update category minutes
    final category = state.activeCategory;
    final updatedCategories = state.categories.map((c) {
      if (c.id == category.id) {
        return c.copyWith(totalMinutes: c.totalMinutes + minutes);
      }
      return c;
    }).toList();

    // 3. Persist
    final updatedCharMap = Map<String, int>.from(state.characterMinutes);
    updatedCharMap[characterId] = updatedCharMinutes;

    final reward = SessionCompletionReward(
      characterId: characterId,
      categoryName: category.name,
      minutesGained: minutes,
      oldAffection: oldAffection,
      newAffection: newAffection,
      didLevelUp: didLevelUp,
      newlyUnlockedMessages: newlyUnlocked,
      featuredMessage: featured,
    );

    state = state.copyWith(
      categories: updatedCategories,
      characterMinutes: updatedCharMap,
      lastReward: reward,
    );

    await _repository.saveCharacterMinutes(characterId, updatedCharMinutes);
    await _repository.saveCategories(updatedCategories);

    return reward;
  }

  void clearLastReward() {
    state = state.copyWith(clearReward: true);
  }
}

final focusStatsRepositoryProvider = Provider<FocusStatsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FocusStatsRepository(prefs);
});

final focusStatsNotifierProvider =
    StateNotifierProvider<FocusStatsNotifier, FocusStatsState>((ref) {
  final repo = ref.watch(focusStatsRepositoryProvider);
  return FocusStatsNotifier(repo);
});
