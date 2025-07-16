import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:planta_tracker/assets/l10n/l10n.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/card_plant.dart';
import 'package:planta_tracker/assets/utils/widgets/circular_progress.dart';
import 'package:planta_tracker/blocs/my_plants/my_plants_bloc.dart';
import 'package:planta_tracker/blocs/my_plants/my_plants_event.dart';
import 'package:planta_tracker/blocs/my_plants/my_plants_state.dart';
import 'package:planta_tracker/models/my_plants_models.dart';
import 'package:planta_tracker/pages/details_plant/details.dart';

class PlantsSentView extends StatefulWidget {
  const PlantsSentView({super.key});

  @override
  State<PlantsSentView> createState() => _PlantsSentViewState();
}

class _PlantsSentViewState extends State<PlantsSentView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          context.read<MyPlantsBloc>().state is! MyPlantsLoadingMore &&
          context.read<MyPlantsBloc>().hasMoreData) {
            final locale = Localizations.localeOf(context);
        var language = L10n.getFlag(locale.languageCode);
        context.read<MyPlantsBloc>().add(LoadMoreMyPlants(language));
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MyPlantsBloc, MyPlantsState>(
        builder: (context, state) {
          if (state is MyPlantsLoading) {
            return const Center(child: CircularPlantaTracker());
          }

          if (state is MyPlantsLoaded ||
              state is MyPlantsBackgroundLoading ||
              state is MyPlantsLoadingMore) {
            // Usar el getter público en lugar de acceder a propiedad privada
            final plants = context.read<MyPlantsBloc>().currentPlants;
            final isLoadingMore = state is MyPlantsLoadingMore;
            final hasMore = context.read<MyPlantsBloc>().hasMoreData;

            return ListView.builder(
              controller: _scrollController,
              itemCount: plants.length + 1,
              itemBuilder: (context, index) {
                if (index < plants.length) {
                  final plant = plants[index];
                  final date = plant.fechaRegistro.toLocal();

                  return CardPlant(
                    picture: plant.imagenPrincipal,
                    title:
                        plant.especiePlanta ??
                        AppLocalizations.of(context)!.name_plant,
                    status: plant.estadoActual,
                    date: '${date.day} / ${date.month} / ${date.year}',
                    onTap: () {
                      Navigator.push(
                        context,
                        FadeTransitionRoute(page: Details(id: plant.id)),
                      );
                    },
                  );
                } else if (isLoadingMore) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularPlantaTracker()),
                  );
                } else if (!hasMore) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text("No hay más plantas para mostrar"),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            );
          }

          if (state is MyPlantsError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Ionicons.wifi_outline,
                    size: 90.0,
                    color: PlantaColors.colorGrey,
                  ),
                  Text(
                    AppLocalizations.of(context)!.error_connection,
                    style: context.theme.textTheme.h2.copyWith(
                      color: PlantaColors.colorGrey,
                      fontSize: 20.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final locale = Localizations.localeOf(context);
                      var language = L10n.getFlag(locale.languageCode);
                      context.read<MyPlantsBloc>().add(LoadMyPlants(language: language));
                    },
                    icon: Icon(Ionicons.refresh_outline, size: 30.0),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Ink(
          height: 60.0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: BottomAppBar(
              color: PlantaColors.colorGreen,
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Ionicons.people_outline,
                      color: PlantaColors.colorWhite,
                    ),
                    onPressed: () => goToProfile(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final Result result;

  const PlantCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: ListTile(
        leading: Image.network(
          result.imagenPrincipal,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        ),
        title: Text(result.especiePlanta ?? 'Determinacion pendiente'),
        subtitle: Text(
          "Estado: ${result.estadoActual}\nRegistrada: ${result.fechaRegistro.toLocal().toString().split(' ')[0]}",
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            FadeTransitionRoute(page: Details(id: result.id)),
          );
        },
      ),
    );
  }
}
