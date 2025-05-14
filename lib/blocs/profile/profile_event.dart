import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchProfile extends ProfileEvent {
  const FetchProfile();
}

class BusinessEventCheckForUpdates extends ProfileEvent {
  const BusinessEventCheckForUpdates();
}

class ProfileInvalidateCache extends ProfileEvent {
  const ProfileInvalidateCache();
}
