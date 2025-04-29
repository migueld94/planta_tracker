import 'package:equatable/equatable.dart';
import 'package:planta_tracker/models/my_plants_models.dart';

abstract class MyPlantsState extends Equatable {
  const MyPlantsState();

  @override
  List<Object> get props => [];
}

class MyPlantsInitial extends MyPlantsState {}

class MyPlantsLoading extends MyPlantsState {}

class MyPlantsBackgroundLoading extends MyPlantsState {
  final MyPlantsModel plants;

  const MyPlantsBackgroundLoading({required this.plants});

  @override
  List<Object> get props => [plants];
}

class MyPlantsLoaded extends MyPlantsState {
  final MyPlantsModel plants;

  const MyPlantsLoaded({required this.plants});

  @override
  List<Object> get props => [plants];
}

class MyPlantsError extends MyPlantsState {
  final String error;

  const MyPlantsError({required this.error});

  @override
  List<Object> get props => [error];
}

class MyPlantsLoadingMore extends MyPlantsState {}
