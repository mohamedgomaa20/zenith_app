import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_manager/theme_manager_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 40),
            Text("Hello Mohamed Gomaa", style: TextStyle(fontSize: 35)),
            SizedBox(height: 40),
            BlocBuilder<ThemeManagerBloc, ThemeManagerState>(
              builder: (context, state) {
                return SwitchListTile(
                  value: state.themeMode == ThemeMode.dark,
                  onChanged: (_) {
                    context.read<ThemeManagerBloc>().add(ToggleThemeEvent());
                  },
                  title: Text("Dark Mode"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
