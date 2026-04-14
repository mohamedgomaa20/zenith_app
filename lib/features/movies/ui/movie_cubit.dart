import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repos/movie_repository.dart';
import 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  final MovieRepository _repository;

  MovieCubit(this._repository) : super(const MovieState.initial());

  Future<void> getPopularMovies() async {
    emit(const MovieState.loading());
    try {
      final movies = await _repository.fetchPopularMovies();
      emit(MovieState.success(movies));
    } catch (e) {
      emit(MovieState.error(e.toString()));
    }
  }
}
