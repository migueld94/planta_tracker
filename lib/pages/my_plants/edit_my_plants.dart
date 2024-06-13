// ignore_for_file: avoid_print, use_build_context_synchronously, must_be_immutable, unrelated_type_equality_checks

import 'dart:io';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:planta_tracker/pages/home/home.dart';
import 'package:planta_tracker/models/details_models.dart';
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planta_tracker/services/plants_services.dart';
import 'package:planta_tracker/services/details_services.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/models/register_plant_models.dart';
import 'package:planta_tracker/assets/utils/widgets/drop_buttom.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/widgets/input_decorations.dart';
import 'package:planta_tracker/assets/utils/widgets/animation_controller.dart';

class Edit extends StatefulWidget {
  final int id;
  const Edit({super.key, required this.id});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  DetailsServices detailsServices = DetailsServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: detailsServices.getDetails(context, widget.id),
        builder: (context, AsyncSnapshot<DetailsModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            EasyLoading.show();
            return Container();
          } else {
            EasyLoading.dismiss();
            return EditPlant(
              details: snapshot.data!,
              images: snapshot.data!.imagenes,
            );
          }
        },
      ),
    );
  }
}

class EditPlant extends StatefulWidget {
  final DetailsModel details;
  final List<Imagene>? images;
  const EditPlant({
    super.key,
    required this.details,
    required this.images,
  });

  @override
  EditPlantState createState() => EditPlantState();
}

class EditPlantState extends State<EditPlant> {
  File? _image;
  bool flag = false;
  final GlobalKey<FormState> formKey = GlobalKey();
  final note = TextEditingController();
  final storage = const FlutterSecureStorage();
  final OptionPlantServices optionServices = OptionPlantServices();
  RegisterPlant plant = RegisterPlant();
  final _lifestage = GlobalKey<ShakeWidgetState>();

  Future<File?> getImage() async {
    var cameraStatus = await Permission.camera.status;
    var locationStatus = await Permission.location.status;

    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }

    if (!locationStatus.isGranted) {
      await Permission.location.request();
    }

    if (await Permission.camera.isGranted &&
        await Permission.location.isGranted) {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      setState(() {
        if (image != null) {
          _image = File(image.path);
          flag = true;
        } else {
          //print('No se seleccionó ninguna imagen.');
        }
      });

      return _image;
    } else {
      return null;
      //print('Permiso de cámara o localización no concedido.');
    }
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
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: allPadding24,
          child: Form(
            key: formKey,
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
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      //* Aqui es pata cuando no hay imagen valida
                      if (index >= widget.images!.length) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => getImage(),
                              child: Container(
                                width: 100,
                                height: 100,
                                margin: allPadding8,
                                decoration: BoxDecoration(
                                  color: PlantaColors.colorLightGrey,
                                  borderRadius: borderRadius10,
                                ),
                                child: Center(
                                  child: Icon(
                                    Ionicons.camera_outline,
                                    color: PlantaColors.colorBlack,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      //* Caso Contrario
                      return Stack(
                        alignment: Alignment.topRight,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: allPadding8,
                            decoration: BoxDecoration(
                              color: PlantaColors.colorWhite,
                              borderRadius: borderRadius10,
                            ),
                            child: ClipRRect(
                              borderRadius: borderRadius10,
                              child: _image == null
                                  ? CachedNetworkImage(
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          '${Constants.baseUrl}${widget.images?[index].posterPath}')
                                  : Image.file(
                                      _image!,
                                      scale: 10.0,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                log('Vas a eliminar una photo');
                                setState(() {
                                  widget.images
                                      ?.removeAt(index); // Elimina la imagen
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: PlantaColors.colorWhite,
                                radius: 10,
                                child: Icon(
                                  Icons.remove_circle,
                                  color: PlantaColors.colorDarkOrange,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: GestureDetector(
                              onTap: () => getImage(),
                              child: CircleAvatar(
                                backgroundColor: PlantaColors.colorWhite,
                                radius: 10,
                                child: Icon(
                                  Icons.flip_camera_android,
                                  color: PlantaColors.colorGreen,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
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
                verticalMargin16,
                //TextField para las notas
                AutoSizeText('Notas', style: context.theme.textTheme.h2),
                verticalMargin8,
                TextFormField(
                  maxLines: 12,
                  maxLength: 150,
                  textAlign: TextAlign.justify,
                  initialValue: widget.details.notas,
                  decoration: InputDecorations.authInputDecoration(
                    hintText: '',
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtomSmall(
                      color: PlantaColors.colorDarkOrange,
                      onTap: () {
                        warning(context, 'Esta seguro de cancelar el registro?',
                            () {
                          Navigator.push(
                              context, SlideRightRoute(page: const Home()));
                        });
                      },
                      title: AppLocalizations.of(context)!.text_buttom_denied,
                    ),
                    ButtomSmall(
                        color: PlantaColors.colorGreen,
                        onTap: () async {
                          var lifestage = await storage.read(key: 'lifestage');

                          log(lifestage.toString());
                          log(widget.images!.length.toString());

                          // warning(context, 'Esta seguro de enviar el registro?',
                          //     () async {
                          //   if (formKey.currentState!.validate() &&
                          //       lifestage != null) {
                          //     formKey.currentState!.save();

                          //     plant.imagenPrincipal =
                          //         File(widget.valores[0]['imagen']);
                          //     plant.imagenTronco =
                          //         File(widget.valores[1]['imagen']);
                          //     plant.imagenRamas =
                          //         File(widget.valores[2]['imagen']);
                          //     plant.imagenHojas =
                          //         File(widget.valores[3]['imagen']);
                          //     plant.imagenFlor =
                          //         File(widget.valores[5]['imagen']);
                          //     plant.imagenFruto =
                          //         File(widget.valores[4]['imagen']);
                          //     plant.notas = note.text;
                          //     plant.lifestage = lifestage;

                          //     Navigator.pop(context);

                          //     EasyLoading.show();
                          //     try {
                          //       var res = await optionServices.register(plant);

                          //       switch (res!.statusCode) {
                          //         case 200:
                          //           final parsedResponse =
                          //               json.decode(res.body);
                          //           final successValue =
                          //               parsedResponse['success'];

                          //           ScaffoldMessenger.of(context)
                          //               .showSnackBar(SnackBar(
                          //             backgroundColor: PlantaColors.colorGreen,
                          //             content: Center(
                          //               child: AutoSizeText(
                          //                 successValue,
                          //                 style: context.theme.textTheme.text_01
                          //                     .copyWith(
                          //                   color: PlantaColors.colorWhite,
                          //                   fontSize: 16.0,
                          //                 ),
                          //               ),
                          //             ),
                          //           ));
                          //           EasyLoading.dismiss();
                          //           if (!context.mounted) return;
                          //           WidgetsBinding.instance
                          //               .addPostFrameCallback((_) async {
                          //             Navigator.push(context,
                          //                 SlideRightRoute(page: const Home()));
                          //           });
                          //           await storage.delete(key: 'lifestage');
                          //           break;
                          //         case 400:
                          //           EasyLoading.dismiss();
                          //           Navigator.push(context,
                          //               SlideRightRoute(page: const Home()));
                          //           ScaffoldMessenger.of(context)
                          //               .showSnackBar(SnackBar(
                          //             backgroundColor: PlantaColors.colorOrange,
                          //             content: Center(
                          //               child: AutoSizeText(
                          //                 res.body,
                          //                 style: context.theme.textTheme.text_01
                          //                     .copyWith(
                          //                   color: PlantaColors.colorWhite,
                          //                   fontSize: 16.0,
                          //                 ),
                          //               ),
                          //             ),
                          //           ));
                          //           break;
                          //         case 401:
                          //           EasyLoading.dismiss();
                          //           if (!context.mounted) return;
                          //           Navigator.push(context,
                          //               SlideRightRoute(page: const Home()));
                          //           ScaffoldMessenger.of(context)
                          //               .showSnackBar(SnackBar(
                          //             backgroundColor: PlantaColors.colorOrange,
                          //             content: Center(
                          //               child: AutoSizeText(
                          //                 res.body,
                          //                 style: context.theme.textTheme.text_01
                          //                     .copyWith(
                          //                   color: PlantaColors.colorWhite,
                          //                   fontSize: 16.0,
                          //                 ),
                          //               ),
                          //             ),
                          //           ));
                          //           break;
                          //         default:
                          //           EasyLoading.dismiss();
                          //           if (!context.mounted) return;
                          //           Navigator.push(context,
                          //               SlideRightRoute(page: const Home()));
                          //           ScaffoldMessenger.of(context)
                          //               .showSnackBar(SnackBar(
                          //             backgroundColor: PlantaColors.colorOrange,
                          //             content: Center(
                          //               child: AutoSizeText(
                          //                 res.body,
                          //                 style: context.theme.textTheme.text_01
                          //                     .copyWith(
                          //                   color: PlantaColors.colorWhite,
                          //                   fontSize: 16.0,
                          //                 ),
                          //               ),
                          //             ),
                          //           ));
                          //           break;
                          //       }
                          //     } on SocketException {
                          //       EasyLoading.dismiss();
                          //       Navigator.push(context,
                          //           SlideRightRoute(page: const Home()));
                          //       ScaffoldMessenger.of(context)
                          //           .showSnackBar(SnackBar(
                          //         backgroundColor: PlantaColors.colorOrange,
                          //         content: Center(
                          //           child: AutoSizeText(
                          //             'Sin conexión',
                          //             style: context.theme.textTheme.text_01
                          //                 .copyWith(
                          //               color: PlantaColors.colorWhite,
                          //               fontSize: 16.0,
                          //             ),
                          //           ),
                          //         ),
                          //       ));
                          //     }
                          //   } else {
                          //     _lifestage.currentState?.shake();
                          //     Navigator.pop(context);
                          //   }
                          // });
                        },
                        title: AppLocalizations.of(context)!.text_buttom_send),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
