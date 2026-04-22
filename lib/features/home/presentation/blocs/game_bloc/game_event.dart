part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class SetIdentity extends GameEvent {
  final String name;
  const SetIdentity(this.name);

  @override
  List<Object?> get props => [name];
}

class CreateRoom extends GameEvent {}

class JoinRoom extends GameEvent {
  final String code;
  const JoinRoom(this.code);

  @override
  List<Object?> get props => [code];
}

class StartGame extends GameEvent {}

class SwipeMovie extends GameEvent {
  final bool liked;
  const SwipeMovie(this.liked);

  @override
  List<Object?> get props => [liked];
}

class RoomUpdated extends GameEvent {
  final GameRoom room;
  const RoomUpdated(this.room);

  @override
  List<Object?> get props => [room];
}

class PlayAgain extends GameEvent {}

class LeaveRoom extends GameEvent {}
