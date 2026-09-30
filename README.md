# 🌿 Nordic Focus — Gamified Pomodoro Timer
**Submission for Shipaton 2026 — Next Gen Award**

[![Flutter](https://img.shields.io/badge/Flutter-3.16+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Riverpod](https://img.shields.io/badge/State-Riverpod%202.5-00D2B8)](https://riverpod.dev)
[![RevenueCat](https://img.shields.io/badge/Monetization-RevenueCat%20SDK-F2545B)](https://www.revenuecat.com)
[![Design](https://img.shields.io/badge/Style-Nordic%20Minimalism-48D1CC)](https://coolors.co)

> A calming, gamified Pomodoro timer blending Scandinavian minimalism with charming imp companions and sustainable in-app economy.

---

## 🌟 Key Features

1. **Customizable Nordic Pomodoro Timer**
   - Clean, distraction-free interface centered around a soothing Medium Turquoise (`#48D1CC`) circular ring.
   - Configurable Focus (default: 25m), Short Break (5m), and Long Break (15m).
   - **Seamless Auto-Rest Transition**: When claiming focus session rewards, the app automatically transitions and starts the rest break countdown without friction.

2. **Charming Imp Companions**
   - **Appetite Enhancer** (Warm tones, playful): Lively imp celebrating focus with delicious Nordic forest treats.
   - **Appetite Suppressant** (Cool cyan tones, serene): Calming imp absorbing ripples of water for deep serenity.
   - Switch freely between companions on the timer screen or shop, and build friendship affection with both!

3. **Multi-Track Audio Player**
   - Ambient soundscape loops: Nordic Rain, Mountain River, Pine Forest, and Deep Concentration White Noise.
   - Harmonic 528Hz temple bell completion chime upon session finish.
   - Sparkly sound effects for coin collection.

4. **Gamification & Sustainable Economy**
   - Complete focus sessions to earn in-app Coins (+10 Coins per session).
   - Spend Coins in the Shop to unlock new characters and premium audio.

5. **RevenueCat In-App Purchase Monetization**
   - Powered natively by the **RevenueCat SDK (`purchases_flutter: ^8.0.0`)**.
   - Consumable Coin Packs ($0.99 for 100 Coins, $3.99 for 500 Coins, $7.99 for 1,200 Coins).
   - Interactive Paywall with Popular badge, item details, and one-tap restore purchases.
   - Smart paywall trigger: Automatically prompts when attempting to unlock an item without sufficient balance.

---

## 🏗️ Architecture

```
lib/
├── core/
│   ├── constants/       # AppColors (#48D1CC), AppTypography, AppAssets
│   ├── theme/           # Nordic Light ThemeData
│   └── utils/           # TimeFormatter (mm:ss)
├── data/
│   ├── models/          # CharacterModel, ShopItemModel, AmbientSoundModel
│   ├── repositories/    # CoinRepository, SettingsRepository, ShopRepository
│   └── services/        # AudioService (just_audio), PurchaseService (RevenueCat)
├── features/
│   ├── gamification/    # CoinNotifier (persisted via SharedPreferences)
│   ├── settings/        # SettingsNotifier, SettingsScreen
│   ├── shell/           # MainShellScreen (Scaffold with BottomNavigationBar)
│   ├── shop/            # ShopNotifier, ShopScreen, CoinPackPaywallSheet
│   └── timer/           # TimerNotifier, TimerScreen, widgets & progress ring
└── main.dart            # ProviderScope entrypoint
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.16.0`
- Dart SDK `>=3.2.0`

### Installation
```bash
# Clone the repository
git clone https://github.com/wamikan/shipaton.git
cd shipaton

# Install dependencies
flutter pub get

# Run on macOS / iOS / Android
flutter run
```

### 🌐 Instant Live Web Demo (Zero-Setup)
Experience the app right in your browser with real-time Web Audio soundscapes, 10s quick-test mode, and RevenueCat simulation:
- **Live Demo**: [https://wamikan.github.io/shipaton/](https://wamikan.github.io/shipaton/)
- Or open local [`index.html`](index.html) in your browser:
```bash
open index.html
```

---

## 💳 RevenueCat Setup

See [**`REVENUECAT_SETUP.md`**](REVENUECAT_SETUP.md) for full documentation on:
- Product identifiers (`coin_pack_100`, `coin_pack_500`, `coin_pack_1200`)
- RevenueCat Offerings and Entitlements
- Dev/Sandbox mode configuration

---

## 🎵 Audio Credits & Licensing

Nordic Focus incorporates ambient background soundscapes and sound effects to facilitate deep focus and concentration. Special thanks and formal attributions to our audio sources:

| Sound Track | Audio File | Source / Creator | License & Attribution |
| :--- | :--- | :--- | :--- |
| **Rain & Nature** | `rainnature.mp3` | [**On-Jin ～音人～**](https://on-jin.com/) | Used under On-Jin material embedded work guidelines. All rights reserved by On-Jin. Secondary distribution or standalone extraction prohibited. (音源の二次配布・無断利用禁止) |
| **Positive Flow** | `positive.mp3` | [**tunee.ai**](https://tunee.ai/) | AI-assisted concentration track composed with tunee.ai for motivation and positivity. |
| **Nordic Rain & Piano** | `rain.mp3` | Royalty-Free Soundscapes | Nordic ambient lo-fi arrangement. |
| **Pine Forest & Bells** | `forest.mp3` | Royalty-Free Soundscapes | Nordic pine woodland soundscape. |
| **Temple Bell Chime** | `bell.mp3` | 528Hz Harmonic Bell | Focus session completion alert. |
| **Coin Collection SFX** | `coin.mp3` | In-House SFX | Rewarding gamification audio chime. |

---


## 🎨 Visual Assets & Licensing

Nordic Focus incorporates graphic and illustration assets to enhance the immersive focus experience. Formal attributions and sources for our visual assets:

| Asset Category | File Prefix / Path | Source / Creator | License & Attribution |
| :--- | :--- | :--- | :--- |
| **Food Icons** | `assets/images/items/foods/` | **Original / Family Collection** | Custom icons crafted from personal and family photographs. Pattern created with MakeBead.|
| **Plant Icons** | `assets/images/items/plants/` | [**フリー素材ぱくたそ**](https://www.pakutaso.com/) | Visual assets used under the [Pakutaso Terms of Use](https://www.pakutaso.com/userpolicy.html). All rights reserved by フリー素材ぱくたそ.  Pattern created with MakeBead|

> Detailed licensing terms and Japanese attribution statements are fully documented in [**`ATTRIBUTION.md`**](ATTRIBUTION.md).

