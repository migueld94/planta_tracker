import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planta_tracker/models/my_plants_models.dart';
import 'package:planta_tracker/services/plants_services.dart';

import 'my_plants_event.dart';
import 'my_plants_state.dart';

class MyPlantsBloc extends Bloc<MyPlantsEvent, MyPlantsState> {
  final OptionPlantServices plantServices;
  MyPlantsModel? _cachedMyPlants;
  int _currentPage = 1;
  bool _isLoadingMore = false;

  MyPlantsBloc({required this.plantServices}) : super(MyPlantsInitial()) {
    on<LoadMyPlants>(_onLoadMyPlants);
    on<LoadMoreMyPlants>(_onloadMorePlants);
    on<InvalidateCacheMyPlants>(_onInvalidateCache);
    on<ActualizarMyPlantss>(_onActualizarMyPlantss);
  }

  void _onLoadMyPlants(LoadMyPlants event, Emitter<MyPlantsState> emit) async {
    emit(MyPlantsLoading());

    if (_cachedMyPlants != null) {
      emit(MyPlantsBackgroundLoading(plants: _cachedMyPlants!));
    } else {
      emit(MyPlantsLoading());
    }

    try {
      final plants = await plantServices.getAllMyPlants(page: _currentPage);
      _cachedMyPlants = plants;
      emit(MyPlantsLoaded(plants: _cachedMyPlants!));
    } catch (e) {
      emit(MyPlantsError(error: e.toString()));
    }
  }

  void _onloadMorePlants(
    LoadMoreMyPlants event,
    Emitter<MyPlantsState> emit,
  ) async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;
    emit(MyPlantsLoadingMore());

    try {
      final plants = await plantServices.getAllMyPlants(page: ++_currentPage);

      if (_cachedMyPlants != null) {
        _cachedMyPlants!.results.addAll(plants.results);
        emit(MyPlantsLoaded(plants: _cachedMyPlants!));
      } else {
        emit(MyPlantsError(error: 'No se pudo cargar las películas.'));
      }
    } catch (e) {
      emit(MyPlantsError(error: 'Error: ${e.toString()}'));
    } finally {
      _isLoadingMore = false;
    }
  }

  void _onInvalidateCache(
    InvalidateCacheMyPlants event,
    Emitter<MyPlantsState> emit,
  ) {
    _cachedMyPlants = null;
  }

  void _onActualizarMyPlantss(
    ActualizarMyPlantss event,
    Emitter<MyPlantsState> emit,
  ) {
    _cachedMyPlants = event.newPlants;
    emit(MyPlantsLoaded(plants: _cachedMyPlants!));
  }
}
