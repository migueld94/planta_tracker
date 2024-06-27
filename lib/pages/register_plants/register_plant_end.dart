// ignore_for_file: avoid_print, use_build_context_synchronously, must_be_immutable, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/widgets/animation_controller.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/assets/utils/widgets/drop_buttom.dart';
import 'package:planta_tracker/assets/utils/widgets/input_decorations.dart';
import 'package:planta_tracker/models/register_plant_models.dart';
import 'package:planta_tracker/pages/home/home.dart';
import 'package:planta_tracker/services/plants_services.dart';

class RegisterPlantEnd extends StatefulWidget {
  // final List<String>? pictures;

  List<Map<String, dynamic>> valores = [
    {"imagen": "", "name": ""}
  ];

  RegisterPlantEnd({super.key, required this.valores});

  @override
  RegisterPlantEndState createState() => RegisterPlantEndState();
}

class RegisterPlantEndState extends State<RegisterPlantEnd> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final note = TextEditingController();
  final storage = const FlutterSecureStorage();
  final OptionPlantServices optionServices = OptionPlantServices();
  RegisterPlant plant = RegisterPlant();
  final _lifestage = GlobalKey<ShakeWidgetState>();

  @override
  void initState() {
    super.initState();
    note.addListener(() {
    });
  }
  
  @override
  void dispose() {
    note.dispose();
    super.dispose();
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
                  // Aquí va tu lista horizontal de cámaras
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
                        final fileName = file.split('/').last;
                        if (fileName.endsWith("De7au1t.png")) {
                          return null;
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
                    child: const MyDropButtom(),
                  ),
                  verticalMargin12,
                  //TextField para las notas
                  AutoSizeText(
                    AppLocalizations.of(context)!.note,
                    style: context.theme.textTheme.h2,
                  ),
                  verticalMargin8,
                  TextFormField(
                    controller: note,
                    maxLines: 6,
                    maxLength: 150,
                    textAlign: TextAlign.justify,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: AppLocalizations.of(context)!.write_comments,
                      labelText: AppLocalizations.of(context)!.write_comments,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: PlantaColors.colorGreen),
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
      bottomNavigationBar: Padding(
        padding: allPadding16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ButtomSmall(
              color: PlantaColors.colorDarkOrange,
              onTap: () {
                warning(context,
                    AppLocalizations.of(context)!.message_cancel_register, () {
                  Navigator.push(context, SlideRightRoute(page: const Home()));
                });
              },
              title: AppLocalizations.of(context)!.text_buttom_denied,
            ),
            ButtomSmall(
              color: PlantaColors.colorGreen,
              onTap: () async {
                var lifestage = await storage.read(key: 'lifestage');

                warning(context,
                    AppLocalizations.of(context)!.message_send_register,
                    () async {
                  if (formKey.currentState!.validate() && lifestage != null) {
                    formKey.currentState!.save();

                    plant.imagenPrincipal = File(widget.valores[0]['imagen']);
                    plant.imagenTronco = File(widget.valores[1]['imagen']);
                    plant.imagenRamas = File(widget.valores[2]['imagen']);
                    plant.imagenHojas = File(widget.valores[3]['imagen']);
                    plant.imagenFlor = File(widget.valores[5]['imagen']);
                    plant.imagenFruto = File(widget.valores[4]['imagen']);

                    plant.notas = note.text;
                    plant.lifestage = lifestage;

                    Navigator.pop(context);

                    EasyLoading.show();
                    try {
                      var res = await optionServices.register(plant);

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
                                style: context.theme.textTheme.text_01.copyWith(
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
                          break;
                        case 400:
                          EasyLoading.dismiss();
                          Navigator.push(
                              context, SlideRightRoute(page: const Home()));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: PlantaColors.colorOrange,
                            content: Center(
                              child: AutoSizeText(
                                res.body,
                                style: context.theme.textTheme.text_01.copyWith(
                                  color: PlantaColors.colorWhite,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ));
                          break;
                        case 401:
                          EasyLoading.dismiss();
                          if (!context.mounted) return;
                          Navigator.push(
                              context, SlideRightRoute(page: const Home()));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: PlantaColors.colorOrange,
                            content: Center(
                              child: AutoSizeText(
                                res.body,
                                style: context.theme.textTheme.text_01.copyWith(
                                  color: PlantaColors.colorWhite,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ));
                          break;
                        default:
                          EasyLoading.dismiss();
                          if (!context.mounted) return;
                          Navigator.push(
                              context, SlideRightRoute(page: const Home()));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: PlantaColors.colorOrange,
                            content: Center(
                              child: AutoSizeText(
                                res.body,
                                style: context.theme.textTheme.text_01.copyWith(
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
                    Navigator.pop(context);

                    _lifestage.currentState?.shake();
                    alert(
                      context,
                      AppLocalizations.of(context)!.select_lifestage,
                    );
                  }
                });
              },
              title: AppLocalizations.of(context)!.text_buttom_send,
            ),
          ],
        ),
      ),
    );
  }
}
