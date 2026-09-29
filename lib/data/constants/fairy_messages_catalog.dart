import '../models/focus_stats_model.dart';

/// Central catalog of dialogue quotes and motivational messages from fairy companions.
/// Easily add new messages here at any time to expand the compendium!
class FairyMessagesCatalog {
  /// Master list of all messages across all fairy companions.
  static const List<FairyMessageModel> allMessages = [
    // ==========================================
    // 🍓 Appetite Enhancer
    // ==========================================

    // --- Level 1: Acquaintance (0 - 24 mins) ---
    FairyMessageModel(
      id: 'enhancer_lv1_1',
      characterId: 'enhancer',
      requiredLevel: 1,
      title: 'Nice to Meet You!',
      quote: "Hey there! Let's eat lots of good treats and enjoy a super focused day together!",
      description: 'First meeting with Appetite Enhancer',
    ),
    FairyMessageModel(
      id: 'enhancer_lv1_2',
      characterId: 'enhancer',
      requiredLevel: 1,
      title: 'Ready, Set, Focus!',
      quote: "Timer is running and we're good to go! I'll be right here cheering for you!",
      description: 'Encouragement for your focus session',
    ),

    // --- Level 2: Good Friend (25 - 59 mins) ---
    FairyMessageModel(
      id: 'enhancer_lv2_1',
      characterId: 'enhancer',
      requiredLevel: 2,
      title: 'Feast Time!',
      quote: 'Amazing job! Meals after deep focus taste a hundred times better, don’t you think?',
      description: 'Unlocked at 25 mins of total focus',
    ),
    FairyMessageModel(
      id: 'enhancer_lv2_2',
      characterId: 'enhancer',
      requiredLevel: 2,
      title: 'Energy Boost',
      quote: "Take a deep breath and have a little snack! We've got plenty of energy left for more!",
      description: 'Unlocked at 25 mins of total focus',
    ),

    // --- Level 3: Trusted Ally (60 - 119 mins) ---
    FairyMessageModel(
      id: 'enhancer_lv3_1',
      characterId: 'enhancer',
      requiredLevel: 3,
      title: 'Secret Treat',
      quote: "Hehe, honestly working together with you has become the highlight of my day. Here's a special pastry for you!",
      description: 'Unlocked at 1 hour (60 mins) of total focus',
    ),
    FairyMessageModel(
      id: 'enhancer_lv3_2',
      characterId: 'enhancer',
      requiredLevel: 3,
      title: 'In Perfect Sync!',
      quote: 'When you slip into the zone, my slime glows and sparkles with excitement!',
      description: 'Unlocked at 1 hour (60 mins) of total focus',
    ),

    // --- Level 4: Best Companion (120 - 239 mins) ---
    FairyMessageModel(
      id: 'enhancer_lv4_1',
      characterId: 'enhancer',
      requiredLevel: 4,
      title: 'Best Partner',
      quote: 'No matter how tough the challenge is, I know we can conquer anything together!',
      description: 'Unlocked at 2 hours (120 mins) of total focus',
    ),
    FairyMessageModel(
      id: 'enhancer_lv4_2',
      characterId: 'enhancer',
      requiredLevel: 4,
      title: 'Full of Joy',
      quote: 'Your hard work is truly paying off. Both my tummy and heart are filled with pure happiness!',
      description: 'Unlocked at 2 hours (120 mins) of total focus',
    ),

    // --- Level 5: Soulbound (240+ mins) ---
    FairyMessageModel(
      id: 'enhancer_lv5_1',
      characterId: 'enhancer',
      requiredLevel: 5,
      title: 'Soulbound Beacon',
      quote: 'Every single minute we spent in focus is brighter than all the feasts in the world. I am with you always!',
      description: 'Unlocked at 4 hours (240 mins) of total focus',
    ),

    // ==========================================
    // 💧 Appetite Suppressant
    // ==========================================

    // --- Level 1: Acquaintance (0 - 24 mins) ---
    FairyMessageModel(
      id: 'suppressant_lv1_1',
      characterId: 'suppressant',
      requiredLevel: 1,
      title: 'Vow of Stillness',
      quote: 'Breathe in deeply and calm your mind like a tranquil lake. I will guard your focus.',
      description: 'First quiet moment with Appetite Suppressant',
    ),
    FairyMessageModel(
      id: 'suppressant_lv1_2',
      characterId: 'suppressant',
      requiredLevel: 1,
      title: 'Let Desires Fade',
      quote: 'With every restless craving you let go, your thoughts grow clearer and sharper.',
      description: 'An invitation to tranquil focus',
    ),

    // --- Level 2: Good Friend (25 - 59 mins) ---
    FairyMessageModel(
      id: 'suppressant_lv2_1',
      characterId: 'suppressant',
      requiredLevel: 2,
      title: 'Like Crystal Water',
      quote: 'Wonderful session. The quiet world where distractions fade is truly serene, is it not?',
      description: 'Unlocked at 25 mins of total focus',
    ),
    FairyMessageModel(
      id: 'suppressant_lv2_2',
      characterId: 'suppressant',
      requiredLevel: 2,
      title: 'A Nourishing Droplet',
      quote: 'No need to rush. Like gentle rain quenching the soil drop by drop, we move steadily forward.',
      description: 'Unlocked at 25 mins of total focus',
    ),

    // --- Level 3: Trusted Ally (60 - 119 mins) ---
    FairyMessageModel(
      id: 'suppressant_lv3_1',
      characterId: 'suppressant',
      requiredLevel: 3,
      title: 'Quiet Resonance',
      quote: 'Your calm determination reaches me. Even the waters of my mantle glow with a pure light.',
      description: 'Unlocked at 1 hour (60 mins) of total focus',
    ),
    FairyMessageModel(
      id: 'suppressant_lv3_2',
      characterId: 'suppressant',
      requiredLevel: 3,
      title: 'Beyond the Ripples',
      quote: 'Just as a single raindrop creates wide ripples on the lake, your efforts reach far beyond today.',
      description: 'Unlocked at 1 hour (60 mins) of total focus',
    ),

    // --- Level 4: Best Companion (120 - 239 mins) ---
    FairyMessageModel(
      id: 'suppressant_lv4_1',
      characterId: 'suppressant',
      requiredLevel: 4,
      title: 'Unshakable Focus',
      quote: 'Even in a fierce storm, the deep waters remain calm. Your mind has reached that same peaceful depths.',
      description: 'Unlocked at 2 hours (120 mins) of total focus',
    ),
    FairyMessageModel(
      id: 'suppressant_lv4_2',
      characterId: 'suppressant',
      requiredLevel: 4,
      title: 'Silent Trust',
      quote: 'Without needing any words, I can feel how sharp and centered you are right now.',
      description: 'Unlocked at 2 hours (120 mins) of total focus',
    ),

    // --- Level 5: Soulbound (240+ mins) ---
    FairyMessageModel(
      id: 'suppressant_lv5_1',
      characterId: 'suppressant',
      requiredLevel: 5,
      title: 'Serene Spring of Eternity',
      quote: 'The path we have walked together flows like a pristine mountain spring. May this quiet pride remain with you forever.',
      description: 'Unlocked at 4 hours (240 mins) of total focus',
    ),
  ];

  /// Gets all messages for a specific character.
  static List<FairyMessageModel> getMessagesForCharacter(String characterId) {
    return allMessages.where((m) => m.characterId == characterId).toList();
  }

  /// Gets currently unlocked messages for a character based on affection level.
  static List<FairyMessageModel> getUnlockedMessages(
    String characterId,
    int currentLevel,
  ) {
    return allMessages
        .where((m) => m.characterId == characterId && m.requiredLevel <= currentLevel)
        .toList();
  }

  /// Gets newly unlocked messages when leveling up.
  static List<FairyMessageModel> getNewlyUnlockedMessages(
    String characterId,
    int oldLevel,
    int newLevel,
  ) {
    if (newLevel <= oldLevel) return [];
    return allMessages
        .where(
          (m) =>
              m.characterId == characterId &&
              m.requiredLevel > oldLevel &&
              m.requiredLevel <= newLevel,
        )
        .toList();
  }
}
