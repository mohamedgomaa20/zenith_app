import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/movies/data/models/movie_model.dart';

class CacheService {
  final SharedPreferences _prefs;
  CacheService(this._prefs);

  static const String _popularKey = 'cached_popular';
  static const String _topRatedKey = 'cached_top_rated';
  static const String _nowPlayingKey = 'cached_now_playing';

  Future<void> cacheMovies(String key, List<Movie> movies) async {
    final String jsonString = jsonEncode(
      movies.map((e) => e.toJson()).toList(),
    );
    await _prefs.setString(key, jsonString);
  }

  List<Movie> getCachedMovies(String key) {
    final String? jsonString = _prefs.getString(key);
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      return decoded.map((item) => Movie.fromJson(item)).toList();
    }
    return [];
  }
}
