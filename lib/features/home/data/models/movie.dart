

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double rating;
  final String releaseDate;
  final List<String> genres;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.rating,
    required this.releaseDate,
    required this.genres,
  });

  String get year => releaseDate.length >= 4 ? releaseDate.substring(0, 4) : '';
  String get posterUrl => 'https://image.tmdb.org/t/p/w500$posterPath';
  String get backdropUrl => 'https://image.tmdb.org/t/p/w1280$backdropPath';
  String get ratingFormatted => rating.toStringAsFixed(1);

  factory Movie.fromJson(Map<String, dynamic> json, Map<int, String> genreMap) {
    final genreIds = (json['genre_ids'] as List<dynamic>? ?? []).cast<int>();
    return Movie(
      id:           json['id'] as int,
      title:        json['title'] as String? ?? '',
      overview:     json['overview'] as String? ?? '',
      posterPath:   json['poster_path'] as String? ?? '',
      backdropPath: json['backdrop_path'] as String? ?? '',
      rating:       (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate:  json['release_date'] as String? ?? '',
      genres:       genreIds.map((id) => genreMap[id] ?? '').where((g) => g.isNotEmpty).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id':           id,
    'title':        title,
    'overview':     overview,
    'posterPath':   posterPath,
    'backdropPath': backdropPath,
    'rating':       rating,
    'releaseDate':  releaseDate,
    'genres':       genres,
  };
}
