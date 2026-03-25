import '../entities/lyric.dart';
import '../repositories/lyrics_repository.dart';

class GetLyrics {
  final LyricsRepository repository;

  GetLyrics(this.repository);

  Future<List<LyricLine>> call() {
    return repository.getLyrics();
  }
}