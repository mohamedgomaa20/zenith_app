import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../auth/presentation/auth_bloc/auth_bloc.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../main_app/MainScreen.dart';
import '../../../onboarding/presentation/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckAuthEvent());
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        Future.delayed(  Duration(seconds: 2), () {
          if (!mounted) return;

          switch (state.status) {
            case AuthStatus.onboardingRequired:
              _navigate(context,   OnboardingScreen());
              break;
            case AuthStatus.loginSuccess:
              _navigate(context,   MainScreen());
              break;
            case AuthStatus.initial:
            case AuthStatus.error:
              _navigate(context,   LoginScreen());
              break;
            default:
              break;
          }
        });
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Color(0xff3b0000), Color(0xff7a0000)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.movie, size: 80, color: Colors.white),
              SizedBox(height: 20),
              Text(
                "REELMATCH",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Your Movie Night Starts Here",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 20),
              LoadingAnimationWidget.horizontalRotatingDots(
                color: Colors.white,
                size: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
