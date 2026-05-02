import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenith_app/core/di/injection_container.dart'; // Import getIt and init from here
import 'package:zenith_app/firebase_options.dart';

// Import Blocs/Cubits
import 'core/theme/app_theme.dart';
import 'core/theme/theme_manager/theme_manager_bloc.dart';
import 'features/auth/data/services/auth_service.dart';
import 'features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'features/favorite/presentation/favorites_bloc/favorites_bloc.dart';
import 'features/favorite/services/favorites_service.dart';
import 'features/home/presentation/blocs/game_bloc/game_bloc.dart';
import 'features/movies/presentation/search_cubit.dart';
import 'features/movies/ui/movie_category_cubit.dart';
import 'features/profile/data/services/profile_service.dart';
import 'features/profile/presentation/profile_bloc/profile_bloc.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase and Dependency Injection
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();

  runApp(
    MultiBlocProvider(
      providers: [
        // Theme & Auth
        BlocProvider(
          create: (context) => ThemeManagerBloc()..add(LoadThemeEvent()),
        ),
        BlocProvider(create: (_) => AuthBloc(AuthService())),

        // Features
        BlocProvider(
          create: (_) =>
              FavoritesBloc(FavoritesService())..add(WatchFavoritesEvent()),
        ),
        BlocProvider(create: (_) => ProfileBloc(ProfileService())),
        BlocProvider(create: (_) => GameBloc()),

        // Movie Search
        BlocProvider(create: (_) => getIt<SearchCubit>()),

        // Movie Categories (Netflix Rows)
        BlocProvider(
          create: (_) =>
              getIt<MovieCategoryCubit>(instanceName: 'popular')..loadMovies(),
        ),
        BlocProvider(
          create: (_) =>
              getIt<MovieCategoryCubit>(instanceName: 'topRated')..loadMovies(),
        ),
        BlocProvider(
          create: (_) =>
              getIt<MovieCategoryCubit>(instanceName: 'nowPlaying')
                ..loadMovies(),
        ),
      ],
      child: const ZenithApp(),
    ),
  );
}

class ZenithApp extends StatelessWidget {
  const ZenithApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeManagerBloc, ThemeManagerState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
