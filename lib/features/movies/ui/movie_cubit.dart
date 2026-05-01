import 'package:bloc/bloc.dart';

import '../data/models/movie_model.dart';
import '../data/repos/movie_repository.dart';
import 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  final MovieRepository _repository;
  int _currentPage = 1;
  bool _hasReachedMax = false;
  bool _isLoadingMore = false; // Added to prevent duplicate API calls

  MovieCubit(this._repository) : super(const MovieState.initial());

  Future<void> getPopularMovies() async {
    _currentPage = 1;
    _hasReachedMax = false;
    emit(const MovieState.loading());
    try {
      final movies = await _repository.fetchPopularMovies(page: _currentPage);
      _hasReachedMax = movies.length < 20;
      emit(MovieState.success(movies, _hasReachedMax));
    } catch (e) {
      emit(MovieState.error(e.toString()));
    }
  }

  Future<void> loadMoreMovies() async {
    // 1. Guard clauses
    if (_hasReachedMax || _isLoadingMore) return;

    // 2. Extract current movies safely using maybeWhen
    final currentMovies = state.maybeWhen(
      success: (movies, hasReachedMax) => movies,
      orElse: () => <Movie>[],
    );

    if (currentMovies.isEmpty) return;

    _isLoadingMore = true;
    try {
      _currentPage++;
      final newMovies = await _repository.fetchPopularMovies(
        page: _currentPage,
      );

      _hasReachedMax = newMovies.isEmpty || newMovies.length < 20;

      emit(
        MovieState.success([...currentMovies, ...newMovies], _hasReachedMax),
      );
    } catch (e) {
      _currentPage--;
      // Optionally emit error or just stop loading
    } finally {
      _isLoadingMore = false;
    }
  }
}
