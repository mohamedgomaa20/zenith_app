import 'package:freezed_annotation/freezed_annotation.dart';

// to run the auto-generated files:
part 'movie_model.freezed.dart';
part 'movie_model.g.dart';
// use dart run build_runner build --delete-conflicting-outputs

@freezed
abstract class Movie with _$Movie {
  const factory Movie({
    required int id,
    required String title,
    required String overview,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'release_date') required String releaseDate,
  }) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}

@freezed
abstract class MovieResponse with _$MovieResponse {
  const factory MovieResponse({
    required int page,
    @JsonKey(name: 'results')
    required List<Movie>
    results, // Renamed to 'results' to match TMDB typical keys
    @JsonKey(name: 'total_pages') required int totalPages,
    @JsonKey(name: 'total_results') required int totalResults,
  }) = _MovieResponse;

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);
}

// Helper to handle TMDB's partial image paths
extension MovieX on Movie {
  String get fullPosterPath => 'https://image.tmdb.org/t/p/w500$posterPath';
}
