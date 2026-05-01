 import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenith_app/core/theme/app_theme.dart';
import 'package:zenith_app/core/theme/theme_manager/theme_manager_bloc.dart';
import 'package:zenith_app/features/favorite/presentation/favorites_bloc/favorites_bloc.dart';
import 'package:zenith_app/features/favorite/services/favorites_service.dart';
import 'package:zenith_app/features/profile/data/services/profile_service.dart';
import 'package:zenith_app/features/profile/presentation/profile_bloc/profile_bloc.dart';
import 'package:zenith_app/features/splash/presentation/screens/splash_screen.dart';
import 'core/api/tmdb_api_client.dart';
import 'core/services/preferences_manager.dart';
import 'features/auth/data/services/auth_service.dart';
import 'features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'features/home/presentation/blocs/game_bloc/game_bloc.dart';
import 'features/movies/data/repos/movie_repository.dart';
import 'features/movies/services/movie_services.dart';
import 'features/movies/ui/movie_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PreferencesManager().init();
  TmdbApiClient().init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeManagerBloc()..add(LoadThemeEvent()),
        ),
        BlocProvider(create: (_) => AuthBloc(AuthService())),
        BlocProvider(
          create: (_) =>
              FavoritesBloc(FavoritesService())..add(WatchFavoritesEvent()),
        ),
        BlocProvider(create: (_) => ProfileBloc(ProfileService())),
        BlocProvider(create: (_) => GameBloc()),
        BlocProvider(
          create: (context) => MovieCubit(MovieRepository(MovieService(TmdbApiClient().dio))),
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
          home: SplashScreen(),
        );
      },
    );
  }
}
