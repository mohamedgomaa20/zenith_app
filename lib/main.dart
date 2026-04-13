import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenith_app/core/theme/app_theme.dart';
import 'package:zenith_app/core/theme/theme_manager/theme_manager_bloc.dart';
import 'package:zenith_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:zenith_app/features/auth/presentation/screens/register_screen.dart';
import 'package:zenith_app/features/home/presentation/screens/home_Screen.dart';

import 'core/services/preferences_manager.dart';
import 'features/auth/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesManager().init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeManagerBloc()..add(LoadThemeEvent()),
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
          home: LoginScreen(),
        );
      },
    );
  }
}
