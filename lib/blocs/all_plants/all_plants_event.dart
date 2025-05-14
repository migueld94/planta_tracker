import 'package:equatable/equatable.dart';
import 'package:planta_tracker/models/my_plants_models.dart';

abstract class AllPlantsEvent extends Equatable {
  const AllPlantsEvent();

  @override
  List<Object> get props => [];
}

class LoadAllPlants extends AllPlantsEvent {
  final String language;

  const LoadAllPlants({required this.language});

  @override
  List<Object> get props => [language];
}

class LoadMoreAllPlants extends AllPlantsEvent {
  final String language;

  const LoadMoreAllPlants({required this.language});

  @override
  List<Object> get props => [language];
}

class InvalidateCacheAllPlants extends AllPlantsEvent {}

class ActualizarAllPlantss extends AllPlantsEvent {
  final MyPlantsModel newPlants;

  const ActualizarAllPlantss(this.newPlants);

  @override
  List<Object> get props => [newPlants];
}
