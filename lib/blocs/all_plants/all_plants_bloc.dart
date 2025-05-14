import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planta_tracker/models/my_plants_models.dart';
import 'package:planta_tracker/services/plants_services.dart';

import 'all_plants_event.dart';
import 'all_plants_state.dart';

class AllPlantsBloc extends Bloc<AllPlantsEvent, AllPlantsState> {
  final OptionPlantServices plantServices;
  MyPlantsModel? _cachedAllPlants;
  int _currentPage = 1;
  bool _isLoadingMore = false;

  AllPlantsBloc({required this.plantServices}) : super(AllPlantsInitial()) {
    on<LoadAllPlants>(_onLoadAllPlants);
    on<LoadMoreAllPlants>(_onloadMorePlants);
    on<InvalidateCacheAllPlants>(_onInvalidateCache);
    on<ActualizarAllPlantss>(_onActualizarAllPlantss);
  }

  void _onLoadAllPlants(
    LoadAllPlants event,
    Emitter<AllPlantsState> emit,
  ) async {
    emit(AllPlantsLoading());

    if (_cachedAllPlants != null) {
      emit(AllPlantsBackgroundLoading(plants: _cachedAllPlants!));
    } else {
      emit(AllPlantsLoading());
    }

    try {
      final plants = await plantServices.getAllPlants(
        page: _currentPage,
        language: event.language,
      );
      _cachedAllPlants = plants;
      emit(AllPlantsLoaded(plants: _cachedAllPlants!));
    } catch (e) {
      emit(AllPlantsError(error: e.toString()));
    }
  }

  void _onloadMorePlants(
    LoadMoreAllPlants event,
    Emitter<AllPlantsState> emit,
  ) async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;
    emit(AllPlantsLoadingMore());

    try {
      final plants = await plantServices.getAllPlants(
        page: ++_currentPage,
        language: event.language,
      );

      if (_cachedAllPlants != null) {
        _cachedAllPlants!.results.addAll(plants.results);
        emit(AllPlantsLoaded(plants: _cachedAllPlants!));
      } else {
        emit(AllPlantsError(error: 'No se pudo cargar las plantas.'));
      }
    } catch (e) {
      emit(AllPlantsError(error: 'Error: ${e.toString()}'));
    } finally {
      _isLoadingMore = false;
    }
  }

  void _onInvalidateCache(
    InvalidateCacheAllPlants event,
    Emitter<AllPlantsState> emit,
  ) {
    _cachedAllPlants = null;
  }

  void _onActualizarAllPlantss(
    ActualizarAllPlantss event,
    Emitter<AllPlantsState> emit,
  ) {
    _cachedAllPlants = event.newPlants;
    emit(AllPlantsLoaded(plants: _cachedAllPlants!));
  }
}
