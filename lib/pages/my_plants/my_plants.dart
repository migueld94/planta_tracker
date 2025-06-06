// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/card_plant.dart';
import 'package:planta_tracker/assets/utils/widgets/circular_progress.dart';
import 'package:planta_tracker/models/plantas_hive.dart';
import 'package:planta_tracker/models/register_plant_models.dart';
import 'package:planta_tracker/pages/my_plants/details_my_plant/detail_my_plant.dart';
import 'package:planta_tracker/pages/my_plants/edit/edit_plant_1.dart';
import 'package:planta_tracker/pages/my_plants/methods/methods.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyPlants extends StatefulWidget {
  const MyPlants({super.key});

  @override
  State<MyPlants> createState() => _MyPlantsState();
}

class _MyPlantsState extends State<MyPlants> {
  late Future<Box<Planta>> _plantaBoxFuture;
  bool isSelectionMode = false;
  bool loading = false;
  Set<String> selectedPlant = {};
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadPlantaBox();
  }

  void _loadPlantaBox() {
    _plantaBoxFuture = Hive.openBox<Planta>('plantasBox');
  }

  void _toggleSelection({required String plantId}) {
    setState(() {
      if (selectedPlant.contains(plantId)) {
        selectedPlant.remove(plantId);
        if (selectedPlant.isEmpty) {
          isSelectionMode = false;
        }
      } else {
        selectedPlant.add(plantId);
      }
    });
  }

  void _startSelectionMode() {
    setState(() {
      isSelectionMode = true;
    });
  }

  void _sendSelectedPlants() async {
    if (selectedPlant.isNotEmpty) {
      try {
        setState(() {
          loading = true;
        });
        final plantaBox = await _plantaBoxFuture;
        final allPlantas = plantaBox.values.toList();
        final plantaMap = {for (var p in allPlantas) p.id: p};

        List<Future> updateFutures = [];

        for (var plantId in selectedPlant) {
          if (plantaMap.containsKey(plantId)) {
            final planta = plantaMap[plantId]!;

            RegisterPlant plantRegister = RegisterPlant(
              imagenPrincipal: File(planta.imagenPricipal),
              imagenFlor: File(planta.imagenFlor!),
              imagenFruto: File(planta.imagenFruto!),
              imagenHojas: File(planta.imagenHoja!),
              imagenRamas: File(planta.imagenRamas!),
              imagenTronco: File(planta.imagenTallo!),
              notas: planta.nota,
              // lifestage: planta.lifestage,
              latitude: planta.latitude,
              longitude: planta.longitude,
            );

            // Enviar planta a la API
            var response = await sendPlantToApi(
              context: context,
              plant: plantRegister,
            );

            if (response != null) {
              log('Response del sendPlantToApi => ${response.statusCode}');
              if (response.statusCode == 200) {
                // Actualizar estado de la planta
                // planta.status = 'Enviado';
                // updateFutures.add(
                //   plantaBox.putAt(allPlantas.indexOf(planta), planta),
                // );

                // Eliminar la planta
                updateFutures.add(
                  plantaBox.deleteAt(allPlantas.indexOf(planta)),
                );

                log(
                  'Enviado Correctamente => ID: ${planta.id}, status: ${planta.status}',
                );
              } else {
                log(
                  'Error al enviar la planta => ID: ${planta.id}, status: ${response.statusCode}',
                );
              }
            } else {
              log('Error: La respuesta fue nula para ID: ${planta.id}');
            }
          }
        }

        await Future.wait(updateFutures);

        setState(() {
          selectedPlant.clear();
          isSelectionMode = false;
          loading = false;
        });
      } catch (e) {
        log("Error al abrir la caja de plantas: $e");
        setState(() {
          selectedPlant.clear();
          isSelectionMode = false;
          loading = false;
        });
      }
    } else {
      log("No hay plantas seleccionadas.");
    }
  }

  void _confirmDeleteCard({
    required BuildContext context,
    required int plantaIndex,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirm_delete),
          content: Text(AppLocalizations.of(context)!.delete_plant_question),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.buttom_cancel),
            ),
            TextButton(
              onPressed: () async {
                final plantaBox = await _plantaBoxFuture;
                final plantas = plantaBox.values.toList();

                // Filtrar plantas por estado
                final plantasOrdenadas = [
                  ...plantas.where(
                    (planta) => planta.status?.toLowerCase() == 'sin enviar',
                  ),
                  ...plantas.where(
                    (planta) => planta.status?.toLowerCase() == 'enviado',
                  ),
                ];

                // Obtener la planta existente
                Planta existingPlant = plantasOrdenadas[plantaIndex];

                // Encontrar el índice de existingPlant en la lista original
                int originalIndex = plantas.indexOf(existingPlant);

                // Eliminar la planta usando el índice original
                await plantaBox.deleteAt(originalIndex);

                // Actualizar el estado de la interfaz
                setState(() {});

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      AppLocalizations.of(context)!.delete_plant_confirmed,
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.text_buttom_accept),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Box<Planta>>(
          future: _plantaBoxFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularPlantaTracker());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(AppLocalizations.of(context)!.error_connection),
              );
            }

            final plantaBox = snapshot.data!;
            final plantas = plantaBox.values.toList();
            final plantasOrdenadas = [
              ...plantas.where(
                (planta) => planta.status?.toLowerCase() == 'sin enviar',
              ), // Plantas 'Sin Enviar'
              ...plantas.where(
                (planta) => planta.status?.toLowerCase() == 'enviado',
              ), // Otras plantas
            ];

            return plantasOrdenadas.isNotEmpty
                ? Column(
                  spacing: 8.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: allMargin8,
                      decoration: BoxDecoration(
                        borderRadius: borderRadius15,
                        color: PlantaColors.colorGrey.withOpacity(0.3),
                      ),
                      child: Text(
                        'Mantenga presionado la o las plantas que desee enviar',
                        style: context.theme.textTheme.subtitle,
                      ),
                    ),
                    ListView.builder(
                      itemCount: plantasOrdenadas.length,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final planta = plantasOrdenadas[index];
                        final isSelected = selectedPlant.contains(planta.id);

                        return Row(
                          spacing: 8.0,
                          children: [
                            Expanded(
                              child: CardMyPlants2(
                                title: AppLocalizations.of(context)!.name_plant,
                                // lifestage: planta.lifestage,
                                date:
                                    '${planta.fechaCreacion.day} / ${planta.fechaCreacion.month} / ${planta.fechaCreacion.year}',
                                onTap: () {
                                  if (isSelectionMode) {
                                    if (planta.status!.toLowerCase() !=
                                        'enviado') {
                                      _toggleSelection(plantId: planta.id);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          backgroundColor:
                                              PlantaColors.colorDarkOrange,
                                          content: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.plant_selected,
                                            style: context
                                                .theme
                                                .textTheme
                                                .text_01
                                                .copyWith(
                                                  color:
                                                      PlantaColors.colorWhite,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    Navigator.push(
                                      context,
                                      FadeTransitionRoute(
                                        page: DetailsMyPlants(planta: planta),
                                      ),
                                    );
                                  }
                                },
                                picture: File(planta.imagenPricipal).path,
                                id: planta.id,
                                status: planta.status,
                                onLongPress: () {
                                  if (planta.status!.toLowerCase() !=
                                      'enviado') {
                                    _startSelectionMode();
                                    _toggleSelection(plantId: planta.id);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor:
                                            PlantaColors.colorDarkOrange,
                                        content: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.plant_selected,
                                          style: context.theme.textTheme.text_01
                                              .copyWith(
                                                color: PlantaColors.colorWhite,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                color:
                                    isSelected
                                        ? PlantaColors.colorGreen
                                        : PlantaColors.colorWhite,
                              ),
                            ),

                            // Botones de acción
                            if (!isSelectionMode)
                              SizedBox(
                                height: 90.0,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // EDITAR
                                    if (planta.status!.toLowerCase() !=
                                        'enviado')
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            FadeTransitionRoute(
                                              page: GetApiEditInformation01(
                                                planta: planta,
                                                index: index,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: PlantaColors.colorGreen,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Ionicons.pencil_outline,
                                              color: PlantaColors.colorGreen,
                                            ),
                                          ),
                                        ),
                                      ),

                                    // ELIMINAR
                                    if (planta.status!.toLowerCase() !=
                                        'enviado')
                                      GestureDetector(
                                        onTap: () {
                                          _confirmDeleteCard(
                                            context: context,
                                            plantaIndex: index,
                                          );
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: PlantaColors.colorRed,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Ionicons.trash_outline,
                                              color: PlantaColors.colorRed,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                )
                : Center(
                  child: Text(
                    AppLocalizations.of(context)!.non_plant_registered,
                  ),
                );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: PlantaColors.colorGreen,
        onPressed: () => goToRegisterPlant(context),
        child: Icon(Ionicons.add_outline, color: PlantaColors.colorWhite),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Ink(
          height: 60.0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
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
                  // Botón de enviar plantas seleccionadas
                  if (selectedPlant.isNotEmpty)
                    ElevatedButton(
                      onPressed: _sendSelectedPlants,
                      child:
                          loading
                              ? CircularPlantaTracker(
                                size: 20.0,
                                color: PlantaColors.colorGreen,
                              )
                              : Text(
                                '${AppLocalizations.of(context)!.buttom_send} (${selectedPlant.length})',
                                style: TextStyle(
                                  color: PlantaColors.colorBlack,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
