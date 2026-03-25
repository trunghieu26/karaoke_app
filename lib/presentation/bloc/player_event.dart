abstract class PlayerEvent {}

class InitPlayer extends PlayerEvent {}

class TogglePlay extends PlayerEvent {}

class SeekTo extends PlayerEvent {
  final Duration position;
  SeekTo(this.position);
}

class PositionChanged extends PlayerEvent {
  final Duration position;
  PositionChanged(this.position);
}