import 'package:flutter/material.dart';
import '../../domain/entities/lyric.dart';

class LyricLineWidget extends StatelessWidget {
  final LyricLine line;
  final int currentMs;

  const LyricLineWidget({
    super.key,
    required this.line,
    required this.currentMs,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: line.chars.map((c) {
          double progress;

          if (currentMs <= c.start) {
            progress = 0;
          } else if (currentMs >= c.end) {
            progress = 1;
          } else {
            final raw = (currentMs - c.start) / (c.end - c.start);

            progress = Curves.easeOut.transform(raw);
          }

          progress = progress.clamp(0.0, 1.0);

          return WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: _CharHighlight(char: c.text, progress: progress),
          );
        }).toList(),
      ),
    );
  }
}

class _CharHighlight extends StatelessWidget {
  final String char;
  final double progress;

  const _CharHighlight({required this.char, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          char,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.white54,
            fontWeight: FontWeight.bold,
          ),
        ),

        ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Text(
              char,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
