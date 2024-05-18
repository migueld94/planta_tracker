// part of 'gps_bloc.dart';

// class GpsState extends Equatable {
//   final bool isGpsEnable;
//   final bool isGpsPermissionGranted;
//   const GpsState(
//       {required this.isGpsEnable, required this.isGpsPermissionGranted});

//   GpsState copyWith({
//     bool? isGpsEnable,
//     bool? isGpsPermissionGranted,
//   }) =>
//       GpsState(
//           isGpsEnable: isGpsEnable ?? this.isGpsEnable,
//           isGpsPermissionGranted:
//               isGpsPermissionGranted ?? this.isGpsPermissionGranted);
//   @override
//   List<Object> get props => [isGpsEnable, isGpsPermissionGranted];
// }

import 'package:geolocator/geolocator.dart';

abstract class GpsState {}

class GpsInitial extends GpsState {}

class GpsPermissionDenied extends GpsState {}

class GpsPermissionDeniedForever extends GpsState {}

class GpsPermissionGranted extends GpsState {}

class GpsLoadInProgress extends GpsState {}

class GpsLoadSuccess extends GpsState {
  final Position position;
  GpsLoadSuccess(this.position);
}

class GpsLoadFailure extends GpsState {}
