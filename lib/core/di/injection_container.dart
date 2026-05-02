import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/movies/data/repos/movie_repository.dart';
import '../../features/movies/presentation/search_cubit.dart';
import '../../features/movies/ui/movie_category_cubit.dart';
import '../services/preferences_manager.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // 1. External Services
  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  final prefsManager = PreferencesManager();
  await prefsManager.init(); // Ensure this internal init is also solid
  getIt.registerLazySingleton<PreferencesManager>(() => prefsManager);

  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: 'https://api.themoviedb.org/3',
        queryParameters: {'api_key': 'c397a4384aab54b27dd969144acfcbc6'},
      ),
    ),
  );

  // 2. Repositories
  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(getIt<Dio>()),
  );

  final repo = getIt<MovieRepository>();

  // 3. Category Cubits (Named Instances for the Home Screen Rows)
  getIt.registerFactory<MovieCategoryCubit>(
    () => MovieCategoryCubit(repo.getPopularMovies),
    instanceName: 'popular',
  );

  getIt.registerFactory<MovieCategoryCubit>(
    () => MovieCategoryCubit(repo.getTopRatedMovies),
    instanceName: 'topRated',
  );

  getIt.registerFactory<MovieCategoryCubit>(
    () => MovieCategoryCubit(repo.getNowPlayingMovies),
    instanceName: 'nowPlaying',
  );

  // 4. Search
  getIt.registerFactory(() => SearchCubit(repo));
}
