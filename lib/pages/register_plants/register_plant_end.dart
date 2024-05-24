// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/assets/utils/widgets/drop_buttom.dart';
import 'package:planta_tracker/assets/utils/widgets/input_decorations.dart';
import 'package:planta_tracker/models/register_plant_models.dart';
import 'package:planta_tracker/pages/home/home.dart';
import 'package:planta_tracker/services/plants_services.dart';

class RegisterPlantEnd extends StatefulWidget {
  final List<String>? pictures;

  const RegisterPlantEnd({super.key, this.pictures});

  @override
  RegisterPlantEndState createState() => RegisterPlantEndState();
}

class RegisterPlantEndState extends State<RegisterPlantEnd> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final note = TextEditingController();
  final storage = const FlutterSecureStorage();
  final OptionPlantServices optionServices = OptionPlantServices();
  RegisterPlant plant = RegisterPlant();

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
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: allPadding24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Aquí va tu lista horizontal de cámaras
              SizedBox(
                height: 150, // Ajusta la altura según necesites
                child: ListView.separated(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => horizontalMargin16,
                  itemCount: widget.pictures!.length,
                  itemBuilder: (context, index) {
                    return widget.pictures![index] != ''
                        ? Stack(
                            alignment: Alignment.topRight,
                            children: <Widget>[
                              Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: PlantaColors.colorWhite,
                                      borderRadius: borderRadius10,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: borderRadius10,
                                      child: Image.file(
                                        File(widget.pictures![index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  verticalMargin12,
                                  AutoSizeText('probando',
                                      style: context.theme.textTheme.text_01),
                                ],
                              ),
                              Positioned(
                                left: 75,
                                bottom: 115,
                                child: IconButton(
                                  icon: const Icon(Icons.loop_rounded),
                                  color: PlantaColors.colorLightRed,
                                  onPressed: () {
                                    // Acción al presionar el botón de editar
                                  },
                                ),
                              ),
                            ],
                          )
                        : emptyWidget;
                  },
                ),
              ),
              //DropdownButton
              const MyDropButtom(),
              verticalMargin16,
              //TextField para las notas
              AutoSizeText('Notas', style: context.theme.textTheme.h2),
              verticalMargin8,
              TextFormField(
                controller: note,
                maxLines: 12,
                maxLength: 150,
                textAlign: TextAlign.justify,
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Escriba su comentario aqui...',
                  labelText: 'Escriba su comentario aqui...',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: PlantaColors.colorGreen),
                    borderRadius: borderRadius10,
                  ),
                ),
                onChanged: (value) {
                  note.text = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return AppLocalizations.of(context)!.obligatory_camp;
                  }
                  return null;
                },
              ),
              // const Expanded(child: SizedBox()),
              verticalMargin16,

              ButtomLarge(
                  color: PlantaColors.colorGreen,
                  onTap: () async {
                    final lifestage = await storage.read(key: 'lifestage');

                    plant.imagenPrincipal = File(widget.pictures![0]);
                    plant.imagenTronco = File(widget.pictures![1]);
                    plant.imagenRamas = File(widget.pictures![2]);
                    plant.imagenHojas = File(widget.pictures![3]);
                    plant.imagenFlor = File(widget.pictures![5]);
                    plant.imagenFruto = File(widget.pictures![4]);

                    plant.notas = note.text;

                    plant.lifestage = lifestage;

                    EasyLoading.show();
                    try {
                      var res = await optionServices.register(plant);

                      log(res!.statusCode.toString());

                      switch (res!.statusCode) {
                        case 200:
                          log('Mision Cumplida');
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
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: PlantaColors.colorOrange,
                        content: Center(
                          child: AutoSizeText(
                            'Sin conexión',
                            style: context.theme.textTheme.text_01.copyWith(
                              color: PlantaColors.colorWhite,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ));
                    }
                  },
                  title: AppLocalizations.of(context)!.text_buttom_next),
            ],
          ),
        ),
      ),
    );
  }
}

// La direccion de las imagenes de la planta es
// https://api.planta.ngo/media/img_planta_principal/IMG_2448.JPG