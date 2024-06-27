// ignore_for_file: avoid_print, use_build_context_synchronously, must_be_immutable, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planta_tracker/models/details_edit_model.dart';

import 'package:planta_tracker/pages/home/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planta_tracker/services/plants_services.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/models/register_plant_models.dart';
import 'package:planta_tracker/assets/utils/widgets/drop_buttom.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/widgets/input_decorations.dart';
import 'package:planta_tracker/assets/utils/widgets/animation_controller.dart';

class GetApiEditInformationEnd extends StatefulWidget {
  final int id;
  // final List<File> pictures;
  List<Map<String, dynamic>> valores = [
    {"imagen": "", "name": ""}
  ];

  GetApiEditInformationEnd({
    required this.id,
    required this.valores,
    // required this.pictures,
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
      body: FutureBuilder(
        future: detailsEditServices.getDetailsEdit(context, widget.id),
        builder: (context, AsyncSnapshot<DetailsEditPlant> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            EasyLoading.show();
            return Container();
          } else {
            EasyLoading.dismiss();
            return EditPlant(
              valores: widget.valores,
              // pictures: widget.pictures,
              details: snapshot.data!,
              images: snapshot.data!.imageneseditar,
            );
          }
        },
      ),
    );
  }
}

class EditPlant extends StatefulWidget {
  // final List<File> pictures;
  List<Map<String, dynamic>> valores = [
    {"imagen": "", "name": ""}
  ];

  final DetailsEditPlant details;
  final List<Imageneseditar>? images;
  EditPlant({
    // required this.pictures,
    required this.valores,
    required this.details,
    required this.images,
    super.key,
  });

  @override
  EditPlantState createState() => EditPlantState();
}

class EditPlantState extends State<EditPlant> {
  List<File> imageFile = [];
  bool flag = false;
  final GlobalKey<FormState> formKey = GlobalKey();
  final noteController = TextEditingController();
  String notes = '';
  final storage = const FlutterSecureStorage();
  final OptionPlantServices optionServices = OptionPlantServices();
  RegisterPlant plant = RegisterPlant();
  final _lifestage = GlobalKey<ShakeWidgetState>();

  Future<void> _loadTextFromApi() async {
    final response = widget.details.notas;
    setState(() {
      noteController.text = response!;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTextFromApi();
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List<File> filteredFiles = widget.valores['imagen']
    //     .where((file) => file.path.split('/').last != 'De7au1t.png')
    //     .toList();

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
      body: Padding(
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
                      separatorBuilder: (context, index) => horizontalMargin16,
                      itemCount: widget.valores.length,
                      itemBuilder: (context, index) {
                        final valor = widget.valores[index];
                        final file = valor["imagen"];
                        final fileName = file.path.split('/').last;
                        if (fileName.endsWith("De7au1t.png")) {
                          return null; // or return null to not show anything
                        } else {
                          return Column(
                            children: [
                              Container(
                                width: 180,
                                height: 110,
                                margin: allPadding8,
                                decoration: BoxDecoration(
                                  color: PlantaColors.colorWhite,
                                  borderRadius: borderRadius10,
                                ),
                                child: ClipRRect(
                                  borderRadius: borderRadius10,
                                  child: Image.file(
                                    widget.valores[index]['imagen'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              AutoSizeText(widget.valores[index]['name'],
                                  style: context.theme.textTheme.text_01),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  //* DropdownButton
                  ShakeWidget(
                    key: _lifestage,
                    duration: const Duration(seconds: 1),
                    shakeCount: 3,
                    shakeOffset: 2,
                    child: MyDropButtomEdit(
                      value: widget.details.lifestage ?? '',
                    ),
                  ),
                  verticalMargin12,
                  //TextField para las notas
                  AutoSizeText(
                    AppLocalizations.of(context)!.note,
                    style: context.theme.textTheme.h2,
                  ),
                  verticalMargin8,
                  TextFormField(
                    controller: noteController,
                    maxLines: null,
                    maxLength: 150,
                    textAlign: TextAlign.justify,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: '',
                      labelText: AppLocalizations.of(context)!.write_comments,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: PlantaColors.colorGreen),
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
      bottomNavigationBar: Padding(
        padding: allPadding16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ButtomSmall(
              color: PlantaColors.colorDarkOrange,
              onTap: () {
                warning(context, AppLocalizations.of(context)!.cancel_edit,
                    () async {
                  await storage.delete(key: 'lifestage');

                  Navigator.push(context, SlideRightRoute(page: const Home()));
                });
              },
              title: AppLocalizations.of(context)!.text_buttom_denied,
            ),
            ButtomSmall(
                color: PlantaColors.colorGreen,
                onTap: () async {
                  var lifestage = await storage.read(key: 'lifestage');
                  // await storage.delete(key: 'lifestage');

                  lifestage ??= widget.details.lifestage;

                  warning(context, AppLocalizations.of(context)!.cancel_update,
                      () async {
                    if (formKey.currentState!.validate() && lifestage != null) {
                      formKey.currentState!.save();

                      plant.imagenPrincipal = widget.valores[0]['imagen'];
                      // plant.imagenPrincipal = widget.pictures[0];
                      plant.imagenTronco = widget.valores[1]['imagen'];
                      // plant.imagenTronco = widget.pictures[1];
                      plant.imagenRamas = widget.valores[2]['imagen'];
                      // plant.imagenRamas = widget.pictures[2];
                      plant.imagenHojas = widget.valores[3]['imagen'];
                      // plant.imagenHojas = widget.pictures[3];
                      plant.imagenFlor = widget.valores[5]['imagen'];
                      // plant.imagenFlor = widget.pictures[5];
                      plant.imagenFruto = widget.valores[4]['imagen'];
                      // plant.imagenFruto = widget.pictures[4];

                      plant.notas = noteController.text;
                      plant.lifestage = lifestage;

                      Navigator.pop(context);

                      EasyLoading.show();
                      try {
                        var res = await optionServices.updatePlant(
                            plant, widget.details.id.toString());

                        switch (res!.statusCode) {
                          case 200:
                            final parsedResponse = json.decode(res.body);
                            final successValue = parsedResponse['success'];
                            await storage.delete(key: 'lifestage');

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: PlantaColors.colorGreen,
                              content: Center(
                                child: AutoSizeText(
                                  successValue,
                                  style:
                                      context.theme.textTheme.text_01.copyWith(
                                    color: PlantaColors.colorWhite,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ));
                            EasyLoading.dismiss();
                            if (!context.mounted) return;
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) async {
                              Navigator.push(
                                  context, SlideRightRoute(page: const Home()));
                            });
                            await storage.delete(key: 'lifestage');
                            break;
                          case 400:
                            EasyLoading.dismiss();
                            await storage.delete(key: 'lifestage');

                            Navigator.push(
                                context, SlideRightRoute(page: const Home()));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: PlantaColors.colorOrange,
                              content: Center(
                                child: AutoSizeText(
                                  res.body,
                                  style:
                                      context.theme.textTheme.text_01.copyWith(
                                    color: PlantaColors.colorWhite,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ));
                            break;
                          case 401:
                            EasyLoading.dismiss();
                            await storage.delete(key: 'lifestage');

                            if (!context.mounted) return;
                            Navigator.push(
                                context, SlideRightRoute(page: const Home()));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: PlantaColors.colorOrange,
                              content: Center(
                                child: AutoSizeText(
                                  res.body,
                                  style:
                                      context.theme.textTheme.text_01.copyWith(
                                    color: PlantaColors.colorWhite,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ));
                            break;
                          default:
                            EasyLoading.dismiss();
                            await storage.delete(key: 'lifestage');

                            if (!context.mounted) return;
                            Navigator.push(
                                context, SlideRightRoute(page: const Home()));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: PlantaColors.colorOrange,
                              content: Center(
                                child: AutoSizeText(
                                  res.body,
                                  style:
                                      context.theme.textTheme.text_01.copyWith(
                                    color: PlantaColors.colorWhite,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ));
                            break;
                        }
                      } on SocketException {
                        EasyLoading.dismiss();
                        await storage.delete(key: 'lifestage');

                        Navigator.push(
                            context, SlideRightRoute(page: const Home()));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: PlantaColors.colorOrange,
                          content: Center(
                            child: AutoSizeText(
                              AppLocalizations.of(context)!.no_internet,
                              style: context.theme.textTheme.text_01.copyWith(
                                color: PlantaColors.colorWhite,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ));
                      }
                    } else {
                      await storage.delete(key: 'lifestage');
                      _lifestage.currentState?.shake();
                      Navigator.pop(context);
                    }
                  });
                },
                title: AppLocalizations.of(context)!.text_buttom_send),
          ],
        ),
      ),
    );
  }
}
