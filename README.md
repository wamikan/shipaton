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
   - **Appetite Enhancer** (Warm tones, playful): Default companion celebrating deep focus streaks.
   - **Appetite Suppressant** (Cool cyan tones, serene): Unlockable companion in the shop for 300 Coins.
   - Character artwork embedded directly with floating/breathing feedback and celebratory dialogs.

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
git clone https://github.com/your-username/shipaton.git
cd shipaton

# Install dependencies
flutter pub get

# Run on macOS / Chrome / iOS / Android
flutter run
```

### Instant Interactive Demo (Zero-Setup)
Open [`demo_preview.html`](demo_preview.html) in any web browser to test the full app experience with real-time Web Audio synthesis, character unlocks, and simulated RevenueCat purchase flows:
```bash
open demo_preview.html
```

---

## 💳 RevenueCat Setup

See [**`REVENUECAT_SETUP.md`**](REVENUECAT_SETUP.md) for full documentation on:
- Product identifiers (`coin_pack_100`, `coin_pack_500`, `coin_pack_1200`)
- RevenueCat Offerings and Entitlements
- Dev/Sandbox mode configuration
