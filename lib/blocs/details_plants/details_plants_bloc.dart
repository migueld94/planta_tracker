import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planta_tracker/models/details_models.dart';
import 'package:planta_tracker/services/details_services.dart';

import 'details_plants_event.dart';
import 'details_plants_state.dart';

class PlantDetailBloc extends Bloc<PlantDetailEvent, PlantDetailState> {
  final DetailsServices detailsServices;
  DetailsModel? _cachedPlantDetail;

  PlantDetailBloc({required this.detailsServices})
    : super(PlantDetailInitial()) {
    on<FetchPlantDetail>(_onFetchPlantDetail);
    on<PlantEventCheckForUpdates>(_onCheckForUpdates);
    on<PlantDetailInvalidateCache>(_onInvalidateCachePlantDetail);
  }

  void _onFetchPlantDetail(
    FetchPlantDetail event,
    Emitter<PlantDetailState> emit,
  ) async {
    if (_cachedPlantDetail != null &&
        _cachedPlantDetail!.id.toString() == event.id) {
      emit(PlantDetailLoaded(plantDetail: _cachedPlantDetail!));
    } else {
      emit(PlantDetailLoading());
      try {
        final plantDetail = await detailsServices.fetchBusinessDetail(
          id: event.id,
          language: event.language
        );
        _cachedPlantDetail = plantDetail;
        emit(PlantDetailLoaded(plantDetail: plantDetail));
      } catch (e) {
        emit(PlantDetailError(message: e.toString()));
      }
    }
  }

  void _onCheckForUpdates(
    PlantEventCheckForUpdates event,
    Emitter<PlantDetailState> emit,
  ) async {
    try {
      final plantDetails = await detailsServices.fetchBusinessDetail(
        id: event.id,
        language: event.language
      );
      _cachedPlantDetail = plantDetails;
      emit(PlantDetailLoaded(plantDetail: plantDetails));
    } catch (e) {
      emit(PlantDetailError(message: e.toString()));
    }
  }

  void _onInvalidateCachePlantDetail(
    PlantDetailInvalidateCache event,
    Emitter<PlantDetailState> emit,
  ) {
    _cachedPlantDetail = null;
  }
}
