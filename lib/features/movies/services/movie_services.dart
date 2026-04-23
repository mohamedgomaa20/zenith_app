import 'package:dio/dio.dart';
import '../data/models/movie_model.dart';

class MovieService {
  final Dio _dio;

  MovieService(this._dio);

  Future<MovieResponse> getPopularMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        'movie/popular',
        queryParameters: {'page': page},
      );

      return MovieResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Re-throw so the Repository can handle the specific error message
      throw _handleDioError(e);
    }
  }

  Future<MovieResponse> searchMovies({required String query, int page = 1}) async {
    try {
      final response = await _dio.get(
        'search/movie',
        queryParameters: {
          'query': query,
          'page': page,
        },
      );
      return MovieResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timed out. Check your internet.";
      case DioExceptionType.badResponse:
        return "Server error: ${error.response?.statusCode}";
      default:
        return "Something went wrong. Please try again.";
    }
  }
}
