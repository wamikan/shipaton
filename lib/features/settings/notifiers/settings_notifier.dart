import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/timer_settings_model.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../gamification/notifiers/coin_notifier.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepository(prefs);
});

class SettingsNotifier extends StateNotifier<TimerSettingsModel> {
  final SettingsRepository _repository;

  SettingsNotifier(this._repository) : super(_repository.loadSettings());

  Future<void> updateFocusMinutes(int minutes) async {
    final updated = state.copyWith(focusMinutes: minutes.clamp(5, 90));
    await _repository.saveSettings(updated);
    state = updated;
  }

  Future<void> updateShortBreakMinutes(int minutes) async {
    final updated = state.copyWith(shortBreakMinutes: minutes.clamp(1, 30));
    await _repository.saveSettings(updated);
    state = updated;
  }

  Future<void> updateLongBreakMinutes(int minutes) async {
    final updated = state.copyWith(longBreakMinutes: minutes.clamp(5, 60));
    await _repository.saveSettings(updated);
    state = updated;
  }

  Future<void> toggleSoundAlerts(bool enabled) async {
    final updated = state.copyWith(soundAlertsEnabled: enabled);
    await _repository.saveSettings(updated);
    state = updated;
  }

  Future<void> resetToDefaults() async {
    final defaults = TimerSettingsModel.defaultSettings();
    await _repository.saveSettings(defaults);
    state = defaults;
  }
}

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, TimerSettingsModel>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return SettingsNotifier(repository);
});
