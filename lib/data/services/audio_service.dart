import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/constants/app_assets.dart';
import '../models/ambient_sound_model.dart';

/// Service managing background ambient loops and completion sound effects.
class AudioService {
  final AudioPlayer _ambientPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  AmbientSoundModel _currentSound = AmbientSoundModel.defaultSoundscapes.first;
  double _ambientVolume = 0.5;
  bool _isPlayingAmbient = false;

  AmbientSoundModel get currentSound => _currentSound;
  double get ambientVolume => _ambientVolume;
  bool get isPlayingAmbient => _isPlayingAmbient;

  AudioService() {
    _ambientPlayer.setLoopMode(LoopMode.one);
    _ambientPlayer.setVolume(_ambientVolume);
  }

  /// Sets and starts playing an ambient soundscape.
  Future<void> playAmbient(AmbientSoundModel sound) async {
    _currentSound = sound;
    if (sound.id == 'none' || sound.assetPath.isEmpty) {
      await stopAmbient();
      return;
    }

    try {
      await _ambientPlayer.setAsset(sound.assetPath);
      await _ambientPlayer.play();
      _isPlayingAmbient = true;
    } catch (e) {
      developer.log('AudioService: Ambient asset not yet bundled (${sound.assetPath}): $e');
      _isPlayingAmbient = false;
    }
  }

  /// Stops current ambient soundscape.
  Future<void> stopAmbient() async {
    try {
      await _ambientPlayer.stop();
    } catch (e) {
      developer.log('AudioService: Error stopping ambient: $e');
    }
    _isPlayingAmbient = false;
  }

  /// Adjusts ambient volume (0.0 to 1.0).
  Future<void> setAmbientVolume(double volume) async {
    _ambientVolume = volume.clamp(0.0, 1.0);
    await _ambientPlayer.setVolume(_ambientVolume);
  }

  /// Plays session completion chime / alarm.
  Future<void> playCompletionAlarm() async {
    try {
      await _sfxPlayer.setAsset(AppAssets.sfxBell);
      await _sfxPlayer.play();
    } catch (e) {
      developer.log('AudioService: Completion alarm asset not yet bundled: $e');
    }
  }

  /// Plays coin collection sound effect.
  Future<void> playCoinChime() async {
    try {
      await _sfxPlayer.setAsset(AppAssets.sfxCoin);
      await _sfxPlayer.play();
    } catch (e) {
      developer.log('AudioService: Coin chime asset not yet bundled: $e');
    }
  }

  void dispose() {
    _ambientPlayer.dispose();
    _sfxPlayer.dispose();
  }
}

/// State notifier for reactive audio state in the UI.
class AudioState {
  final AmbientSoundModel currentSound;
  final double volume;
  final bool isPlaying;

  const AudioState({
    required this.currentSound,
    required this.volume,
    required this.isPlaying,
  });

  AudioState copyWith({
    AmbientSoundModel? currentSound,
    double? volume,
    bool? isPlaying,
  }) {
    return AudioState(
      currentSound: currentSound ?? this.currentSound,
      volume: volume ?? this.volume,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

class AudioNotifier extends StateNotifier<AudioState> {
  final AudioService _audioService;

  AudioNotifier(this._audioService)
      : super(AudioState(
          currentSound: _audioService.currentSound,
          volume: _audioService.ambientVolume,
          isPlaying: _audioService.isPlayingAmbient,
        ));

  Future<void> selectSound(AmbientSoundModel sound) async {
    await _audioService.playAmbient(sound);
    state = state.copyWith(
      currentSound: sound,
      isPlaying: sound.id != 'none',
    );
  }

  Future<void> togglePlayback() async {
    if (state.isPlaying) {
      await _audioService.stopAmbient();
      state = state.copyWith(isPlaying: false);
    } else {
      if (state.currentSound.id != 'none') {
        await _audioService.playAmbient(state.currentSound);
        state = state.copyWith(isPlaying: true);
      }
    }
  }

  Future<void> setVolume(double volume) async {
    await _audioService.setAmbientVolume(volume);
    state = state.copyWith(volume: volume);
  }

  Future<void> playCompletionAlarm() async {
    await _audioService.playCompletionAlarm();
  }

  Future<void> playCoinChime() async {
    await _audioService.playCoinChime();
  }
}

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

final audioNotifierProvider =
    StateNotifierProvider<AudioNotifier, AudioState>((ref) {
  final service = ref.watch(audioServiceProvider);
  return AudioNotifier(service);
});
