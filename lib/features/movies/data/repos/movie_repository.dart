import 'package:dio/dio.dart';
import '../../../../core/errors/failure.dart';
import '../models/movie_model.dart';

abstract class MovieRepository {
  Future<List<Movie>> getPopularMovies({required int page});
  Future<List<Movie>> getTopRatedMovies({required int page});
  Future<List<Movie>> getNowPlayingMovies({required int page});
  Future<List<Movie>> searchMovies({required String query, int page = 1});
}

class MovieRepositoryImpl implements MovieRepository {
  final Dio _dio;
  MovieRepositoryImpl(this._dio);

  @override
  Future<List<Movie>> getPopularMovies({required int page}) =>
      _fetchFromEndpoint('/movie/popular', page);

  @override
  Future<List<Movie>> getTopRatedMovies({required int page}) =>
      _fetchFromEndpoint('/movie/top_rated', page);

  @override
  Future<List<Movie>> getNowPlayingMovies({required int page}) =>
      _fetchFromEndpoint('/movie/now_playing', page);

  @override
  Future<List<Movie>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        '/search/movie',
        queryParameters: {'query': query, 'page': page},
      );
      final List results = response.data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  Future<List<Movie>> _fetchFromEndpoint(String endpoint, int page) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: {'page': page},
      );

      // Debug: Print the data to see what the server actually sent
      print("API Response for $endpoint: ${response.data}");

      if (response.data != null && response.data['results'] != null) {
        final List results = response.data['results'];
        return results.map((json) => Movie.fromJson(json)).toList();
      }
      return []; // Return empty list instead of crashing if null
    } on DioException catch (e) {
      // Catching DioException specifically gives you more detail (status codes, etc)
      throw ServerFailure(e.response?.data['status_message'] ?? e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
