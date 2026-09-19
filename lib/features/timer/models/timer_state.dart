import '../../../data/models/character_model.dart';

/// Pomodoro cycle modes.
enum PomodoroMode {
  // Configured with 10s test duration for audio verification
  focus(title: 'Focus', defaultMinutes: 25, defaultSeconds: 10, coinReward: 10),
  shortBreak(title: 'Short Break', defaultMinutes: 5, defaultSeconds: 5, coinReward: 0),
  longBreak(title: 'Long Break', defaultMinutes: 15, defaultSeconds: 10, coinReward: 0);

  final String title;
  final int defaultMinutes;
  final int defaultSeconds;
  final int coinReward;

  const PomodoroMode({
    required this.title,
    required this.defaultMinutes,
    required this.defaultSeconds,
    required this.coinReward,
  });
}

/// Execution status of the timer.
enum TimerStatus {
  initial,
  running,
  paused,
  completed,
}

/// Immutable state snapshot for the Pomodoro Timer.
class TimerState {
  final PomodoroMode mode;
  final TimerStatus status;
  final int remainingSeconds;
  final int totalSeconds;
  final int sessionsCompleted;
  final CharacterModel selectedCharacter;
  final int? lastRewardedCoins;

  const TimerState({
    required this.mode,
    required this.status,
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.sessionsCompleted,
    required this.selectedCharacter,
    this.lastRewardedCoins,
  });

  /// Initial state on app startup
  factory TimerState.initial() {
    const initialMode = PomodoroMode.focus;
    return TimerState(
      mode: initialMode,
      status: TimerStatus.initial,
      remainingSeconds: initialMode.defaultSeconds,
      totalSeconds: initialMode.defaultSeconds,
      sessionsCompleted: 0,
      selectedCharacter: CharacterModel.enhancer,
      lastRewardedCoins: null,
    );
  }

  /// Progress fraction from 1.0 (start) down to 0.0 (finished)
  double get progress {
    if (totalSeconds == 0) return 0.0;
    return (remainingSeconds / totalSeconds).clamp(0.0, 1.0);
  }

  bool get isRunning => status == TimerStatus.running;
  bool get isPaused => status == TimerStatus.paused;
  bool get isInitial => status == TimerStatus.initial;
  bool get isCompleted => status == TimerStatus.completed;

  TimerState copyWith({
    PomodoroMode? mode,
    TimerStatus? status,
    int? remainingSeconds,
    int? totalSeconds,
    int? sessionsCompleted,
    CharacterModel? selectedCharacter,
    int? lastRewardedCoins,
    bool clearRewardedCoins = false,
  }) {
    return TimerState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
      selectedCharacter: selectedCharacter ?? this.selectedCharacter,
      lastRewardedCoins: clearRewardedCoins ? null : (lastRewardedCoins ?? this.lastRewardedCoins),
    );
  }
}
