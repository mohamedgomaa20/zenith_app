import 'package:dio/dio.dart';

class TmdbApiClient {
  // 1. Private constructor to prevent direct instantiation
  TmdbApiClient._internal();

  // 2. The single shared instance of the client
  static final TmdbApiClient _instance = TmdbApiClient._internal();

  // 3. Factory constructor to access the instance
  factory TmdbApiClient() => _instance;

  // Use 'late' because it will be initialized in the init() method
  late final Dio dio;

  /// Initializes the Dio instance with base options and interceptors.
  /// This should be called in main() before the app starts.
  void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.themoviedb.org/3/',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {
          'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMzk3YTQzODRhYWI1NGIyN2RkOTY5MTQ0YWNmY2JjNiIsIm5iZiI6MTc3NjIwMzQwNC41NTAwMDAyLCJzdWIiOiI2OWRlYjY4YzZiMDE3NGRiOTIxZGE5YzciLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.glUCeuC1t2tXMIaDt8kelxKLLhDbbLyzMh4aI902UPQ',
          'accept': 'application/json',
        },
      ),
    )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Automatically inject API key and language into every request
          options.queryParameters.addAll({
            'api_key': 'c397a4384aab54b27dd969144acfcbc6',
            'language': 'en-US',
          });
          return handler.next(options);
        },
        onError: (e, handler) {
          // Centralized error handling for common API issues
          if (e.response?.statusCode == 401) {
            print('TMDB API Error: Invalid API Key or Token');
          } else if (e.response?.statusCode == 429) {
            print('TMDB API Error: Rate limit exceeded');
          }
          return handler.next(e);
        },
      ),
    );
  }
}