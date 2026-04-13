part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final UserDataClass user;

  LoginEvent(this.user);
}

class RegisterEvent extends AuthEvent {
  final UserDataClass user;

  RegisterEvent(this.user);
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent(this.email);
}

class GoogleLoginEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
