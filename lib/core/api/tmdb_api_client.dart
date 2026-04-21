import 'package:dio/dio.dart';

class TmdbApiClient {
  late final Dio dio;

  TmdbApiClient() {
    dio =
        Dio(
            BaseOptions(
              baseUrl: 'https://api.themoviedb.org/3/',
              connectTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 3),
            ),
          )
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) {
                // Automatically inject API key into every request
                options.queryParameters.addAll({
                  'api_key': 'c397a4384aab54b27dd969144acfcbc6',
                  'language': 'en-US',
                });
                return handler.next(options);
              },
              onError: (e, handler) {
                // Handle global errors like 401 Unauthorized or 429 Rate Limit
                if (e.response?.statusCode == 401) {
                  print('Invalid TMDB API Key');
                }
                return handler.next(e);
              },
            ),
          );
  }
}
