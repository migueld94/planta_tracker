// part of 'gps_bloc.dart';

// sealed class GpsEvent extends Equatable {
//   const GpsEvent();

//   @override
//   List<Object> get props => [];
// }

// class GpsAndPermissionEvent extends GpsEvent {
//   final bool isGpsEnable;
//   final bool isGpsPermissionGranted;

//   const GpsAndPermissionEvent(
//       {required this.isGpsEnable, required this.isGpsPermissionGranted});
// }

abstract class GpsEvent {}

class GpsStarted extends GpsEvent {}
