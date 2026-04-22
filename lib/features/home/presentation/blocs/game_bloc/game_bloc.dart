import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/movie.dart';
import '../../../data/models/room.dart';
import '../../../data/services/tmdb_service.dart';
import '../../../data/services/room_service.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final TmdbService _tmdb = TmdbService();
  final RoomService _room = RoomService();
  StreamSubscription<GameRoom>? _roomSub;

  GameBloc() : super(const GameState()) {
    on<SetIdentity>(_onSetIdentity);
    on<CreateRoom>(_onCreateRoom);
    on<JoinRoom>(_onJoinRoom);
    on<StartGame>(_onStartGame);
    on<SwipeMovie>(_onSwipeMovie);
    on<RoomUpdated>(_onRoomUpdated);
    on<PlayAgain>(_onPlayAgain);
    on<LeaveRoom>(_onLeaveRoom);
  }

  void _onSetIdentity(SetIdentity event, Emitter<GameState> emit) {
    final myId = '${event.name}_${DateTime.now().millisecondsSinceEpoch}';
    emit(state.copyWith(myName: event.name, myId: myId));
  }

  Future<void> _onCreateRoom(CreateRoom event, Emitter<GameState> emit) async {
    emit(state.copyWith(status: GameStatus.loading));
    try {
      final roomCode = await _room.createRoom(hostId: state.myId, hostName: state.myName);
      final movies = await _tmdb.fetchSwipeQueue(pages: 2);
      emit(state.copyWith(
        status: GameStatus.waiting,
        roomCode: roomCode,
        movies: movies,
        currentIndex: 0,
      ));
      _subscribeToRoom(roomCode);
    } catch (e) {
      emit(state.copyWith(status: GameStatus.error, error: 'Failed to create room: $e'));
    }
  }

  Future<void> _onJoinRoom(JoinRoom event, Emitter<GameState> emit) async {
    emit(state.copyWith(status: GameStatus.loading));
    final code = event.code.toUpperCase();
    final exists = await _room.roomExists(code);
    if (!exists) {
      emit(state.copyWith(status: GameStatus.error, error: 'Invalid code, room not found'));
      return;
    }
    try {
      await _room.joinRoom(code: code, memberId: state.myId, memberName: state.myName);
      final movies = await _tmdb.fetchSwipeQueue(pages: 2);
      emit(state.copyWith(
        status: GameStatus.waiting,
        roomCode: code,
        movies: movies,
        currentIndex: 0,
      ));
      _subscribeToRoom(code);
    } catch (e) {
      emit(state.copyWith(status: GameStatus.error, error: 'Failed to join: $e'));
    }
  }

  Future<void> _onStartGame(StartGame event, Emitter<GameState> emit) async {
    await _room.startGame(state.roomCode);
  }

  Future<void> _onSwipeMovie(SwipeMovie event, Emitter<GameState> emit) async {
    final movie = state.currentMovie;
    if (movie == null) return;

    await _room.submitVote(
      roomCode: state.roomCode,
      memberId: state.myId,
      movieId: movie.id,
      liked: event.liked,
    );

    int newIndex = state.currentIndex + 1;
    List<Movie> currentMovies = List.from(state.movies);

    if (newIndex >= currentMovies.length - 5) {
      final more = await _tmdb.fetchSwipeQueue(pages: 1);
      final existingIds = currentMovies.map((m) => m.id).toSet();
      currentMovies.addAll(more.where((m) => !existingIds.contains(m.id)));
    }

    emit(state.copyWith(currentIndex: newIndex, movies: currentMovies));
  }

  void _onRoomUpdated(RoomUpdated event, Emitter<GameState> emit) {
    final room = event.room;
    GameStatus newStatus = state.status;

    if (room.status == 'swiping' && state.status == GameStatus.waiting) {
      newStatus = GameStatus.swiping;
    }

    Movie? matchedMovie = state.matchedMovie;
    if (room.status == 'matched' && room.matchedMovieId != null) {
      matchedMovie = state.movies.firstWhere(
        (m) => m.id == room.matchedMovieId,
        orElse: () => state.movies.first,
      );
      newStatus = GameStatus.matched;
    } else {
      
      final matchId = room.checkForMatch();
      if (matchId != null && state.status == GameStatus.swiping) {
        _room.setMatch(state.roomCode, matchId);
      }
    }

    emit(state.copyWith(gameRoom: room, status: newStatus, matchedMovie: matchedMovie));
  }

  Future<void> _onPlayAgain(PlayAgain event, Emitter<GameState> emit) async {
    emit(state.copyWith(status: GameStatus.loading));
    await _room.resetRoom(state.roomCode);
    final movies = await _tmdb.fetchSwipeQueue(pages: 2);
    emit(state.copyWith(
      status: GameStatus.swiping,
      movies: movies,
      currentIndex: 0,
      matchedMovie: null,
    ));
  }

  Future<void> _onLeaveRoom(LeaveRoom event, Emitter<GameState> emit) async {
    await _room.leaveRoom(state.roomCode, state.myId);
    _roomSub?.cancel();
    emit(const GameState()); 
  }

  void _subscribeToRoom(String code) {
    _roomSub?.cancel();
    _roomSub = _room.watchRoom(code).listen((room) {
      add(RoomUpdated(room));
    });
  }

  @override
  Future<void> close() {
    _roomSub?.cancel();
    return super.close();
  }
}
