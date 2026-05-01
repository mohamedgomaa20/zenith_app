

import 'package:zenith_app/core/api/tmdb_api_client.dart';
import '../models/movie.dart';

class TmdbService {
  final TmdbApiClient _client = TmdbApiClient();

  Future<Map<int, String>> _fetchGenres() async {
    try {
      final response = await _client.dio.get('genre/movie/list');
      final genres = response.data['genres'] as List<dynamic>? ?? [];
      return {
        for (final g in genres) (g['id'] as int): (g['name'] as String),
      };
    } catch (_) {
      return {};
    }
  }

  Future<List<Movie>> fetchSwipeQueue({int pages = 2}) async {
    final genreMap = await _fetchGenres();
    final allMovies = <Movie>[];

    for (int page = 1; page <= pages; page++) {
      try {
        final response = await _client.dio.get(
          'movie/popular',
          queryParameters: {'page': page},
        );
        final results = response.data['results'] as List<dynamic>? ?? [];
        final movies = results
            .map((json) => Movie.fromJson(
                  Map<String, dynamic>.from(json as Map),
                  genreMap,
                ))
            .where((m) => m.posterPath.isNotEmpty && m.backdropPath.isNotEmpty)
            .toList();
        allMovies.addAll(movies);
      } catch (e) {
        
        continue;
      }
    }

    return allMovies;
  }
}
