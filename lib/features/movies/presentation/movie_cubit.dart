import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
 import '../data/models/movie_model.dart';
import '../data/repos/movie_repository.dart';
import 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  final MovieRepository _repository;
  List<Movie> _cachedPopularMovies = [];
  Timer? _debounceTimer;
  MovieCubit(this._repository) : super(const MovieState.initial());

  Future<void> getPopularMovies() async {
    emit(const MovieState.loading());
    try {
      final movies = await _repository.fetchPopularMovies();
      _cachedPopularMovies = movies;
      emit(MovieState.success(movies));
    } catch (e) {
      emit(MovieState.error(e.toString()));
    }
  }

  Future<void> searchMovies(String query) async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      emit(const MovieState.loading());
      try {
        final movies = await _repository.searchMovies(query);
        emit(MovieState.success(movies));
      } catch (e) {
        emit(MovieState.error(e.toString()));
      }
    });
  }
  void clearSearch() {
    _debounceTimer?.cancel();
    if (_cachedPopularMovies.isNotEmpty) {
      emit(MovieState.success(_cachedPopularMovies));
    } else {
      getPopularMovies();
    }
  }
  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
