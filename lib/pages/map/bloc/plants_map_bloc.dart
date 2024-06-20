import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:planta_tracker/models/plants_models.dart';
import 'package:planta_tracker/services/all_plants_services.dart';
import 'package:rxdart/rxdart.dart';

part 'plants_map_event.dart';
part 'plants_map_state.dart';
part 'plants_map_bloc.freezed.dart';

class PlantsMapBloc extends Bloc<PlantsMapEvent, PlantsMapState> {
  PlantsMapBloc(this._allPlantServices) : super(const _PlantsMapState()) {
    on<PlantsMapEvent>(
      (event, emit) => event.mapOrNull(
        load: (_) => _onLoad(emit),
      ),
    );

    on<_LoadMoreByBoundries>(
      (event, emit) => _onLoadMoreByBoundries(emit, event),
      transformer: debounceSequential(),
    );

    add(const PlantsMapEvent.load());
  }

  final AllPlantServices _allPlantServices;

  Future<void> _onLoad(Emitter<PlantsMapState> emit) async {
    final (
      latMax,
      latMin,
      longMax,
      longMin,
    ) = _obtenerLimites(state.northEast, state.southWest);

    final response =
        await _allPlantServices.getAllPin(latMax, latMin, longMax, longMin);
    emit(state.copyWith(plants: response));
  }

  Future<void> _onLoadMoreByBoundries(
    Emitter<PlantsMapState> emit,
    _LoadMoreByBoundries event,
  ) async {
    final (
      latMax,
      latMin,
      longMax,
      longMin,
    ) = _obtenerLimites(state.northEast, state.southWest);

    final response =
        await _allPlantServices.getAllPin(latMax, latMin, longMax, longMin);

    emit(
      state.copyWith(
        plants: response,
        northEast: event.northEast,
        southWest: event.southWest,
      ),
    );
  }
}

EventTransformer<E> debounceSequential<E>([
  Duration duration = const Duration(milliseconds: 500),
]) {
  return (events, mapper) {
    return sequential<E>().call(events.debounceTime(duration), mapper);
  };
}

(double, double, double, double) _obtenerLimites(
    LatLng northEast, LatLng southWest) {
  double latMax = northEast.latitude > southWest.latitude
      ? northEast.latitude
      : southWest.latitude;
  double latMin = northEast.latitude < southWest.latitude
      ? northEast.latitude
      : southWest.latitude;
  double longMax = northEast.longitude > southWest.longitude
      ? northEast.longitude
      : southWest.longitude;
  double longMin = northEast.longitude < southWest.longitude
      ? northEast.longitude
      : southWest.longitude;

  return (latMax, latMin, longMax, longMin);
}






// class PlantsMapBloc extends Bloc<PlantsMapEvent, PlantsMapState> {
//   PlantsMapBloc(this._allPlantServices) : super(const _PlantsMapState()) {
//     on<PlantsMapEvent>(
//       (event, emit) => event.mapOrNull(
//         load: (_) => _onLoad(emit),
//       ),
//     );

//     on<_LoadMoreByBoundries>(
//       (event, emit) => _onLoadMoreByBoundries(emit, event),
//       transformer: debounceSequential(),
//     );

//     add(const PlantsMapEvent.load());
//   }

//   final AllPlantServices _allPlantServices;
//   LatLng northEast;
//   LatLng southWest;
//   List<double> limites = obtenerLimites();

//   final double latMax = limites[0];
//   final double latMin = limites[1];
//   final double longMax = limites[2];
//   final double longMin = limites[3];

//   Future<void> _onLoad(Emitter<PlantsMapState> emit) async {
//     final response =
//         await _allPlantServices.getAllPin(latMax, latMin, longMax, longMin);
//     emit(state.copyWith(plants: response));
//   }

//   Future<void> _onLoadMoreByBoundries(
//     Emitter<PlantsMapState> emit,
//     _LoadMoreByBoundries event,
//   ) async {
//     final response = await _allPlantServices.getPinsByBoundries(
//       northEast = event.northEast,
//       southWest = event.southWest,
//     );

//     emit(
//       state.copyWith(
//         plants: response,
//         northEast: event.northEast,
//         southWest: event.southWest,
//       ),
//     );
//   }
// }

// EventTransformer<E> debounceSequential<E>([
//   Duration duration = const Duration(milliseconds: 500),
// ]) {
//   return (events, mapper) {
//     return sequential<E>().call(events.debounceTime(duration), mapper);
//   };
// }

// List<double> obtenerLimites(LatLng northEast, LatLng southWest) {
//   double latMax = northEast.latitude > southWest.latitude
//       ? northEast.latitude
//       : southWest.latitude;
//   double latMin = northEast.latitude < southWest.latitude
//       ? northEast.latitude
//       : southWest.latitude;
//   double longMax = northEast.longitude > southWest.longitude
//       ? northEast.longitude
//       : southWest.longitude;
//   double longMin = northEast.longitude < southWest.longitude
//       ? northEast.longitude
//       : southWest.longitude;

//   return [latMax, latMin, longMax, longMin];
// }
