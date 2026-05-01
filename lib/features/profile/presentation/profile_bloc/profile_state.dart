part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, loaded, updated, error }

class ProfileState {
  final ProfileStatus status;
  final UserProfileModel? user;
  final String? errorMessage;

  ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfileModel? user,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
