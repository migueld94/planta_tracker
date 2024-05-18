// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:geolocator/geolocator.dart';

// part 'gps_event.dart';
// part 'gps_state.dart';

// class GpsBloc extends Bloc<GpsEvent, GpsState> {
//   GpsBloc()
//       : super(
//             const GpsState(isGpsEnable: false, isGpsPermissionGranted: false)) {
//     on<GpsAndPermissionEvent>((event, emit) => emit(state.copyWith(
//         isGpsEnable: event.isGpsEnable,
//         isGpsPermissionGranted: event.isGpsPermissionGranted)));
//     _init();
//   }

//   Future<void> _init() async {
//     _checkGpsStatus();
//   }

//   Future<bool> _checkGpsStatus() async {
//     final isEnable = Geolocator.isLocationServiceEnabled();
//     Geolocator.getServiceStatusStream().listen((event) {
//       // ignore: unused_local_variable
//       final isEnable = (event.index == 1) ? true : false;
//     });
//     return isEnable;
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'gps_event.dart';
import 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  GpsBloc() : super(GpsInitial()) {
    on<GpsStarted>(_onStarted);
  }

  void _onStarted(GpsStarted event, Emitter<GpsState> emit) async {
    emit(GpsLoadInProgress());
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      emit(GpsPermissionDenied());
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        emit(GpsPermissionDeniedForever());
        return;
      }
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      emit(GpsPermissionGranted());
      try {
        Position position = await Geolocator.getCurrentPosition();
        emit(GpsLoadSuccess(position));
      } catch (_) {
        emit(GpsLoadFailure());
      }
    }
  }
}
