// ignore_for_file: avoid_print, use_build_context_synchronously, must_be_immutable, unrelated_type_equality_checks

import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/assets/utils/widgets/input_decorations.dart';
import 'package:planta_tracker/models/nom_lifestage.dart';
import 'package:planta_tracker/models/plantas_hive.dart';
import 'package:planta_tracker/models/register_plant_models.dart';
import 'package:planta_tracker/pages/home/home.dart';
import 'package:planta_tracker/services/plants_services.dart';
import 'package:uuid/uuid.dart';

class RegisterPlantEnd extends StatefulWidget {
  final double latitude;
  final double longitude;
  List<Map<String, dynamic>> valores = [
    {"imagen": "", "name": ""},
  ];

  RegisterPlantEnd({
    super.key,
    required this.valores,
    required this.latitude,
    required this.longitude,
  });

  @override
  RegisterPlantEndState createState() => RegisterPlantEndState();
}

class RegisterPlantEndState extends State<RegisterPlantEnd> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final note = TextEditingController();
  final storage = const FlutterSecureStorage();
  final OptionPlantServices optionServices = OptionPlantServices();
  RegisterPlant plant = RegisterPlant();
  // final _lifestage = GlobalKey<ShakeWidgetState>();
  Result? result;
  // Lifestage? free;
  bool avaliable = false;
  // String lifestage = '';
  List<ImagesMyPlant> images = [];

  @override
  void initState() {
    super.initState();
    note.addListener(() {});
  }

  @override
  void dispose() {
    note.dispose();
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
    String? status,
  }) async {
    var uuid = Uuid();
    var box = await Hive.openBox<Planta>('plantasBox');

    String id = '${uuid.v4()}_${DateTime.now().millisecondsSinceEpoch}';

    Planta newPlant = Planta(
      id: id,
      imagenPricipal: imagenPrincipal,
      imagenTallo: imagenTallo,
      imagenRamas: imagenRamas,
      imagenHoja: imagenHoja,
      imagenFruto: imagenFruto,
      imagenFlor: imagenFlor,
      latitude: latitude,
      longitude: longitude,
      // lifestage: lifestage,
      nota: note,
      fechaCreacion: DateTime.now(),
      images: images,
      status: status,
    );

    await box.add(newPlant);
    Navigator.push(context, FadeTransitionRoute(page: const Home()));
    log('Se creo la planta');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: PlantaColors.colorGreen,
        title: AutoSizeText(
          AppLocalizations.of(context)!.plant_register,
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
                    // Aquí va tu lista horizontal de cámaras
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
                    // BlocBuilder<LifestageNomBloc, LifestageNomState>(
                    //   builder: (context, state) {
                    //     if (state is LifestageNomLoading &&
                    //         state is! LifestageNomLoaded) {
                    //       return const Center(child: CircularPlantaTracker());
                    //     } else if (state is LifestageNomLoaded ||
                    //         state is LifestageNomBackgroundLoading) {
                    //       free =
                    //           (state is LifestageNomLoaded)
                    //               ? state.lifestage
                    //               : (state as LifestageNomBackgroundLoading)
                    //                   .lifestage;

                    //       return free!.results.isNotEmpty
                    //           ? Container(
                    //             decoration: BoxDecoration(
                    //               border: Border.all(color: Colors.grey),
                    //               borderRadius: borderRadius10,
                    //             ),
                    //             child: DropdownButtonHideUnderline(
                    //               child: DropdownButton2<Result>(
                    //                 dropdownStyleData: DropdownStyleData(
                    //                   decoration: BoxDecoration(
                    //                     border: Border.all(color: Colors.grey),
                    //                     borderRadius: borderRadius10,
                    //                   ),
                    //                 ),
                    //                 isExpanded: true,
                    //                 style: const TextStyle(
                    //                   fontFamily: 'Poppins',
                    //                 ),
                    //                 hint: Text(
                    //                   'Lifestage',
                    //                   style: TextStyle(fontFamily: 'Poppins'),
                    //                 ),
                    //                 value: result,
                    //                 onChanged: (Result? newValue) {
                    //                   if (newValue != null) {
                    //                     setState(() {
                    //                       result = newValue;
                    //                       lifestage = newValue.nombre;
                    //                     });
                    //                     log('Lifestage => ${newValue.nombre}');
                    //                   }
                    //                 },
                    //                 items:
                    //                     free!.results
                    //                         .map<DropdownMenuItem<Result>>((
                    //                           Result lifestage,
                    //                         ) {
                    //                           return DropdownMenuItem<Result>(
                    //                             value: lifestage,
                    //                             child: Text(
                    //                               lifestage.nombre,
                    //                               style: context
                    //                                   .theme
                    //                                   .textTheme
                    //                                   .h3
                    //                                   .copyWith(
                    //                                     fontWeight:
                    //                                         FontWeight.normal,
                    //                                   ),
                    //                             ),
                    //                           );
                    //                         })
                    //                         .toList(),
                    //               ),
                    //             ),
                    //           )
                    //           : Padding(
                    //             padding: const EdgeInsets.symmetric(
                    //               horizontal: 16.0,
                    //             ),
                    //             child: Text(
                    //               'No hay elementos',
                    //               style: const TextStyle(
                    //                 fontFamily: 'Poppins',
                    //                 color: Colors.red,
                    //               ),
                    //             ),
                    //           );
                    //     } else if (state is LifestageNomError) {
                    //       return Text(
                    //         'Error: ${state.error}',
                    //         style: const TextStyle(fontFamily: 'Poppins'),
                    //       );
                    //     }
                    //     return Container();
                    //   },
                    // ),
                    // verticalMargin12,
                    // if (latitude == null && longitude == null)
                    //   Text(
                    //     'Cargando datos de su ubicación... Por favor espere.',
                    //   ),
                    // verticalMargin8,
                    // Muestra la latitud y longitud (opcional)
                    // if (latitude != null && longitude != null) ...[
                    Text(
                      'Datos de su ubicación',
                      style: context.theme.textTheme.h2.copyWith(
                        fontSize: 20.0,
                      ),
                    ),
                    Text('Latitud: ${widget.latitude}'),
                    Text('Longitud: ${widget.longitude}'),
                    // ],
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
                      controller: note,
                      maxLines: 6,
                      maxLength: 150,
                      textAlign: TextAlign.justify,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecorations.authInputDecoration(
                        hintText: AppLocalizations.of(context)!.write_comments,
                        labelText: AppLocalizations.of(context)!.write_comments,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: PlantaColors.colorGreen,
                          ),
                          borderRadius: borderRadius10,
                        ),
                      ),
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
                  AppLocalizations.of(context)!.message_cancel_register,
                  () {
                    Navigator.push(
                      context,
                      SlideRightRoute(page: const Home()),
                    );
                  },
                );
              },
              title: AppLocalizations.of(context)!.text_buttom_denied,
            ),
            ButtomSmall(
              color: PlantaColors.colorGreen,
              onTap:
                  avaliable
                      ? null
                      : () async {
                        // if (lifestage.isEmpty) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       backgroundColor: PlantaColors.colorDarkOrange,
                        //       content: Text(
                        //         'Debe seleccionar el lifestage para el registro',
                        //         style: context.theme.textTheme.text_01.copyWith(
                        //           color: PlantaColors.colorWhite,
                        //           fontSize: 16.0,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     ),
                        //   );
                        // } else

                        if (formKey.currentState!.validate()) {
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
                            note: note.text,
                            latitude: widget.latitude,
                            longitude: widget.longitude,
                            // lifestage: lifestage,
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
                            status: 'Sin enviar',
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: PlantaColors.colorGreen,
                              content: Center(
                                child: AutoSizeText(
                                  'Planta guardada con exito',
                                  style: context.theme.textTheme.text_01
                                      .copyWith(
                                        color: PlantaColors.colorWhite,
                                        fontSize: 16.0,
                                      ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
              title: AppLocalizations.of(context)!.text_buttom_send,
            ),
          ],
        ),
      ),
    );
  }
}
