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
      title: 'Curious',
      quote: "Oh! You're here! You look... delicious. ...Ah, don't worry. I won't eat you!",
      description: 'First meeting with Appetite Enhancer',
    ),
    FairyMessageModel(
      id: 'enhancer_lv1_2',
      characterId: 'enhancer',
      requiredLevel: 1,
      title: 'A Little Snack',
      quote: "I'll sit here while you work. Don't mind me. I'm just going to eat this.",
      description: 'Encouragement for your focus session',
    ),

    // --- Level 2: Good Friend (25 - 59 mins) ---
    FairyMessageModel(
      id: 'enhancer_lv2_1',
      characterId: 'enhancer',
      requiredLevel: 2,
      title: 'Feast Time!',
      quote: "You're back! I was starting to wonder when you'd come again.",
      description: 'Unlocked at 25 mins of total focus',
    ),
    FairyMessageModel(
      id: 'enhancer_lv2_2',
      characterId: 'enhancer',
      requiredLevel: 2,
      title: 'My Favorite Snack',
      quote: "I tried a new snack today! But somehow, eating it beside you makes it taste better.",
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
      title: 'Attached',
      quote: 'Are you finished already? ...Could you stay just a little longer?',
      description: 'Unlocked at 1 hour (60 mins) of total focus',
    ),

    // --- Level 4: Best Companion (120 - 239 mins) ---
    FairyMessageModel(
      id: 'enhancer_lv4_1',
      characterId: 'enhancer',
      requiredLevel: 4,
      title: 'Dependent',
      quote: "I used to enjoy eating by myself. But now... it feels strangely quiet when you're gone.",
      description: 'Unlocked at 2 hours (120 mins) of total focus',
    ),
    FairyMessageModel(
      id: 'enhancer_lv4_2',
      characterId: 'enhancer',
      requiredLevel: 4,
      title: 'Just One More Session',
      quote: "One more session? Please? I'll even share my snacks with you.",
      description: 'Unlocked at 2 hours (120 mins) of total focus',
    ),

    // --- Level 5: Soulbound (240+ mins) ---
    FairyMessageModel(
      id: 'enhancer_lv5_1',
      characterId: 'enhancer',
      requiredLevel: 5,
      title: '???',
      quote: 'Sometimes I wonder... If I wrapped you in my slime, would you stay with me forever? Hehe... just kidding. Probably.',
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
      title: 'A Quiet Visitor',
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
      title: 'The Water Is Clear',
      quote: 'The water feels clearer today. Perhaps your calm is spreading to me.',
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
      title: 'You Changed Something',
      quote: 'I spent a very long time working alone. Now, I notice when you are gone.',
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
      title: 'Stay Until the End',
      quote: "You don't have to say anything. Just stay here until the water is clear.",
      description: 'Unlocked at 2 hours (120 mins) of total focus',
    ),
    FairyMessageModel(
      id: 'suppressant_lv4_2',
      characterId: 'suppressant',
      requiredLevel: 4,
      title: 'When You Leave',
      quote: "When you leave, the water becomes quiet again. ...I don't like that.",
      description: 'Unlocked at 2 hours (120 mins) of total focus',
    ),

    // --- Level 5: Soulbound (240+ mins) ---
    FairyMessageModel(
      id: 'suppressant_lv5_1',
      characterId: 'suppressant',
      requiredLevel: 5,
      title: '???',
      quote: 'I lived alone for a very long time. I thought I was happy. Now I wonder if I was simply used to it.',
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
