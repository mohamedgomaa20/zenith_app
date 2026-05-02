import 'package:bloc/bloc.dart';

import '../data/models/movie_model.dart';
import 'movie_state.dart';

class MovieCategoryCubit extends Cubit<MovieState> {
  final Future<List<Movie>> Function({required int page}) _fetchAction;

  int _currentPage = 1;
  bool _hasReachedMax = false;
  bool _isLoadingMore = false;

  MovieCategoryCubit(this._fetchAction) : super(const MovieState.initial());

  Future<void> loadMovies({bool isRefresh = false}) async {
    if (_isLoadingMore || (_hasReachedMax && !isRefresh)) return;

    if (isRefresh) {
      _currentPage = 1;
      _hasReachedMax = false;
    }

    // Show full loading only on the first page
    if (_currentPage == 1) emit(const MovieState.loading());

    _isLoadingMore = true;
    try {
      // Execute the injected repository method
      final newMovies = await _fetchAction(page: _currentPage);

      final currentMovies = state.maybeWhen(
        success: (movies, _) => isRefresh ? <Movie>[] : movies,
        orElse: () => <Movie>[],
      );

      _hasReachedMax = newMovies.length < 20;
      _currentPage++;

      emit(
        MovieState.success([...currentMovies, ...newMovies], _hasReachedMax),
      );
    } catch (e) {
      emit(MovieState.error(e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }
}
