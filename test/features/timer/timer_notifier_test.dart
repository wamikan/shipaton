import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipaton_timer/data/models/character_model.dart';
import 'package:shipaton_timer/features/gamification/notifiers/coin_notifier.dart';
import 'package:shipaton_timer/features/timer/models/timer_state.dart';
import 'package:shipaton_timer/features/timer/notifiers/timer_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({'user_coin_balance': 50});
    prefs = await SharedPreferences.getInstance();

    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('Initial timer state has 25 minutes and Focus mode', () {
    final state = container.read(timerNotifierProvider);
    expect(state.mode, PomodoroMode.focus);
    expect(state.remainingSeconds, 25 * 60);
    expect(state.totalSeconds, 25 * 60);
    expect(state.status, TimerStatus.initial);
    expect(state.selectedCharacter.id, 'enhancer');
    expect(state.progress, 1.0);
  });

  test('Mode switching correctly updates duration and state', () {
    final notifier = container.read(timerNotifierProvider.notifier);

    notifier.switchMode(PomodoroMode.shortBreak);
    var state = container.read(timerNotifierProvider);
    expect(state.mode, PomodoroMode.shortBreak);
    expect(state.remainingSeconds, 5 * 60);
    expect(state.totalSeconds, 5 * 60);

    notifier.switchMode(PomodoroMode.longBreak);
    state = container.read(timerNotifierProvider);
    expect(state.mode, PomodoroMode.longBreak);
    expect(state.remainingSeconds, 15 * 60);
    expect(state.totalSeconds, 15 * 60);
  });

  test('Character selection updates active companion', () {
    final notifier = container.read(timerNotifierProvider.notifier);

    notifier.selectCharacter(CharacterModel.suppressant);
    final state = container.read(timerNotifierProvider);
    expect(state.selectedCharacter.id, 'suppressant');
    expect(state.selectedCharacter.tone, CharacterTone.cool);
  });

  test('Starting and pausing updates timer status', () {
    final notifier = container.read(timerNotifierProvider.notifier);

    notifier.start();
    expect(container.read(timerNotifierProvider).status, TimerStatus.running);

    notifier.pause();
    expect(container.read(timerNotifierProvider).status, TimerStatus.paused);

    notifier.reset();
    expect(container.read(timerNotifierProvider).status, TimerStatus.initial);
    expect(container.read(timerNotifierProvider).remainingSeconds, 25 * 60);
  });
}
