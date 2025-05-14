import 'package:equatable/equatable.dart';
import 'package:planta_tracker/models/details_models.dart';

abstract class PlantDetailState extends Equatable {
  const PlantDetailState();

  @override
  List<Object> get props => [];
}

class PlantDetailInitial extends PlantDetailState {}

class PlantDetailLoading extends PlantDetailState {}

class PlantDetailLoaded extends PlantDetailState {
  final DetailsModel plantDetail;

  const PlantDetailLoaded({required this.plantDetail});

  @override
  List<Object> get props => [plantDetail];
}

class PlantDetailError extends PlantDetailState {
  final String message;

  const PlantDetailError({required this.message});

  @override
  List<Object> get props => [message];
}
