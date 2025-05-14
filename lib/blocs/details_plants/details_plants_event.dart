import 'package:equatable/equatable.dart';

abstract class PlantDetailEvent extends Equatable {
  const PlantDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchPlantDetail extends PlantDetailEvent {
  final String language;
  final String id;

  const FetchPlantDetail({required this.id, required this.language});
}

class PlantEventCheckForUpdates extends PlantDetailEvent {
  final String language;
  final String id;

  const PlantEventCheckForUpdates({required this.id, required this.language});
}

class PlantDetailInvalidateCache extends PlantDetailEvent {}
