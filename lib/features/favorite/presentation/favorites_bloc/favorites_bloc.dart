import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../movies/data/models/movie_model.dart';
import '../../services/favorites_service.dart';

part 'favorites_event.dart';

part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesService favoritesService;

  FavoritesBloc(this.favoritesService) : super(FavoritesState()) {
    on<WatchFavoritesEvent>(_onWatchFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onWatchFavorites(WatchFavoritesEvent event, emit) async {
    emit(state.copyWith(status: FavoritesStatus.loading));

    await emit.forEach<List<Movie>>(
      favoritesService.getFavoritesStream(),
      onData: (movies) {
        return state.copyWith(
          status: FavoritesStatus.loaded,
          favorites: movies,
        );
      },
      onError: (error, stackTrace) {
        return state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: error.toString(),
        );
      },
    );
  }

  Future<void> _onToggleFavorite(ToggleFavoriteEvent event, emit) async {
    final id = event.movie.id;

    emit(state.copyWith(addProcessingId: id));

    try {
      await favoritesService.toggleFavorite(event.movie);

      emit(state.copyWith(removeProcessingId: id));

    } catch (e) {
      emit(
        state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: e.toString(),
          removeProcessingId: id,
        ),
      );
    }
  }}
