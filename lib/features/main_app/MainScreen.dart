import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenith_app/features/favorite/presentation/screens/favorite_Screen.dart';
import 'package:zenith_app/features/home/presentation/screens/lobby_screen.dart';
import 'package:zenith_app/features/movies/presentation/screens/search_screen.dart';
import 'package:zenith_app/features/movies/ui/screens/movie_screen.dart';

import 'package:zenith_app/features/profile/presentation/screens/profile_screen.dart';

import '../auth/presentation/auth_bloc/auth_bloc.dart';
import '../auth/presentation/screens/login_screen.dart';
import '../profile/presentation/profile_bloc/profile_bloc.dart';
import '../search/presentation/screens/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    LobbyScreen(),
    FavoriteScreen(),
    MoviesScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(FetchProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.initial) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: "Favorite",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.movie_creation_outlined),
                label: "Explore",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
