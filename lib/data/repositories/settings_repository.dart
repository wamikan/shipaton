import 'package:shared_preferences/shared_preferences.dart';
import '../models/timer_settings_model.dart';

/// Repository managing persistence of TimerSettingsModel.
class SettingsRepository {
  static const String _keyFocus = 'timer_focus_minutes';
  static const String _keyShortBreak = 'timer_short_break_minutes';
  static const String _keyLongBreak = 'timer_long_break_minutes';
  static const String _keyAutoBreaks = 'timer_auto_start_breaks';
  static const String _keyAutoFocus = 'timer_auto_start_focus';
  static const String _keySoundAlerts = 'timer_sound_alerts_enabled';
  static const String _keyShowFocusAnimation = 'timer_show_focus_animation';
  static const String _keyBgmBreakMode = 'timer_bgm_break_mode';

  final SharedPreferences _prefs;

  SettingsRepository(this._prefs);

  TimerSettingsModel loadSettings() {
    final bgmBreakModeString = _prefs.getString(_keyBgmBreakMode);
    final bgmBreakMode = switch (bgmBreakModeString) {
      'focusOnly' => BgmBreakMode.focusOnly,
      'breakOnly' => BgmBreakMode.breakOnly,
      _ => BgmBreakMode.always,
    };

    return TimerSettingsModel(
      focusMinutes: _prefs.getInt(_keyFocus) ?? 25,
      shortBreakMinutes: _prefs.getInt(_keyShortBreak) ?? 5,
      longBreakMinutes: _prefs.getInt(_keyLongBreak) ?? 15,
      autoStartBreaks: _prefs.getBool(_keyAutoBreaks) ?? false,
      autoStartFocus: _prefs.getBool(_keyAutoFocus) ?? false,
      soundAlertsEnabled: _prefs.getBool(_keySoundAlerts) ?? true,
      showFocusAnimation: _prefs.getBool(_keyShowFocusAnimation) ?? true,
      bgmBreakMode: bgmBreakMode,
    );
  }

  Future<void> saveSettings(TimerSettingsModel settings) async {
    await _prefs.setInt(_keyFocus, settings.focusMinutes);
    await _prefs.setInt(_keyShortBreak, settings.shortBreakMinutes);
    await _prefs.setInt(_keyLongBreak, settings.longBreakMinutes);
    await _prefs.setBool(_keyAutoBreaks, settings.autoStartBreaks);
    await _prefs.setBool(_keyAutoFocus, settings.autoStartFocus);
    await _prefs.setBool(_keySoundAlerts, settings.soundAlertsEnabled);
    await _prefs.setBool(_keyShowFocusAnimation, settings.showFocusAnimation);
    await _prefs.setString(_keyBgmBreakMode, settings.bgmBreakMode.name);
  }
}
