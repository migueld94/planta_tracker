// ignore_for_file: avoid_print, use_build_context_synchronously, must_be_immutable, unrelated_type_equality_checks

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';
import 'package:planta_tracker/models/plantas_hive.dart';

import 'package:planta_tracker/pages/home/home.dart';
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:planta_tracker/services/plants_services.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/models/register_plant_models.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/widgets/input_decorations.dart';

class GetApiEditInformationEnd extends StatefulWidget {
  final Planta planta;
  final int index;
  final double latitude;
  final double longitude;
  // final List<File> pictures;
  List<Map<String, dynamic>> valores = [
    {"imagen": "", "name": ""},
  ];

  GetApiEditInformationEnd({
    required this.valores,
    required this.planta,
    required this.index,
    required this.latitude,
    required this.longitude,
    super.key,
  });

  @override
  State<GetApiEditInformationEnd> createState() =>
      _GetApiEditInformationEndState();
}

class _GetApiEditInformationEndState extends State<GetApiEditInformationEnd> {
  OptionPlantServices detailsEditServices = OptionPlantServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EditPlant(
        valores: widget.valores,
        planta: widget.planta,
        index: widget.index,
        latitude: widget.latitude,
        longitude: widget.longitude,
      ),
    );
  }
}

class EditPlant extends StatefulWidget {
  // final List<File> pictures;
  List<Map<String, dynamic>> valores = [
    {"imagen": "", "name": ""},
  ];

  final Planta planta;
  final int index;
  final double latitude;
  final double longitude;
  EditPlant({
    // required this.pictures,
    required this.valores,
    required this.planta,
    required this.index,
    required this.latitude,
    required this.longitude,
    super.key,
  });

  @override
  EditPlantState createState() => EditPlantState();
}

class EditPlantState extends State<EditPlant> {
  List<File> imageFile = [];
  bool flag = false;
  final GlobalKey<FormState> formKey = GlobalKey();
  var noteController = TextEditingController();
  String notes = '';
  final storage = const FlutterSecureStorage();
  final OptionPlantServices optionServices = OptionPlantServices();
  RegisterPlant plant = RegisterPlant();
  // final _lifestage = GlobalKey<ShakeWidgetState>();
  // Lifestage? free;
  String lifestage = '';
  // late Future<Box<Planta>> _plantaBoxFuture;
  List<ImagesMyPlant> images = [];

  @override
  void initState() {
    super.initState();
    // _loadPlantaBox();
    noteController.text =
        widget.planta.nota != null ? widget.planta.nota ?? '' : '';
  }

  // void _loadPlantaBox() {
  //   _plantaBoxFuture = Hive.openBox<Planta>('plantasBox');
  // }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  Future<void> _savePlantData({
    required String imagenPrincipal,
    required double latitude,
    required double longitude,
    // required String lifestage,
    required List<ImagesMyPlant> images,
    String? note,
    String? imagenTallo,
    String? imagenFruto,
    String? imagenRamas,
    String? imagenHoja,
    String? imagenFlor,
  }) async {
    var box = await Hive.openBox<Planta>('plantasBox');
    final plantas = box.values.toList();

    // Filtrar plantas por estado
    final plantasOrdenadas = [
      ...plantas.where(
        (planta) => planta.status?.toLowerCase() == 'sin enviar',
      ),
      ...plantas.where((planta) => planta.status?.toLowerCase() == 'enviado'),
    ];

    // Obtener la planta existente según el índice de plantasOrdenadas
    Planta existingPlant = plantasOrdenadas[widget.index];

    // Actualizar los campos de la planta existente
    existingPlant.imagenPricipal = imagenPrincipal;
    existingPlant.imagenTallo = imagenTallo;
    existingPlant.imagenRamas = imagenRamas;
    existingPlant.imagenHoja = imagenHoja;
    existingPlant.imagenFruto = imagenFruto;
    existingPlant.imagenFlor = imagenFlor;
    existingPlant.latitude = latitude;
    existingPlant.longitude = longitude;
    // existingPlant.lifestage = lifestage;
    existingPlant.nota = note;
    existingPlant.fechaCreacion = DateTime.now();
    existingPlant.images = images;
    existingPlant.status = 'Sin enviar';

    // Actualizar la planta en el box
    await box.putAt(plantas.indexOf(existingPlant), existingPlant);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: PlantaColors.colorGreen,
        title: AutoSizeText(
          AppLocalizations.of(context)!.edit_plant,
          style: context.theme.textTheme.titleApBar,
        ),
      ),
      body: PopScope(
        canPop: false,
        child: Padding(
          padding: allPadding16,
          child: Form(
            key: formKey,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                      child: ListView.separated(
                        clipBehavior: Clip.none,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder:
                            (context, index) => horizontalMargin16,
                        itemCount: widget.valores.length,
                        itemBuilder: (context, index) {
                          final valor = widget.valores[index];
                          final file = valor["imagen"];
                          final fileName = file.split('/').last;
                          if (fileName.endsWith("De7au1t.png")) {
                            return emptyWidget;
                          } else {
                            return Column(
                              children: [
                                Container(
                                  width: 180,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    color: PlantaColors.colorWhite,
                                    borderRadius: borderRadius10,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: borderRadius10,
                                    child: Image.file(
                                      File(widget.valores[index]['imagen']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                AutoSizeText(
                                  widget.valores[index]['name'],
                                  style: context.theme.textTheme.text_01,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                    // Text(
                    //   'Lifestage',
                    //   style: context.theme.textTheme.h2.copyWith(
                    //     fontSize: 20.0,
                    //   ),
                    // ),
                    // verticalMargin8,
                    //* DropdownButton
                    // ShakeWidget(
                    //   key: _lifestage,
                    //   duration: const Duration(seconds: 1),
                    //   shakeCount: 3,
                    //   shakeOffset: 2,
                    //   child: BlocBuilder<LifestageNomBloc, LifestageNomState>(
                    //     builder: (context, state) {
                    //       if (state is LifestageNomLoading &&
                    //           state is! LifestageNomLoaded) {
                    //         return const Center(child: CircularPlantaTracker());
                    //       } else if (state is LifestageNomLoaded ||
                    //           state is LifestageNomBackgroundLoading) {
                    //         free =
                    //             (state is LifestageNomLoaded)
                    //                 ? state.lifestage
                    //                 : (state as LifestageNomBackgroundLoading)
                    //                     .lifestage;

                    //         return free!.results.isNotEmpty
                    //             ? Container(
                    //               decoration: BoxDecoration(
                    //                 border: Border.all(color: Colors.grey),
                    //                 borderRadius: borderRadius10,
                    //               ),
                    //               child: DropdownButtonHideUnderline(
                    //                 child: DropdownButton2(
                    //                   dropdownStyleData: DropdownStyleData(
                    //                     decoration: BoxDecoration(
                    //                       border: Border.all(
                    //                         color: Colors.grey,
                    //                       ),
                    //                       borderRadius: borderRadius10,
                    //                     ),
                    //                   ),
                    //                   isExpanded: true,
                    //                   style: const TextStyle(
                    //                     fontFamily: 'Poppins',
                    //                   ),
                    //                   hint: Text(
                    //                     'Lifestage',
                    //                     style: TextStyle(fontFamily: 'Poppins'),
                    //                   ),
                    //                   value: widget.planta.lifestage,
                    //                   onChanged: (newValue) {
                    //                     if (newValue != null) {
                    //                       setState(() {
                    //                         widget.planta.lifestage = newValue;
                    //                       });
                    //                     }
                    //                   },
                    //                   items:
                    //                       free!.results.map<DropdownMenuItem>((
                    //                         Result lifestage,
                    //                       ) {
                    //                         return DropdownMenuItem(
                    //                           value: lifestage.nombre,
                    //                           child: Text(
                    //                             lifestage.nombre,
                    //                             style: context
                    //                                 .theme
                    //                                 .textTheme
                    //                                 .h3
                    //                                 .copyWith(
                    //                                   fontWeight:
                    //                                       FontWeight.normal,
                    //                                 ),
                    //                           ),
                    //                         );
                    //                       }).toList(),
                    //                 ),
                    //               ),
                    //             )
                    //             : Padding(
                    //               padding: const EdgeInsets.symmetric(
                    //                 horizontal: 16.0,
                    //               ),
                    //               child: Text(
                    //                 'No hay elementos',
                    //                 style: const TextStyle(
                    //                   fontFamily: 'Poppins',
                    //                   color: Colors.red,
                    //                 ),
                    //               ),
                    //             );
                    //       } else if (state is LifestageNomError) {
                    //         return Text(
                    //           'Error: ${state.error}',
                    //           style: const TextStyle(fontFamily: 'Poppins'),
                    //         );
                    //       }
                    //       return Container();
                    //     },
                    //   ),
                    // ),
                    // verticalMargin12,

                    // Muestra la latitud y longitud (opcional)
                    Text(
                      'Datos de su ubicación',
                      style: context.theme.textTheme.h2.copyWith(
                        fontSize: 20.0,
                      ),
                    ),
                    Text('Latitud: ${widget.latitude}'),
                    Text('Longitud: ${widget.longitude}'),
                    verticalMargin12,

                    //TextField para las notas
                    AutoSizeText(
                      AppLocalizations.of(context)!.note,
                      style: context.theme.textTheme.h2.copyWith(
                        fontSize: 20.0,
                      ),
                    ),
                    verticalMargin8,
                    TextFormField(
                      controller: noteController,
                      maxLines: 6,
                      maxLength: 150,
                      textAlign: TextAlign.justify,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecorations.authInputDecoration(
                        hintText: '',
                        labelText: AppLocalizations.of(context)!.write_comments,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: PlantaColors.colorGreen,
                          ),
                          borderRadius: borderRadius10,
                        ),
                      ),
                      onChanged: (value) {
                        noteController.text = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: allPadding16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ButtomSmall(
              color: PlantaColors.colorDarkOrange,
              onTap: () {
                warning(
                  context,
                  AppLocalizations.of(context)!.cancel_edit,
                  () async {
                    await storage.delete(key: 'lifestage');

                    Navigator.push(
                      context,
                      FadeTransitionRoute(page: const Home()),
                    );
                  },
                );
              },
              title: AppLocalizations.of(context)!.text_buttom_denied,
            ),
            ButtomSmall(
              color: PlantaColors.colorGreen,
              onTap: () async {
                warning(
                  context,
                  AppLocalizations.of(context)!.cancel_update,
                  () async {
                    if (formKey.currentState!.validate()) {
                      //  && widget.planta.lifestage.isNotEmpty
                      formKey.currentState!.save();

                      images.add(
                        ImagesMyPlant(
                          id: 0,
                          type: 'Imagen Principal',
                          posterPath: widget.valores[0]['imagen'],
                        ),
                      );

                      images.add(
                        ImagesMyPlant(
                          id: 1,
                          type: 'Imagen Tallo',
                          posterPath: widget.valores[1]['imagen'],
                        ),
                      );

                      images.add(
                        ImagesMyPlant(
                          id: 2,
                          type: 'Imagen Ramas',
                          posterPath: widget.valores[2]['imagen'],
                        ),
                      );

                      images.add(
                        ImagesMyPlant(
                          id: 3,
                          type: 'Imagen Hoja',
                          posterPath: widget.valores[3]['imagen'],
                        ),
                      );

                      images.add(
                        ImagesMyPlant(
                          id: 4,
                          type: 'Imagen Fruto',
                          posterPath: widget.valores[4]['imagen'],
                        ),
                      );

                      images.add(
                        ImagesMyPlant(
                          id: 5,
                          type: 'Imagen Flor',
                          posterPath: widget.valores[5]['imagen'],
                        ),
                      );

                      await _savePlantData(
                        note: noteController.text,
                        latitude: widget.latitude,
                        longitude: widget.longitude,
                        // lifestage: widget.planta.lifestage,
                        imagenPrincipal:
                            widget.valores.isNotEmpty
                                ? widget.valores[0]['imagen']
                                : '',
                        imagenTallo:
                            widget.valores.isNotEmpty
                                ? widget.valores[1]['imagen']
                                : '',
                        imagenRamas:
                            widget.valores.isNotEmpty
                                ? widget.valores[2]['imagen']
                                : '',
                        imagenHoja:
                            widget.valores.isNotEmpty
                                ? widget.valores[3]['imagen']
                                : '',
                        imagenFruto:
                            widget.valores.isNotEmpty
                                ? widget.valores[4]['imagen']
                                : '',
                        imagenFlor:
                            widget.valores.isNotEmpty
                                ? widget.valores[5]['imagen']
                                : '',
                        images: images,
                      );

                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: green,
                          content: Text(
                            'Planta editada con exito',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold,
                              color: PlantaColors.colorWhite,
                            ),
                          ),
                        ),
                      );
                      Navigator.push(
                        context,
                        FadeTransitionRoute(page: const Home()),
                      );
                    } else {
                      // await storage.delete(key: 'lifestage');
                      // _lifestage.currentState?.shake();
                      Navigator.pop(context);
                    }
                  },
                );
              },
              title: AppLocalizations.of(context)!.text_buttom_send,
            ),
          ],
        ),
      ),
    );
  }
}
