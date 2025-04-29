import 'package:equatable/equatable.dart';
import 'package:planta_tracker/models/my_plants_models.dart';

abstract class MyPlantsEvent extends Equatable {
  const MyPlantsEvent();

  @override
  List<Object> get props => [];
}

class LoadMyPlants extends MyPlantsEvent {}

class LoadMoreMyPlants extends MyPlantsEvent {}

class InvalidateCacheMyPlants extends MyPlantsEvent {}

class ActualizarMyPlantss extends MyPlantsEvent {
  final MyPlantsModel newPlants;

  const ActualizarMyPlantss(this.newPlants);

  @override
  List<Object> get props => [newPlants];
}
