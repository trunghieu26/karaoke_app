import '../entities/lyric.dart';

abstract class LyricsRepository {
  Future<List<LyricLine>> getLyrics();
}