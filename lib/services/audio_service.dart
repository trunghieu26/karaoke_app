import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> init() async {
    await _player.setUrl(
      "https://storage.googleapis.com/ikara-storage/tmp/beat.mp3",
    );
  }

  Stream<Duration> get position =>
      _player.createPositionStream(
        steps: 800,
      );

  Duration? get duration => _player.duration;

  bool get isPlaying => _player.playing;

  void play() => _player.play();
  void pause() => _player.pause();

  void seek(Duration d) => _player.seek(d);
}