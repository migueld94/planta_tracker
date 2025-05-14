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
import 'package:planta_tracker/pages/my_plants/details_my_plant/detail_my_plant.dart';
import 'package:planta_tracker/pages/my_plants/edit/edit_plant_1.dart';

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

  // Metodo para enviar la informacion a la api
  Future<void> sendPlantToApi({required Planta planta}) async {
    // Simulación de envío a la API
    // Aquí deberías implementar la lógica para hacer la solicitud HTTP
    // Por ejemplo, usando http.post o dio
    await Future.delayed(Duration(seconds: 1)); // Simula un retraso de red
    return;
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

            // Enviar planta a la API
            await sendPlantToApi(planta: planta);

            // Actualizar el estado a 'Enviado'
            planta.status = 'Enviado';
            updateFutures.add(
              plantaBox.putAt(allPlantas.indexOf(planta), planta),
            );

            log('Enviado => ID: ${planta.id}, status: ${planta.status}');
          }
        }

        // Esperar a que todas las actualizaciones se completen
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
          title: Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar esta Planta?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
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
                      'Planta eliminada',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: Text('Eliminar'),
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
              return Center(child: Text('Error. Inténtelo de nuevo'));
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
                ? ListView.builder(
                  itemCount: plantasOrdenadas.length,
                  itemBuilder: (context, index) {
                    final planta = plantasOrdenadas[index];
                    final isSelected = selectedPlant.contains(planta.id);

                    return Row(
                      spacing: 8.0,
                      children: [
                        Expanded(
                          child: CardMyPlants2(
                            title: AppLocalizations.of(context)!.name_plant,
                            lifestage: planta.lifestage,
                            date:
                                '${planta.fechaCreacion.day} / ${planta.fechaCreacion.month} / ${planta.fechaCreacion.year}',
                            onTap: () {
                              if (isSelectionMode) {
                                if (planta.status!.toLowerCase() != 'enviado') {
                                  _toggleSelection(plantId: planta.id);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          PlantaColors.colorDarkOrange,
                                      content: Text(
                                        'Esta seleccionado una planta ya enviada',
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
                              if (planta.status!.toLowerCase() != 'enviado') {
                                _startSelectionMode();
                                _toggleSelection(plantId: planta.id);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor:
                                        PlantaColors.colorDarkOrange,
                                    content: Text(
                                      'Esta seleccionado una planta ya enviada',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // EDITAR
                                if (planta.status!.toLowerCase() != 'enviado')
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
                                        borderRadius: BorderRadius.circular(10),
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
                                if (planta.status!.toLowerCase() != 'enviado')
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
                                        borderRadius: BorderRadius.circular(10),
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
                )
                : Center(child: Text('No hay plantas registradas'));
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
                                'Enviar (${selectedPlant.length})',
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
