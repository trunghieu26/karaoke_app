import '../../domain/entities/lyric.dart';

class PlayerState {
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final List<LyricLine> lyrics;

  PlayerState({
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.lyrics,
  });

  PlayerState copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    List<LyricLine>? lyrics,
  }) {
    return PlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      lyrics: lyrics ?? this.lyrics,
    );
  }
}