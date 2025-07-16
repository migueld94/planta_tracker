import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planta_tracker/blocs/all_plants/all_plants_event.dart';
import 'package:planta_tracker/blocs/all_plants/all_plants_state.dart';
import 'package:planta_tracker/models/my_plants_models.dart';
import 'package:planta_tracker/services/plants_services.dart';

class AllPlantsBloc extends Bloc<AllPlantsEvent, AllPlantsState> {
  final OptionPlantServices plantServices;
  MyPlantsModel? _cachedAllPlants;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  AllPlantsBloc({required this.plantServices}) : super(AllPlantsInitial()) {
    on<LoadAllPlants>(_onLoadAllPlants);
    on<LoadMoreAllPlants>(_onloadMorePlants);
    on<InvalidateCacheAllPlants>(_onInvalidateCache);
    on<ActualizarAllPlantss>(_onActualizarAllPlantss);
  }

  bool get hasMoreData => _hasMoreData;

  // Getter público para la lista de plantas
  List<Result> get currentPlants => _cachedAllPlants?.results ?? [];

  void _onLoadAllPlants(
    LoadAllPlants event,
    Emitter<AllPlantsState> emit,
  ) async {
    emit(AllPlantsLoading());

    _currentPage = 1;
    _hasMoreData = true;

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

      if (plants.next == null) _hasMoreData = false;

      emit(AllPlantsLoaded(plants: _cachedAllPlants!));
    } catch (e) {
      emit(AllPlantsError(error: e.toString()));
    }
  }

  void _onloadMorePlants(
    LoadMoreAllPlants event,
    Emitter<AllPlantsState> emit,
  ) async {
    if (_isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;
    emit(AllPlantsLoadingMore());

    try {
      final plants = await plantServices.getAllPlants(
        page: ++_currentPage,
        language: event.language,
      );

      if (plants.results.isEmpty || plants.next == null) {
        _hasMoreData = false;
      }

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
    _currentPage = 1;
    _hasMoreData = true;
  }

  void _onActualizarAllPlantss(
    ActualizarAllPlantss event,
    Emitter<AllPlantsState> emit,
  ) {
    _cachedAllPlants = event.newPlants;
    emit(AllPlantsLoaded(plants: _cachedAllPlants!));
  }
}
