import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:planta_tracker/blocs/lifestage_nomenclador/lifestage_nomenclador_event.dart';
import 'package:planta_tracker/blocs/lifestage_nomenclador/lifestage_nomenclador_state.dart';
import 'package:planta_tracker/models/nom_lifestage.dart';
import 'package:planta_tracker/services/nom_lifestage_services.dart';

class LifestageNomBloc extends Bloc<LifestageNomEvent, LifestageNomState> {
  final LifestageServices lifestageServices;
  Lifestage? _cachedLifestageNom;
  bool _isLoadingMore = false;

  LifestageNomBloc({required this.lifestageServices})
    : super(LifestageNomInitial()) {
    on<LoadLifestageNom>(_onLoadLifestageNom);
    on<LoadMoreLifestageNom>(_onLoadMorePlants);
    on<InvalidateCacheLifestageNom>(_onInvalidateCache);
    on<ActualizarLifestageNoms>(_onActualizarLifestageNoms);
  }

  void _onLoadLifestageNom(
    LoadLifestageNom event,
    Emitter<LifestageNomState> emit,
  ) async {
    emit(LifestageNomLoading());

    if (_cachedLifestageNom != null) {
      emit(LifestageNomBackgroundLoading(lifestage: _cachedLifestageNom!));
    } else {
      emit(LifestageNomLoading());
    }

    try {
      var box = await Hive.openBox<Lifestage>('lifestageBox');

      // Carga los datos desde Hive
      if (box.isNotEmpty) {
        _cachedLifestageNom = box.getAt(
          0,
        ); // Asumiendo que solo hay un objeto Lifestage guardado.
        emit(LifestageNomLoaded(lifestage: _cachedLifestageNom!));
      } else {
        final lifestage = await lifestageServices.getLifestage();
        await box.put('lifestage', lifestage); // Guardar el nuevo lifestage

        _cachedLifestageNom = lifestage; // Almacenar el objeto completo
        emit(LifestageNomLoaded(lifestage: _cachedLifestageNom!));
      }
    } catch (e) {
      emit(LifestageNomError(error: e.toString()));
    }
  }

  void _onLoadMorePlants(
    LoadMoreLifestageNom event,
    Emitter<LifestageNomState> emit,
  ) async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;
    emit(LifestageNomLoadingMore());

    try {
      final newPlants = await lifestageServices.getLifestage();

      if (_cachedLifestageNom != null) {
        _cachedLifestageNom!.results.addAll(
          newPlants.results,
        ); // Agregar nuevos resultados a la lista
        emit(LifestageNomLoaded(lifestage: _cachedLifestageNom!));
      } else {
        emit(LifestageNomError(error: 'No se pudo cargar las plantas.'));
      }
    } catch (e) {
      emit(LifestageNomError(error: 'Error: ${e.toString()}'));
    } finally {
      _isLoadingMore = false;
    }
  }

  void _onInvalidateCache(
    InvalidateCacheLifestageNom event,
    Emitter<LifestageNomState> emit,
  ) {
    _cachedLifestageNom = null;
  }

  void _onActualizarLifestageNoms(
    ActualizarLifestageNoms event,
    Emitter<LifestageNomState> emit,
  ) {
    _cachedLifestageNom = event.newLifestage;
    emit(LifestageNomLoaded(lifestage: _cachedLifestageNom!));
  }
}
