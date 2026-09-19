/// Configurable timer preferences.
class TimerSettingsModel {
  final int focusMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final bool autoStartBreaks;
  final bool autoStartFocus;
  final bool soundAlertsEnabled;

  const TimerSettingsModel({
    required this.focusMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    this.autoStartBreaks = false,
    this.autoStartFocus = false,
    this.soundAlertsEnabled = true,
  });

  factory TimerSettingsModel.defaultSettings() {
    return const TimerSettingsModel(
      focusMinutes: 25,
      shortBreakMinutes: 5,
      longBreakMinutes: 15,
      autoStartBreaks: false,
      autoStartFocus: false,
      soundAlertsEnabled: true,
    );
  }

  TimerSettingsModel copyWith({
    int? focusMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    bool? autoStartBreaks,
    bool? autoStartFocus,
    bool? soundAlertsEnabled,
  }) {
    return TimerSettingsModel(
      focusMinutes: focusMinutes ?? this.focusMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartFocus: autoStartFocus ?? this.autoStartFocus,
      soundAlertsEnabled: soundAlertsEnabled ?? this.soundAlertsEnabled,
    );
  }
}
