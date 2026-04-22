import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenith_app/core/theme/app_theme.dart';
import 'package:zenith_app/core/theme/theme_manager/theme_manager_bloc.dart';
import 'package:zenith_app/features/splash/presentation/screens/splash_screen.dart';
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
  final dio = Dio(
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
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeManagerBloc()..add(LoadThemeEvent()),
        ),
        BlocProvider(create: (_) => AuthBloc(AuthService())),
        BlocProvider(
          create: (_) => MovieCubit(MovieRepository(MovieService(dio))),
        ),
        BlocProvider(create: (_) => GameBloc()),
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
