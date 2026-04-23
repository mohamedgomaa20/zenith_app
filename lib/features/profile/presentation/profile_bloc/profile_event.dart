part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class FetchProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String? name;
  final String? photoUrl;

  UpdateProfileEvent({this.name, this.photoUrl});
}

class ChangePasswordEvent extends ProfileEvent {
  final String newPassword;

  ChangePasswordEvent(this.newPassword);
}

class ReAuthenticateEvent extends ProfileEvent {
  final String oldPassword;
  final String newPassword;

  ReAuthenticateEvent({required this.oldPassword, required this.newPassword});
}
