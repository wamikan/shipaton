# RevenueCat In-App Purchase & Monetization Architecture
**Target Event: Shipaton 2026 (Next Gen Award)**

## 1. Overview
The **Shipaton Pomodoro Timer** implements a gamified Nordic in-app economy powered by the **RevenueCat SDK (`purchases_flutter: ^8.0.0`)**.

Users can earn currency (**Coins**) either organically by completing Pomodoro focus sessions (e.g. 10 Coins per session) or instantly through **Consumable Coin Packs** via In-App Purchases. Coins are spent in the **In-App Shop** to unlock character companions (such as *Appetite Suppressant* for 300 Coins) and premium ambient soundscapes.

---

## 2. In-App Purchase Tiers (Offerings)

| Product Title | Product Identifier | Price | Coins Credited | Target Value Proposition |
| :--- | :--- | :--- | :--- | :--- |
| **Handful of Coins** | `coin_pack_100` | $0.99 | +100 Coins | Quick top-up for soundscapes |
| **Pouch of Coins** (Popular) | `coin_pack_500` | $3.99 | +500 Coins | Instantly unlock companion Imp (300 Coins) |
| **Chest of Coins** (Best Value) | `coin_pack_1200` | $7.99 | +1,200 Coins | Complete catalog & all characters |

---

## 3. RevenueCat Integration Points

### 1. `lib/data/services/purchase_service.dart`
- **SDK Initialization**:
  ```dart
  Purchases.configure(PurchasesConfiguration(kRevenueCatApiKey));
  ```
- **Offerings & Purchase Execution**:
  ```dart
  final offerings = await Purchases.getOfferings();
  final customerInfo = await Purchases.purchasePackage(package);
  ```
- **Purchase Restoration**:
  ```dart
  final customerInfo = await Purchases.restorePurchases();
  ```
- **Sandbox Fallback Mode**:
  If no API key is specified (or during offline development / simulator tests), the service gracefully logs the transaction and credits the coins to the user's balance locally so the entire app flow and demo recording are 100% functional.

### 2. Paywall Component (`lib/features/shop/views/coin_pack_paywall_sheet.dart`)
- Accessible anywhere in the app:
  - Header coin badge (+ button)
  - Shop banner ("Need More Coins?")
  - Automatically triggered when attempting to unlock a companion/item without sufficient coin balance
- Displays tiers, "POPULAR" badge, price points, and "Restore Purchases" button.

### 3. Shop & Economy Integration (`lib/features/shop/views/shop_screen.dart`)
- Real-time balance updates upon purchase completion.
- One-tap unlock and equip flow for characters.

---

## 4. How to Connect Real RevenueCat Dashboard (Optional for Next Gen Award)

For the **Next Gen Award**, live App Store submission is **not required** (a video demo and open-source repo are evaluated). However, to connect your live RevenueCat project:

1. **Create an App in RevenueCat Dashboard** ([app.revenuecat.com](https://app.revenuecat.com)).
2. **Add Products**:
   - Consumable `coin_pack_100` ($0.99)
   - Consumable `coin_pack_500` ($3.99)
   - Consumable `coin_pack_1200` ($7.99)
3. **Attach to Default Offering**:
   - Add these 3 products to an offering titled `default`.
4. **Configure API Key**:
   - In `lib/data/services/purchase_service.dart`, update:
     ```dart
     const String kRevenueCatApiKey = 'YOUR_REVENUECAT_PUBLIC_API_KEY';
     ```
