import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:zenith_app/core/constants/app_constants.dart';

import '../../services/preferences_manager.dart';

part 'theme_manager_event.dart';

part 'theme_manager_state.dart';

class ThemeManagerBloc extends Bloc<ThemeManagerEvent, ThemeManagerState> {
  final _pref = PreferencesManager();

  ThemeManagerBloc() : super(ThemeManagerState(ThemeMode.light)) {
    on<LoadThemeEvent>((event, emit) {
      final isDarkMode = _pref.getBool(AppConstants.themeKey) ?? false;
      emit(ThemeManagerState(isDarkMode ? ThemeMode.dark : ThemeMode.light));
    });

    on<ToggleThemeEvent>((event, emit) async {
      final isDarkMode = state.themeMode == ThemeMode.dark;
      final newThemeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;

      await _pref.setBool(
        AppConstants.themeKey,
        newThemeMode == ThemeMode.dark,
      );
      emit(ThemeManagerState(newThemeMode));
    });
  }
}
