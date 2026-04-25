// lib/data/datasources/local/audio_player_service.dart

import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';
import '../../../core/constants/app_constants.dart';

class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  final AudioPlayer _player = AudioPlayer();

  // Streams
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<double> get speedStream => _player.speedStream;

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, buffered, duration) => PositionData(
          position: position,
          buffered: buffered,
          duration: duration ?? Duration.zero,
        ),
      );

  bool get isPlaying => _player.playing;
  ProcessingState get processingState => _player.processingState;

  // ---- Play URL ----
  Future<void> playUrl(String url) async {
    try {
      await _player.stop();
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      throw Exception('Failed to play audio: $e');
    }
  }

  // ---- Play Surah ----
  Future<void> playSurah(int surahNumber, String reciter) async {
    final paddedNumber = surahNumber.toString().padLeft(3, '0');
    final url = 'https://download.quranicaudio.com/quran/$reciter/$paddedNumber.mp3';
    await playUrl(url);
  }

  // ---- Play Ayah ----
  Future<void> playAyah(int ayahNumber, String reciter) async {
    final paddedNumber = ayahNumber.toString().padLeft(6, '0');
    final url = '${AppConstants.audioBase}/64/$reciter/$paddedNumber.mp3';
    await playUrl(url);
  }

  // ---- Playlist (multiple ayahs) ----
  Future<void> playAyahsPlaylist(
      List<int> ayahNumbers, String reciter) async {
    final sources = ayahNumbers.map((n) {
      final padded = n.toString().padLeft(6, '0');
      return AudioSource.uri(
        Uri.parse('${AppConstants.audioBase}/64/$reciter/$padded.mp3'),
      );
    }).toList();

    final playlist = ConcatenatingAudioSource(children: sources);
    await _player.setAudioSource(playlist);
    await _player.play();
  }

  // ---- Controls ----
  Future<void> play() async => _player.play();
  Future<void> pause() async => _player.pause();
  Future<void> stop() async => _player.stop();
  Future<void> seek(Duration position) async => _player.seek(position);
  Future<void> next() async => _player.seekToNext();
  Future<void> previous() async => _player.seekToPrevious();
  Future<void> setSpeed(double speed) async => _player.setSpeed(speed);

  // ---- Looping ----
  Future<void> setLoopMode(LoopMode mode) async => _player.setLoopMode(mode);

  void dispose() => _player.dispose();
}

class PositionData {
  final Duration position;
  final Duration buffered;
  final Duration duration;

  PositionData({
    required this.position,
    required this.buffered,
    required this.duration,
  });
}
