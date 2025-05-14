import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planta_tracker/models/user_models.dart';
import 'package:planta_tracker/services/user_services.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserServices userServices;
  User? _cachedProfile;

  ProfileBloc({required this.userServices}) : super(ProfileInitial()) {
    on<FetchProfile>(_onFetchProfile);
    on<BusinessEventCheckForUpdates>(_onCheckForUpdates);
    on<ProfileInvalidateCache>(_onInvalidateCacheProfile);
  }

  void _onFetchProfile(FetchProfile event, Emitter<ProfileState> emit) async {
    if (_cachedProfile != null) {
      emit(ProfileLoaded(profile: _cachedProfile!));
    } else {
      emit(ProfileLoading());
      try {
        final profile = await userServices.getUserDetails();
        _cachedProfile = profile;
        emit(ProfileLoaded(profile: profile));
      } catch (e) {
        emit(ProfileError(message: e.toString()));
      }
    }
  }

  void _onCheckForUpdates(
    BusinessEventCheckForUpdates event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final profile = await userServices.getUserDetails();
      _cachedProfile = profile;
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  void _onInvalidateCacheProfile(
    ProfileInvalidateCache event,
    Emitter<ProfileState> emit,
  ) {
    _cachedProfile = null;
  }
}
