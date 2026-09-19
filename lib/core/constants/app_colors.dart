import 'package:flutter/material.dart';

/// App-wide color palette adhering to Nordic Minimalist principles
/// with `#48D1CC` Medium Turquoise as the hero theme color.
class AppColors {
  AppColors._();

  // Primary Nordic Turquoise
  static const Color primary = Color(0xFF48D1CC); // Medium Turquoise
  static const Color primaryDark = Color(0xFF27ABA4);
  static const Color primaryLight = Color(0xFF7EE7E3);
  static const Color primarySubtle = Color(0xFFE4F8F7);

  // Nordic Canvas & Surfaces
  static const Color background = Color(0xFFF6F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFEEF4F5);
  static const Color cardBorder = Color(0xFFE2ECEE);

  // Typography & Content Colors (Nordic Slate)
  static const Color textPrimary = Color(0xFF162529);
  static const Color textSecondary = Color(0xFF516970);
  static const Color textTertiary = Color(0xFF8BA2A8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Accents
  static const Color accentMint = Color(0xFF48D1CC);
  static const Color accentSage = Color(0xFF86A397);


  // Gamification & Rewards
  static const Color coinGold = Color(0xFFF5A623);
  static const Color coinGoldDark = Color(0xFFD98209);
  static const Color coinGoldLight = Color(0xFFFFF3DB);

  // Mode Indicators
  static const Color focusMode = Color(0xFF48D1CC);
  static const Color shortBreakMode = Color(0xFF5AB693);
  static const Color longBreakMode = Color(0xFF6B8AFD);

  // Character Theming: Appetite Enhancer (Warm tones, Girly imp)
  static const Color enhancerBg = Color(0xFFFFF1ED);
  static const Color enhancerPrimary = Color(0xFFFF715B);
  static const Color enhancerAccent = Color(0xFFFF9E8E);
  static const Color enhancerBorder = Color(0xFFFFDDD5);

  // Character Theming: Appetite Suppressant (Cool tones, Boyish imp)
  static const Color suppressantBg = Color(0xFFEBF6FA);
  static const Color suppressantPrimary = Color(0xFF3A98D3);
  static const Color suppressantAccent = Color(0xFF73BAE6);
  static const Color suppressantBorder = Color(0xFFD4EBF5);
}
