import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
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
    } catch (_) {
      emit(MapLoadFailure());
    }
  }
}
