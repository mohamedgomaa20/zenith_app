import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../data/models/user_data_class.dart';
import '../../data/services/auth_service.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthState()) {
    on<CheckAuthEvent>(_onCheckAuth);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<GoogleLoginEvent>(_onGoogleSignIn);
    on<LogoutEvent>(_onLogout);
  }

  FutureOr<void> _onLogout(event, emit) async {
    await authService.logout();
    emit(AuthState());
  }

  FutureOr<void> _onGoogleSignIn(event, emit) async {
    emit(state.copyWith(googleLoading: true, googleError: null));
    try {
      await authService.loginWithGoogle();
      emit(
        state.copyWith(googleLoading: false, status: AuthStatus.googleSuccess),
      );
    } catch (e) {
      print("------------------>${e.toString()}");
      emit(
        state.copyWith(
          googleLoading: false,
          status: AuthStatus.error,
          googleError: "Google sign in failed ${e.toString()}",
        ),
      );
    }
  }

  FutureOr<void> _onForgotPassword(event, emit) async {
    emit(
      state.copyWith(forgotPasswordLoading: true, forgotPasswordError: null),
    );
    try {
      await authService.forgotPassword(event.email);
      emit(
        state.copyWith(
          forgotPasswordLoading: false,
          status: AuthStatus.forgotPasswordSuccess,
        ),
      );
    } on FirebaseAuthException catch (e) {
      print("------------------>${e.toString()}");
      emit(
        state.copyWith(
          forgotPasswordLoading: false,
          status: AuthStatus.error,
          forgotPasswordError: _handleAuthException(e),
        ),
      );
    } catch (e) {
      print("---------------->${e.toString()}");
      emit(
        state.copyWith(
          forgotPasswordLoading: false,
          status: AuthStatus.error,
          forgotPasswordError: "An unexpected error occurred: ${e.toString()}",
        ),
      );
    }
  }

  FutureOr<void> _onRegister(event, emit) async {
    emit(state.copyWith(registerLoading: true, registerError: null));
    try {
      await authService.register(event.user);
      emit(
        state.copyWith(
          registerLoading: false,
          status: AuthStatus.registerSuccess,
        ),
      );
    } on FirebaseAuthException catch (e) {
      print("------------------>${e.toString()}");
      emit(
        state.copyWith(
          registerLoading: false,
          status: AuthStatus.error,
          registerError: _handleAuthException(e),
        ),
      );
    } catch (e) {
      print("---------------->${e.toString()}");
      emit(
        state.copyWith(
          registerLoading: false,
          status: AuthStatus.error,
          registerError: "An unexpected error occurred: ${e.toString()}",
        ),
      );
    }
  }

  FutureOr<void> _onLogin(event, emit) async {
    emit(state.copyWith(loginLoading: true, loginError: null));
    try {
      await authService.login(event.user);
      emit(
        state.copyWith(loginLoading: false, status: AuthStatus.loginSuccess),
      );
    } on FirebaseAuthException catch (e) {
      print("------------------>${e.toString()}");
      emit(
        state.copyWith(
          loginLoading: false,
          status: AuthStatus.error,
          loginError: _handleAuthException(e),
        ),
      );
    } catch (e) {
      print("---------------->${e.toString()}");
      emit(
        state.copyWith(
          loginLoading: false,
          status: AuthStatus.error,
          loginError: "An unexpected error occurred: ${e.toString()}",
        ),
      );
    }
  }

  Future<void> _onCheckAuth(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final bool onboardingSeen =
          prefs.getBool(AppConstants.kOnboardingSeen) ?? false;

      if (!onboardingSeen) {
        emit(state.copyWith(status: AuthStatus.onboardingRequired));
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        emit(state.copyWith(status: AuthStatus.loginSuccess));
      } else {
        emit(state.copyWith(status: AuthStatus.initial));
      }
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'Operation not allowed. Please contact support.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
