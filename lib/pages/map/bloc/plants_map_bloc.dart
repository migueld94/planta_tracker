import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
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
        loadById: (event) => _onLoadById(emit, event),
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
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Verificar si el servicio de ubicación está habilitado.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // El servicio de ubicación no está habilitado.
        return Future.error('El servicio de ubicación está deshabilitado.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Los permisos de ubicación están denegados
          return Future.error('Los permisos de ubicación están denegados');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Los permisos de ubicación están permanentemente denegados, no podemos solicitar permisos.
        return Future.error(
          'Los permisos de ubicación están permanentemente denegados',
        );
      }

      // Cuando llegamos aquí, tenemos los permisos de ubicación necesarios y el servicio de ubicación está habilitado.
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final (latMax, latMin, longMax, longMin) = _obtenerLimites(
        state.northEast,
        state.southWest,
      );

      final response = await _allPlantServices.getAllPin(
        latMax,
        latMin,
        longMax,
        longMin,
      );

      emit(
        state.copyWith(
          plants: response,
          userLocation: LatLng(position.latitude, position.longitude),
          plantSpecieId: null,
        ),
      );
    } catch (e) {
      log('Ocurrió un error al obtener la ubicación: $e');
    }
  }

  Future<void> _onLoadMoreByBoundries(
    Emitter<PlantsMapState> emit,
    _LoadMoreByBoundries event,
  ) async {
    final (latMax, latMin, longMax, longMin) = _obtenerLimites(
      event.northEast,
      event.southWest,
    );

    final response =
        state.plantSpecieId == null
            ? await _allPlantServices.getAllPin(
              latMax,
              latMin,
              longMax,
              longMin,
            )
            : await _allPlantServices.getSpeciesById(
              state.plantSpecieId!,
              latMax,
              latMin,
              longMax,
              longMin,
            );

    emit(
      state.copyWith(
        plants: response,
        northEast: event.northEast,
        southWest: event.southWest,
      ),
    );
  }

  Future<void> _onLoadById(
    Emitter<PlantsMapState> emit,
    _LoadById event,
  ) async {
    final (latMax, latMin, longMax, longMin) = _obtenerLimites(
      state.northEast,
      state.southWest,
    );

    final response = await _allPlantServices.getSpeciesById(
      event.id,
      latMax,
      latMin,
      longMax,
      longMin,
    );

    emit(state.copyWith(plantSpecieId: event.id, plants: response));
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
  LatLng northEast,
  LatLng southWest,
) {
  double latMax =
      northEast.latitude > southWest.latitude
          ? northEast.latitude
          : southWest.latitude;
  double latMin =
      northEast.latitude < southWest.latitude
          ? northEast.latitude
          : southWest.latitude;
  double longMax =
      northEast.longitude > southWest.longitude
          ? northEast.longitude
          : southWest.longitude;
  double longMin =
      northEast.longitude < southWest.longitude
          ? northEast.longitude
          : southWest.longitude;

  return (latMax, latMin, longMax, longMin);
}
