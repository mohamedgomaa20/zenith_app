import 'package:dio/dio.dart';

import '../../services/movie_services.dart';
import '../models/movie_model.dart';

class MovieRepository {
  final MovieService _movieService;

  MovieRepository(this._movieService);

  /// Fetches popular movies and returns them as a clean list.
  /// This is what Cubit will call.
  Future<List<Movie>> fetchPopularMovies({int page = 1}) async {
    try {
      final response = await _movieService.getPopularMovies(page: page);
      return response.results;
    } catch (e) {
      // In a production app, you might return an 'Either' type or a Failure object here
      rethrow;
    }
  }

  Future<List<Movie>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    try {
      final response = await _movieService.searchMovies(
        query: query,
        page: page,
      );
      return response.results;
    } catch (e) {
      rethrow;
    }
  }
}
