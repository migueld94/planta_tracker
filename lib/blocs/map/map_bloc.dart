import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial()) {
    on<MapStarted>(_onStarted);
  }

  Future<void> _onStarted(MapStarted event, Emitter<MapState> emit) async {
    emit(MapLoadInProgress());
    // Aquí iría la lógica para cargar el mapa
    // Por ejemplo, podrías usar la ubicación del GpsBloc para centrar el mapa
    // emit(MapLoadSuccess(new LatLng(ubicacion.latitude, ubicacion.longitude)));
    try {
      Position position = await Geolocator.getCurrentPosition();
      emit(MapLoadSuccess(LatLng(position.latitude, position.longitude)));
    } on SocketException {
      Get.rawSnackbar(
        messageText: AutoSizeText(
          'Please Connect to the internet',
          style: TextStyle(
            color: PlantaColors.colorWhite,
            fontSize: 14.0,
            fontFamily: 'Nunito',
          ),
        ),
        isDismissible: false,
        duration: const Duration(days: 1),
        backgroundColor: PlantaColors.colorRed,
        icon: Icon(Ionicons.wifi_outline, color: PlantaColors.colorWhite),
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.FLOATING,
      );
    } catch (_) {
      emit(MapLoadFailure());
    }
  }
}
