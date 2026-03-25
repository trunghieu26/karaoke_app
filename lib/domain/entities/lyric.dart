import 'dart:convert';

class LyricChar {
  final String text;
  final int start;
  final int end;

  LyricChar({required String text, required this.start, required this.end})
    : text = utf8.decode(latin1.encode(text));
}

class LyricLine {
  final int start;
  final int end;
  final List<LyricChar> chars;

  LyricLine({required this.start, required this.end, required this.chars});
}
