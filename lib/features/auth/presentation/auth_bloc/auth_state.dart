part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  onboardingRequired,
  loginSuccess,
  registerSuccess,
  forgotPasswordSuccess,
  googleSuccess,
  error,
}

class AuthState {
  final AuthStatus status;

  final bool loginLoading;
  final bool forgotPasswordLoading;
  final bool registerLoading;
  final bool googleLoading;

  final String? loginError;
  final String? registerError;
  final String? googleError;
  final String? forgotPasswordError;

  AuthState({
    this.status = AuthStatus.initial,
    this.loginLoading = false,
    this.forgotPasswordLoading = false,
    this.registerLoading = false,
    this.googleLoading = false,
    this.loginError,
    this.registerError,
    this.googleError,
    this.forgotPasswordError,
  });

  AuthState copyWith({
    AuthStatus? status,
    bool? loginLoading,
    bool? forgotPasswordLoading,
    bool? registerLoading,
    bool? googleLoading,
    String? loginError,
    String? registerError,
    String? googleError,
    String? forgotPasswordError,
  }) {
    return AuthState(
      status: status ?? this.status,
      loginLoading: loginLoading ?? this.loginLoading,
      forgotPasswordLoading:
          forgotPasswordLoading ?? this.forgotPasswordLoading,
      registerLoading: registerLoading ?? this.registerLoading,
      googleLoading: googleLoading ?? this.googleLoading,
      loginError: loginError ?? this.loginError,
      registerError: registerError ?? this.registerError,
      googleError: googleError ?? this.googleError,
      forgotPasswordError:
      forgotPasswordError ?? this.forgotPasswordError,
    );
  }
}
