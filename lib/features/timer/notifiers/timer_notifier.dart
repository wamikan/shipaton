import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/timer_state.dart';
import '../../../data/models/character_model.dart';
import '../../../data/services/audio_service.dart';
import '../../gamification/notifiers/coin_notifier.dart';
import '../../settings/notifiers/settings_notifier.dart';

class TimerNotifier extends StateNotifier<TimerState> {
  final Ref _ref;
  Timer? _timer;

  TimerNotifier(this._ref) : super(TimerState.initial()) {
    // 10-second test duration for audio verification
    const testSeconds = 10;
    state = state.copyWith(
      remainingSeconds: testSeconds,
      totalSeconds: testSeconds,
    );
  }

  int _getModeDurationSeconds(PomodoroMode mode) {
    // 10 seconds for Focus, 5s for Short Break, 10s for Long Break
    return switch (mode) {
      PomodoroMode.focus => 10,
      PomodoroMode.shortBreak => 5,
      PomodoroMode.longBreak => 10,
    };
  }

  /// Starts or resumes the countdown timer.
  void start() {
    if (state.isRunning) return;

    if (state.remainingSeconds <= 0) {
      reset();
    }

    state = state.copyWith(status: TimerStatus.running);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  /// Pauses the running timer.
  void pause() {
    if (!state.isRunning) return;
    _timer?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }

  /// Resets timer back to current mode's duration.
  void reset() {
    _timer?.cancel();
    final durationSeconds = _getModeDurationSeconds(state.mode);
    state = state.copyWith(
      status: TimerStatus.initial,
      remainingSeconds: durationSeconds,
      totalSeconds: durationSeconds,
      clearRewardedCoins: true,
    );
  }

  /// Switches between Focus, Short Break, or Long Break.
  void switchMode(PomodoroMode newMode) {
    if (state.mode == newMode && !state.isCompleted) return;
    _timer?.cancel();
    final durationSeconds = _getModeDurationSeconds(newMode);
    state = state.copyWith(
      mode: newMode,
      status: TimerStatus.initial,
      remainingSeconds: durationSeconds,
      totalSeconds: durationSeconds,
      clearRewardedCoins: true,
    );
  }

  /// Transitions to break mode and immediately starts the countdown.
  void startBreak({bool isLong = false}) {
    switchMode(isLong ? PomodoroMode.longBreak : PomodoroMode.shortBreak);
    start();
  }

  /// Changes the active companion character.
  void selectCharacter(CharacterModel character) {
    state = state.copyWith(selectedCharacter: character);
  }

  /// Dismisses completion notification.
  void dismissRewardAlert() {
    state = state.copyWith(clearRewardedCoins: true);
  }

  /// Timer tick handler called every second.
  void _tick() {
    if (state.remainingSeconds > 1) {
      state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
    } else {
      _onCompleted();
    }
  }

  /// Triggered when the timer hits zero.
  void _onCompleted() {
    _timer?.cancel();

    final settings = _ref.read(settingsNotifierProvider);
    if (settings.soundAlertsEnabled) {
      _ref.read(audioNotifierProvider.notifier).playCompletionAlarm();
    }

    int earnedCoins = 0;
    if (state.mode == PomodoroMode.focus) {
      earnedCoins = state.mode.coinReward;
      _ref.read(coinNotifierProvider.notifier).addCoins(earnedCoins);
    }

    final newSessionsCompleted = state.mode == PomodoroMode.focus
        ? state.sessionsCompleted + 1
        : state.sessionsCompleted;

    state = state.copyWith(
      status: TimerStatus.completed,
      remainingSeconds: 0,
      sessionsCompleted: newSessionsCompleted,
      lastRewardedCoins: earnedCoins > 0 ? earnedCoins : null,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final timerNotifierProvider =
    StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier(ref);
});
