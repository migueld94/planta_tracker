import 'package:equatable/equatable.dart';
import 'package:planta_tracker/models/my_plants_models.dart';

abstract class AllPlantsState extends Equatable {
  const AllPlantsState();

  @override
  List<Object> get props => [];
}

class AllPlantsInitial extends AllPlantsState {}

class AllPlantsLoading extends AllPlantsState {}

class AllPlantsBackgroundLoading extends AllPlantsState {
  final MyPlantsModel plants;

  const AllPlantsBackgroundLoading({required this.plants});

  @override
  List<Object> get props => [plants];
}

class AllPlantsLoaded extends AllPlantsState {
  final MyPlantsModel plants;

  const AllPlantsLoaded({required this.plants});

  @override
  List<Object> get props => [plants];
}

class AllPlantsError extends AllPlantsState {
  final String error;

  const AllPlantsError({required this.error});

  @override
  List<Object> get props => [error];
}

class AllPlantsLoadingMore extends AllPlantsState {}
