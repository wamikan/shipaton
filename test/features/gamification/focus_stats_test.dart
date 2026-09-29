import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipaton_timer/data/constants/fairy_messages_catalog.dart';
import 'package:shipaton_timer/data/models/focus_stats_model.dart';
import 'package:shipaton_timer/features/gamification/notifiers/coin_notifier.dart';
import 'package:shipaton_timer/features/gamification/notifiers/focus_stats_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FairyAffectionInfo Level Threshold Tests', () {
    test('Correct level transitions based on focus minutes', () {
      // Level 1: 0 - 24 mins
      final lv1Start = FairyAffectionInfo.fromMinutes('enhancer', 0);
      expect(lv1Start.level, 1);
      expect(lv1Start.levelName, 'Acquaintance');
      expect(lv1Start.nextLevelThreshold, 25);
      expect(lv1Start.progressToNext, 0.0);

      final lv1Mid = FairyAffectionInfo.fromMinutes('enhancer', 10);
      expect(lv1Mid.level, 1);
      expect(lv1Mid.progressToNext, closeTo(10 / 25, 0.001));

      // Level 2: 25 - 59 mins
      final lv2 = FairyAffectionInfo.fromMinutes('enhancer', 25);
      expect(lv2.level, 2);
      expect(lv2.levelName, 'Good Friend');
      expect(lv2.nextLevelThreshold, 60);

      // Level 3: 60 - 119 mins
      final lv3 = FairyAffectionInfo.fromMinutes('enhancer', 60);
      expect(lv3.level, 3);
      expect(lv3.levelName, 'Trusted Ally');
      expect(lv3.nextLevelThreshold, 120);

      // Level 4: 120 - 239 mins
      final lv4 = FairyAffectionInfo.fromMinutes('enhancer', 120);
      expect(lv4.level, 4);
      expect(lv4.levelName, 'Best Companion');
      expect(lv4.nextLevelThreshold, 240);

      // Level 5: 240+ mins
      final lv5 = FairyAffectionInfo.fromMinutes('enhancer', 240);
      expect(lv5.level, 5);
      expect(lv5.levelName, 'Soulbound');
      expect(lv5.nextLevelThreshold, isNull);
      expect(lv5.progressToNext, 1.0);
    });
  });

  group('FairyMessagesCatalog Tests', () {
    test('Messages are accessible by character and affection level', () {
      final enhancerMessages = FairyMessagesCatalog.getMessagesForCharacter('enhancer');
      final suppressantMessages = FairyMessagesCatalog.getMessagesForCharacter('suppressant');

      expect(enhancerMessages.isNotEmpty, true);
      expect(suppressantMessages.isNotEmpty, true);

      // Level 1 unlocks only Lv1 messages
      final lv1Unlocked = FairyMessagesCatalog.getUnlockedMessages('enhancer', 1);
      expect(lv1Unlocked.every((m) => m.requiredLevel <= 1), true);

      // Level 3 unlocks Lv1, Lv2, Lv3 messages
      final lv3Unlocked = FairyMessagesCatalog.getUnlockedMessages('enhancer', 3);
      expect(lv3Unlocked.length, greaterThan(lv1Unlocked.length));
      expect(lv3Unlocked.every((m) => m.requiredLevel <= 3), true);

      // Newly unlocked messages on level up
      final newOnLevelUp = FairyMessagesCatalog.getNewlyUnlockedMessages('enhancer', 1, 2);
      expect(newOnLevelUp.every((m) => m.requiredLevel == 2), true);
      expect(newOnLevelUp.isNotEmpty, true);
    });
  });

  group('FocusStatsNotifier Integration Tests', () {
    late ProviderContainer container;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();

      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state loads default categories and 0 minutes', () {
      final state = container.read(focusStatsNotifierProvider);
      expect(state.categories.length, FocusCategoryModel.defaultCategories.length);
      expect(state.activeCategoryId, 'math');
      expect(state.activeCategory.name, 'Math & Logic');
      expect(state.characterMinutes['enhancer'], 0);
      expect(state.characterMinutes['suppressant'], 0);
    });

    test('Switching category updates active category', () {
      final notifier = container.read(focusStatsNotifierProvider.notifier);
      notifier.selectCategory('hobby');

      final state = container.read(focusStatsNotifierProvider);
      expect(state.activeCategoryId, 'hobby');
      expect(state.activeCategory.name, 'Creative & Hobby');
    });

    test('Adding custom category persists and selects it', () async {
      final notifier = container.read(focusStatsNotifierProvider.notifier);
      await notifier.addCustomCategory(name: 'Language Study', icon: '📝');

      final state = container.read(focusStatsNotifierProvider);
      expect(state.categories.any((c) => c.name == 'Language Study'), true);
      expect(state.activeCategory.name, 'Language Study');
      expect(state.activeCategory.icon, '📝');
      expect(state.activeCategory.isCustom, true);
    });

    test('Recording focus session updates character minutes and category minutes', () async {
      final notifier = container.read(focusStatsNotifierProvider.notifier);

      // Record 25 minutes of focus for enhancer with active category (math)
      final reward = await notifier.recordFocusSession(
        characterId: 'enhancer',
        minutes: 25,
      );

      final state = container.read(focusStatsNotifierProvider);
      expect(state.characterMinutes['enhancer'], 25);
      expect(state.activeCategory.totalMinutes, 25);

      // Gained level from 1 to 2
      expect(reward.oldAffection.level, 1);
      expect(reward.newAffection.level, 2);
      expect(reward.didLevelUp, true);
      expect(reward.newlyUnlockedMessages.isNotEmpty, true);
      expect(reward.featuredMessage.quote.isNotEmpty, true);
    });
  });
}
