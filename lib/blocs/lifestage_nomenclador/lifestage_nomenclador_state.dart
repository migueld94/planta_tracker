import 'package:equatable/equatable.dart';
import 'package:planta_tracker/models/nom_lifestage.dart';

abstract class LifestageNomState extends Equatable {
  const LifestageNomState();

  @override
  List<Object> get props => [];
}

class LifestageNomInitial extends LifestageNomState {}

class LifestageNomLoading extends LifestageNomState {}

class LifestageNomBackgroundLoading extends LifestageNomState {
  final Lifestage lifestage;

  const LifestageNomBackgroundLoading({required this.lifestage});

  @override
  List<Object> get props => [lifestage];
}

class LifestageNomLoaded extends LifestageNomState {
  final Lifestage lifestage;

  const LifestageNomLoaded({required this.lifestage});

  @override
  List<Object> get props => [lifestage];
}

class LifestageNomError extends LifestageNomState {
  final String error;

  const LifestageNomError({required this.error});

  @override
  List<Object> get props => [error];
}

class LifestageNomLoadingMore extends LifestageNomState {}
