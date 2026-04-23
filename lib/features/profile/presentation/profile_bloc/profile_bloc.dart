import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../data/models/user_profile_model.dart';
import '../../data/services/profile_service.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService profileService;

  ProfileBloc(this.profileService) : super(ProfileState()) {
    on<FetchProfileEvent>(_onFetchProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<ChangePasswordEvent>(_onChangePassword);
    on<ReAuthenticateEvent>(_onReAuthenticate);
  }

  Future<void> _onUpdateProfile(UpdateProfileEvent event, emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await profileService.updateUserData(event.name, event.photoUrl);
      add(FetchProfileEvent());
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onFetchProfile(FetchProfileEvent event, emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final user = await profileService.getUserProfile();
      emit(state.copyWith(status: ProfileStatus.loaded, user: user));
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await profileService.updatePassword(event.newPassword);
      emit(state.copyWith(status: ProfileStatus.updated));
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onReAuthenticate(ReAuthenticateEvent event, emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await profileService.reAuthenticate(event.oldPassword);
      await profileService.updatePassword(event.newPassword);

      emit(state.copyWith(status: ProfileStatus.updated));
    } on FirebaseAuthException catch (e) {
      final errorMessage = _mapFirebaseAuthError(e);
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: errorMessage));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, errorMessage: "An unexpected error occurred. Please try again."));
    }
  }
  }
  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'wrong-password':
      case 'invalid-credential':
        return "The current password you entered is incorrect.";
      case 'too-many-requests':
        return "Too many failed attempts. This device is temporarily blocked. Please try again later.";
      case 'user-disabled':
        return "This account has been disabled. Please contact support.";
      case 'user-not-found':
        return "No user found with this credentials.";
      case 'network-request-failed':
        return "Network error. Please check your internet connection.";
      case 'requires-recent-login':
        return "This operation is sensitive and requires recent authentication. Please log in again.";
      default:
        return e.message ?? "Authentication failed. Please try again.";
    }
}
