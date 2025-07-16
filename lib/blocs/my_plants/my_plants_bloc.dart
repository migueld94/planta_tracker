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
  bool _hasMoreData = true;

  MyPlantsBloc({required this.plantServices}) : super(MyPlantsInitial()) {
    on<LoadMyPlants>(_onLoadMyPlants);
    on<LoadMoreMyPlants>(_onloadMorePlants);
    on<InvalidateCacheMyPlants>(_onInvalidateCache);
    on<ActualizarMyPlantss>(_onActualizarMyPlantss);
  }

  bool get hasMoreData => _hasMoreData;

  // Getter público para la lista de plantas
  List<Result> get currentPlants => _cachedMyPlants?.results ?? [];

  void _onLoadMyPlants(LoadMyPlants event, Emitter<MyPlantsState> emit) async {
    emit(MyPlantsLoading());

    _currentPage = 1;
    _hasMoreData = true;

    if (_cachedMyPlants != null) {
      emit(MyPlantsBackgroundLoading(plants: _cachedMyPlants!));
    } else {
      emit(MyPlantsLoading());
    }

    try {
      final plants = await plantServices.getAllMyPlants(page: _currentPage);
      _cachedMyPlants = plants;

      if (plants.next == null) _hasMoreData = false;

      emit(MyPlantsLoaded(plants: _cachedMyPlants!));
    } catch (e) {
      emit(MyPlantsError(error: e.toString()));
    }
  }

  void _onloadMorePlants(
    LoadMoreMyPlants event,
    Emitter<MyPlantsState> emit,
  ) async {
    if (_isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;
    emit(MyPlantsLoadingMore());

    try {
      final plants = await plantServices.getAllMyPlants(page: ++_currentPage);

      if (plants.results.isEmpty || plants.next == null) {
        _hasMoreData = false;
      }

      if (_cachedMyPlants != null) {
        _cachedMyPlants!.results.addAll(plants.results);
        emit(MyPlantsLoaded(plants: _cachedMyPlants!));
      } else {
        emit(MyPlantsError(error: 'No se pudo cargar las plantas.'));
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
    _currentPage = 1;
    _hasMoreData = true;
  }

  void _onActualizarMyPlantss(
    ActualizarMyPlantss event,
    Emitter<MyPlantsState> emit,
  ) {
    _cachedMyPlants = event.newPlants;
    emit(MyPlantsLoaded(plants: _cachedMyPlants!));
  }
}
