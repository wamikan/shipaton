/// Modes for background music playback across focus sessions and breaks.
enum BgmBreakMode {
  always, // Continuous playback (play BGM during both focus and breaks)
  focusOnly, // Focus only (mute BGM during breaks)
  breakOnly, // Break only (play BGM only during breaks)
}

/// Configurable timer preferences.
class TimerSettingsModel {
  final int focusMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final bool autoStartBreaks;
  final bool autoStartFocus;
  final bool soundAlertsEnabled;
  final bool showFocusAnimation;
  final BgmBreakMode bgmBreakMode;

  const TimerSettingsModel({
    required this.focusMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    this.autoStartBreaks = false,
    this.autoStartFocus = false,
    this.soundAlertsEnabled = true,
    this.showFocusAnimation = true,
    this.bgmBreakMode = BgmBreakMode.always,
  });

  factory TimerSettingsModel.defaultSettings() {
    return const TimerSettingsModel(
      focusMinutes: 25,
      shortBreakMinutes: 5,
      longBreakMinutes: 15,
      autoStartBreaks: false,
      autoStartFocus: false,
      soundAlertsEnabled: true,
      showFocusAnimation: true,
      bgmBreakMode: BgmBreakMode.always,
    );
  }

  TimerSettingsModel copyWith({
    int? focusMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    bool? autoStartBreaks,
    bool? autoStartFocus,
    bool? soundAlertsEnabled,
    bool? showFocusAnimation,
    BgmBreakMode? bgmBreakMode,
  }) {
    return TimerSettingsModel(
      focusMinutes: focusMinutes ?? this.focusMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartFocus: autoStartFocus ?? this.autoStartFocus,
      soundAlertsEnabled: soundAlertsEnabled ?? this.soundAlertsEnabled,
      showFocusAnimation: showFocusAnimation ?? this.showFocusAnimation,
      bgmBreakMode: bgmBreakMode ?? this.bgmBreakMode,
    );
  }
}

