import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';

import '../bloc/player_bloc.dart';
import '../bloc/player_event.dart';
import '../bloc/player_state.dart';
import '../widgets/lyric_line_widget.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A5AE0), Color(0xFFE882A7)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                              size: 28,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Về đâu mái tóc người thương",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        const Padding(
                          padding: EdgeInsets.only(left: 36),
                          child: Text(
                            "Quang Lê",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset('assets/images/disk.png'),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    height: 120,
                    child: Center(
                      child: Builder(
                        builder: (_) {
                          final lyrics = state.lyrics;
                          final currentMs = state.position.inMilliseconds;

                          if (lyrics.isEmpty) {
                            return const SizedBox();
                          }
                          int currentIndex = lyrics.lastIndexWhere(
                            (line) => currentMs >= line.start,
                          );

                          if (currentIndex == -1) {
                            currentIndex = 0;
                          }

                          final currentLine = lyrics[currentIndex];

                          final nextLine = currentIndex + 1 < lyrics.length
                              ? lyrics[currentIndex + 1]
                              : null;

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LyricLineWidget(
                                line: currentLine,
                                currentMs: currentMs,
                              ),

                              const SizedBox(height: 10),

                              if (nextLine != null)
                                Opacity(
                                  opacity: 0.5,
                                  child: LyricLineWidget(
                                    line: nextLine,
                                    currentMs: 0,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 4,
                            activeTrackColor: Colors.black,
                            inactiveTrackColor: Colors.black26,
                            thumbColor: Colors.black,
                            thumbShape: SliderComponentShape.noThumb,
                            overlayShape: SliderComponentShape.noOverlay,
                          ),
                          child: Slider(
                            value: state.position.inSeconds.toDouble(),
                            max: state.duration.inSeconds.toDouble() + 1,
                            onChanged: (v) {
                              context.read<PlayerBloc>().add(
                                SeekTo(Duration(seconds: v.toInt())),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 4),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _format(state.position),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                _formatRemaining(
                                  state.position,
                                  state.duration,
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/shuffer.png',
                            width: 32,
                            height: 32,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),

                      const Icon(
                        Icons.skip_previous,
                        color: Colors.black,
                        size: 32,
                      ),

                      GestureDetector(
                        onTap: () {
                          context.read<PlayerBloc>().add(TogglePlay());
                        },
                        child: PlayPauseButton(isPlaying: state.isPlaying),
                      ),

                      const Icon(
                        Icons.skip_next,
                        color: Colors.black,
                        size: 32,
                      ),
                      ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          'assets/images/reload-icon.png',
                          width: 32,
                          height: 32,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String fixUtf8(String text) {
    return utf8.decode(latin1.encode(text));
  }

  String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  String _formatRemaining(Duration position, Duration duration) {
    final remaining = duration - position;

    final minutes = remaining.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = remaining.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return "-$minutes:$seconds";
  }
}

class PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final double size;

  const PlayPauseButton({super.key, required this.isPlaying, this.size = 50});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _PlayPausePainter(isPlaying),
    );
  }
}

class _PlayPausePainter extends CustomPainter {
  final bool isPlaying;

  _PlayPausePainter(this.isPlaying);

  @override
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    canvas.saveLayer(rect, Paint());

    final paint = Paint()..color = Colors.black;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);

    final holePaint = Paint()..blendMode = BlendMode.clear;

    final path = Path();

    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;

    final iconHeight = h * 0.38;
    final iconWidth = w * 0.38;

    if (isPlaying) {
      final barWidth = iconWidth * 0.22;
      final gap = barWidth * 0.8;

      path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(cx - gap, cy),
            width: barWidth,
            height: iconHeight,
          ),
          const Radius.circular(2),
        ),
      );

      path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(cx + gap, cy),
            width: barWidth,
            height: iconHeight,
          ),
          const Radius.circular(2),
        ),
      );
    } else {
      path.moveTo(cx - iconWidth * 0.3, cy - iconHeight / 2);
      path.lineTo(cx - iconWidth * 0.3, cy + iconHeight / 2);
      path.lineTo(cx + iconWidth * 0.5, cy);
      path.close();
    }

    canvas.drawPath(path, holePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
