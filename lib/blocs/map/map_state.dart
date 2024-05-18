import 'package:latlong2/latlong.dart';

abstract class MapState {}

class MapInitial extends MapState {}

class MapLoadInProgress extends MapState {}

class MapLoadSuccess extends MapState {
  final LatLng location;
  MapLoadSuccess(this.location);
}

class MapLoadFailure extends MapState {}
