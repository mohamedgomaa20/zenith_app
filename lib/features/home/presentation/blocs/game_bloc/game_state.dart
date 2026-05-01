part of 'game_bloc.dart';

enum GameStatus { idle, loading, waiting, swiping, matched, error }

class GameState extends Equatable {
  final GameStatus status;
  final String myId;
  final String myName;
  final String roomCode;
  final GameRoom? gameRoom;
  final List<Movie> movies;
  final int currentIndex;
  final Movie? matchedMovie;
  final String? error;

  const GameState({
    this.status = GameStatus.idle,
    this.myId = '',
    this.myName = '',
    this.roomCode = '',
    this.gameRoom,
    this.movies = const [],
    this.currentIndex = 0,
    this.matchedMovie,
    this.error,
  });

  Movie? get currentMovie =>
      currentIndex < movies.length ? movies[currentIndex] : null;

  GameState copyWith({
    GameStatus? status,
    String? myId,
    String? myName,
    String? roomCode,
    GameRoom? gameRoom,
    List<Movie>? movies,
    int? currentIndex,
    Movie? matchedMovie,
    String? error,
  }) {
    return GameState(
      status: status ?? this.status,
      myId: myId ?? this.myId,
      myName: myName ?? this.myName,
      roomCode: roomCode ?? this.roomCode,
      gameRoom: gameRoom ?? this.gameRoom,
      movies: movies ?? this.movies,
      currentIndex: currentIndex ?? this.currentIndex,
      matchedMovie: matchedMovie ?? this.matchedMovie,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        myId,
        myName,
        roomCode,
        gameRoom,
        movies,
        currentIndex,
        matchedMovie,
        error,
      ];
}
