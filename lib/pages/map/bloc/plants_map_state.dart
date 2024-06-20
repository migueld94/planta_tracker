part of 'plants_map_bloc.dart';

@freezed
class PlantsMapState with _$PlantsMapState {
  const factory PlantsMapState({
    @Default(LatLng(23.11958, -82.397264)) LatLng location,
     @Default(LatLng(23.61958, -82.597264)) LatLng northEast,
     @Default(LatLng(22.11958, -82.197264)) LatLng southWest,
    @Default([]) List<Plant> plants,
  }) = _PlantsMapState;
}
