import 'package:bloc/bloc.dart';

import '../../domain/usecases/get_lyrics.dart';
import '../../services/audio_service.dart';
import 'player_event.dart';
import 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final AudioService audio;
  final GetLyrics getLyrics;

  PlayerBloc(this.audio, this.getLyrics)
    : super(
        PlayerState(
          isPlaying: false,
          position: Duration.zero,
          duration: Duration.zero,
          lyrics: [],
        ),
      ) {
    on<InitPlayer>(_init);
    on<TogglePlay>(_toggle);
    on<SeekTo>(_seek);
    on<PositionChanged>(_positionChanged);
  }

  Future<void> _init(InitPlayer event, Emitter<PlayerState> emit) async {
    await audio.init();

    final lyrics = await getLyrics();

    audio.position.listen((pos) {
      add(PositionChanged(pos));
    });
    emit(
      state.copyWith(lyrics: lyrics, duration: audio.duration ?? Duration.zero),
    );
  }

  void _toggle(TogglePlay event, Emitter<PlayerState> emit) {
    if (audio.isPlaying) {
      audio.pause();
    } else {
      audio.play();
    }

    emit(state.copyWith(isPlaying: !state.isPlaying));
  }

  void _seek(SeekTo event, Emitter<PlayerState> emit) {
    audio.seek(event.position);
  }

  void _positionChanged(PositionChanged event, Emitter<PlayerState> emit) {
    emit(state.copyWith(position: event.position));
  }
}
