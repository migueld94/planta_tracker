part of 'plants_map_bloc.dart';

@freezed
class PlantsMapEvent with _$PlantsMapEvent {
  const factory PlantsMapEvent.load() = _Load;
  const factory PlantsMapEvent.loadMoreByBoundries(
    LatLng northEast,
    LatLng southWest,
  ) = _LoadMoreByBoundries;
}
