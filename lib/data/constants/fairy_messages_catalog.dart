import '../models/focus_stats_model.dart';

/// Central catalog of dialogue quotes and motivational messages from fairy companions.
/// Easily add new messages here at any time to expand the compendium!
class FairyMessagesCatalog {
  /// Master list of all messages across all fairy companions.
  static const List<FairyMessageModel> allMessages = [
    // ==========================================
    // 🍓 食欲増進ちゃん (Appetite Enhancer Girl)
    // ==========================================

    // --- Level 1: はじめまして (0 - 24 mins) ---
    FairyMessageModel(
      id: 'enhancer_lv1_1',
      characterId: 'enhancer',
      requiredLevel: 1,
      title: 'はじめまして！',
      quote: 'よろしくね！美味しいものいっぱい食べて、今日も楽しく集中していこー！',
      description: '食欲増進ちゃんとの初めての出会い',
    ),
    FairyMessageModel(
      id: 'enhancer_lv1_2',
      characterId: 'enhancer',
      requiredLevel: 1,
      title: 'スタートの合図',
      quote: 'タイマーをセットしたら準備完了！あなたの頑張りを一番近くで応援してるよ♪',
      description: '集中セッションへの励まし',
    ),

    // --- Level 2: 仲良し (25 - 59 mins) ---
    FairyMessageModel(
      id: 'enhancer_lv2_1',
      characterId: 'enhancer',
      requiredLevel: 2,
      title: 'ごちそうタイム！',
      quote: 'すごいすごい！集中できた後のご飯は、いつもの100倍美味しいんだよ！',
      description: '累計作業時間25分突破で解放',
    ),
    FairyMessageModel(
      id: 'enhancer_lv2_2',
      characterId: 'enhancer',
      requiredLevel: 2,
      title: '元気のおすそ分け',
      quote: '疲れたら深呼吸して、甘いもの補給しよ？まだまだ一緒に頑張れるよ！',
      description: '累計作業時間25分突破で解放',
    ),

    // --- Level 3: 深い信頼 (60 - 119 mins) ---
    FairyMessageModel(
      id: 'enhancer_lv3_1',
      characterId: 'enhancer',
      requiredLevel: 3,
      title: '秘密のおやつ',
      quote: 'えへへ、実はあなたと作業するのが毎日の楽しみなんだ。これ、特別なお菓子あげる♪',
      description: '累計作業時間1時間（60分）突破で解放',
    ),
    FairyMessageModel(
      id: 'enhancer_lv3_2',
      characterId: 'enhancer',
      requiredLevel: 3,
      title: '息ぴったり！',
      quote: 'あなたが集中モードに入ると、私のスライムも嬉しくてキラキラ輝いちゃうの！',
      description: '累計作業時間1時間（60分）突破で解放',
    ),

    // --- Level 4: 大親友 (120 - 239 mins) ---
    FairyMessageModel(
      id: 'enhancer_lv4_1',
      characterId: 'enhancer',
      requiredLevel: 4,
      title: '最高のパートナー',
      quote: 'どんなに難しい課題でも、あなたと一緒なら絶対に乗り越えられるって信じてるよ！',
      description: '累計作業時間2時間（120分）突破で解放',
    ),
    FairyMessageModel(
      id: 'enhancer_lv4_2',
      characterId: 'enhancer',
      requiredLevel: 4,
      title: '満腹の幸せ',
      quote: 'あなたの努力がどんどん実を結んでるね。私のお腹も心も、いっぱいの幸せで満たされてるよ！',
      description: '累計作業時間2時間（120分）突破で解放',
    ),

    // --- Level 5: 魂の絆 (240+ mins) ---
    FairyMessageModel(
      id: 'enhancer_lv5_1',
      characterId: 'enhancer',
      requiredLevel: 5,
      title: '魂の絆・至高の光',
      quote: 'あなたと過ごした集中時間は、世界中のどんなごちそうよりも輝いてる私の宝物だよ。ずっとずっと一緒だよ！',
      description: '累計作業時間4時間（240分）達成で解放される最高峰の絆メッセージ',
    ),

    // ==========================================
    // 💧 食欲減退くん (Appetite Suppressant Boy)
    // ==========================================

    // --- Level 1: はじめまして (0 - 24 mins) ---
    FairyMessageModel(
      id: 'suppressant_lv1_1',
      characterId: 'suppressant',
      requiredLevel: 1,
      title: '静寂の誓い',
      quote: '深呼吸をして、心の水面を凪のように静めよう。僕が君の集中を守るよ。',
      description: '食欲減退くんとの最初の静寂',
    ),
    FairyMessageModel(
      id: 'suppressant_lv1_2',
      characterId: 'suppressant',
      requiredLevel: 1,
      title: '雑念を手放して',
      quote: '余計な欲求をひとつ手放すごとに、君の思考は澄み渡り、研ぎ澄まされていくよ。',
      description: '静かな集中への誘い',
    ),

    // --- Level 2: 仲良し (25 - 59 mins) ---
    FairyMessageModel(
      id: 'suppressant_lv2_1',
      characterId: 'suppressant',
      requiredLevel: 2,
      title: '澄んだ水のように',
      quote: 'いい集中だったね。雑音の消え去った静寂の世界は、とても心地よいだろう？',
      description: '累計作業時間25分突破で解放',
    ),
    FairyMessageModel(
      id: 'suppressant_lv2_2',
      characterId: 'suppressant',
      requiredLevel: 2,
      title: '渇きを潤す滴',
      quote: '焦らなくていい。冷たい水が一滴ずつ大地を潤すように、着実に前へ進もう。',
      description: '累計作業時間25分突破で解放',
    ),

    // --- Level 3: 深い信頼 (60 - 119 mins) ---
    FairyMessageModel(
      id: 'suppressant_lv3_1',
      characterId: 'suppressant',
      requiredLevel: 3,
      title: '静かな共鳴',
      quote: '君の静かな熱意、ちゃんと伝わっているよ。僕のマントにも清らかな光が灯ってきた。',
      description: '累計作業時間1時間（60分）突破で解放',
    ),
    FairyMessageModel(
      id: 'suppressant_lv3_2',
      characterId: 'suppressant',
      requiredLevel: 3,
      title: '波紋の先へ',
      quote: '水面に落ちた一滴が美しい波紋を広げるように、君の努力は遠くまで届くよ。',
      description: '累計作業時間1時間（60分）突破で解放',
    ),

    // --- Level 4: 大親友 (120 - 239 mins) ---
    FairyMessageModel(
      id: 'suppressant_lv4_1',
      characterId: 'suppressant',
      requiredLevel: 4,
      title: '揺るぎない集中',
      quote: '嵐の中でも、深い水底はいつも静かだ。君の心も、もう何者にも惑わされない境地にある。',
      description: '累計作業時間2時間（120分）突破で解放',
    ),
    FairyMessageModel(
      id: 'suppressant_lv4_2',
      characterId: 'suppressant',
      requiredLevel: 4,
      title: '無言の信頼',
      quote: '言葉を交わさずとも、君が今どれほど研ぎ澄まされているか、僕にはすべてわかるよ。',
      description: '累計作業時間2時間（120分）突破で解放',
    ),

    // --- Level 5: 魂の絆 (240+ mins) ---
    FairyMessageModel(
      id: 'suppressant_lv5_1',
      characterId: 'suppressant',
      requiredLevel: 5,
      title: '清流の境地・永遠の静寂',
      quote: '君と共に歩んできた時間は、淀みなく流れる奇跡の清流そのものだ。この静かな誇りを、永遠に君へ。',
      description: '累計作業時間4時間（240分）達成で解放される最高峰の絆メッセージ',
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
