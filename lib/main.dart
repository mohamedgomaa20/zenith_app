import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenith_app/core/theme/app_theme.dart';
import 'package:zenith_app/core/theme/theme_manager/theme_manager_bloc.dart';

import 'core/services/preferences_manager.dart';
import 'features/auth/data/services/auth_service.dart';
import 'features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PreferencesManager().init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeManagerBloc()..add(LoadThemeEvent()),
        ),
        BlocProvider(create: (_) => AuthBloc(AuthService())),
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
          home: LoginScreen(),
        );
      },
    );
  }
}
