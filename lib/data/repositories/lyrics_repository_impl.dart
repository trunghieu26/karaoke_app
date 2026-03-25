import 'package:xml/xml.dart';
import '../../domain/entities/lyric.dart';
import '../../domain/repositories/lyrics_repository.dart';
import '../datasources/lyrics_remote_datasource.dart';

class LyricsRepositoryImpl implements LyricsRepository {
  final LyricsRemoteDataSource dataSource;

  LyricsRepositoryImpl(this.dataSource);

  @override
  Future<List<LyricLine>> getLyrics() async {
    final xml = await dataSource.fetchXml();
    final document = XmlDocument.parse(xml);
    const int lineGap = 120;
    final params = document.findAllElements('param').toList();

    List<LyricLine> lines = [];

    const int minCharDuration = 80;

    for (int i = 0; i < params.length; i++) {
      final param = params[i];
      final iElements = param.findAllElements('i').toList();

      if (iElements.isEmpty) continue;

      List<LyricChar> chars = [];

      for (int j = 0; j < iElements.length; j++) {
        final current = iElements[j];

        final start = (double.parse(current.getAttribute('va')!) * 1000)
            .toInt();

        int rawEnd;

        if (j < iElements.length - 1) {
          rawEnd = (double.parse(iElements[j + 1].getAttribute('va')!) * 1000)
              .toInt();
        } else {

          if (i < params.length - 1) {
            final nextParam = params[i + 1];
            final nextI = nextParam.findElements('i');

            if (nextI.isNotEmpty) {
              final nextStart =
                  (double.parse(nextI.first.getAttribute('va')!) * 1000)
                      .toInt();

              rawEnd = nextStart - lineGap;
            } else {
              rawEnd = start + 300;
            }
          } else {
            rawEnd = start + 300;
          }
        }

        int duration = rawEnd - start;

        int end;
        if (duration <= 0) {
          end = start + minCharDuration;
        } else if (duration < minCharDuration) {
          end = start + minCharDuration;
        } else {
          end = rawEnd;
        }

        chars.add(LyricChar(text: current.innerText, start: start, end: end));
      }

      lines.add(
        LyricLine(start: chars.first.start, end: chars.last.end, chars: chars),
      );
    }

    return lines;
  }
}
