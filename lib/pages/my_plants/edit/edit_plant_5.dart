// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/models/details_edit_model.dart';
import 'package:planta_tracker/pages/my_plants/edit/edit_plant_6.dart';
import 'package:planta_tracker/services/plants_services.dart';

class GetApiEditInformation05 extends StatefulWidget {
  final int id;
  // final List<File> pictures;
  List<Map<String, dynamic>> valores = [
    {"imagen": "", "name": ""}
  ];

  GetApiEditInformation05({
    required this.id,
    // required this.pictures,
    required this.valores,
    super.key,
  });

  @override
  State<GetApiEditInformation05> createState() =>
      _GetApiEditInformation05State();
}

class _GetApiEditInformation05State extends State<GetApiEditInformation05> {
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
            return EditPlants05(
              // pictures: widget.pictures,
              valores: widget.valores,
              details: snapshot.data!,
              images: snapshot.data!.imageneseditar,
            );
          }
        },
      ),
    );
  }
}

class EditPlants05 extends StatefulWidget {
  // final List<File> pictures;
  final DetailsEditPlant details;
  final List<Imageneseditar>? images;
  List<Map<String, dynamic>> valores = [
    {"imagen": "", "name": ""}
  ];

  EditPlants05({
    // required this.pictures,
    required this.valores,
    required this.details,
    required this.images,
    super.key,
  });

  @override
  State<EditPlants05> createState() => _EditPlants05State();
}

class _EditPlants05State extends State<EditPlants05> {
  File? _image;
  bool flag = false;
  final OptionPlantServices optionServices = OptionPlantServices();

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
          widget.images![4].posterPath = null;
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (flag == true)
              Flexible(
                child: AutoSizeText(
                  'Para volver a tomar la foto pulse la imagén',
                  style: context.theme.textTheme.text_01.copyWith(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            verticalMargin57,
            if (widget.images![4].posterPath == null)
              Column(
                children: [
                  GestureDetector(
                    onTap: () => getImage(),
                    child: Stack(
                      children: [
                        Container(
                          padding: allPadding16,
                          decoration: BoxDecoration(
                              color: _image != null
                                  ? null
                                  : PlantaColors.colorWhite,
                              borderRadius: borderRadius10,
                              boxShadow: [
                                if (_image == null)
                                  BoxShadow(
                                    offset: const Offset(5, 7),
                                    blurRadius: 12,
                                    color: PlantaColors.colorBlack
                                        .withOpacity(0.3),
                                  ),
                              ]),
                          child: _image != null
                              ? ClipRRect(
                                  borderRadius: borderRadius10,
                                  child: Image.file(
                                    _image!,
                                  ),
                                )
                              : Icon(
                                  Ionicons.camera_outline,
                                  size: 40,
                                  color: PlantaColors.colorOrange,
                                ),
                        ),
                        if (_image != null)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _image = null;
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: PlantaColors.colorWhite,
                                radius: 20.0,
                                child: Icon(
                                  Ionicons.close_circle_outline,
                                  color: PlantaColors.colorDarkOrange,
                                  size: 25.0,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (_image == null)
                    AutoSizeText(
                      '${widget.images![4].type}',
                      style: context.theme.textTheme.text_01,
                    ),
                ],
              ),
            if (widget.images![4].posterPath != null)
              GestureDetector(
                onTap: () => getImage(),
                child: Stack(
                  children: [
                    Container(
                      padding: allPadding16,
                      child: ClipRRect(
                        borderRadius: borderRadius10,
                        child: CachedNetworkImage(
                          filterQuality: FilterQuality.low,
                          fit: BoxFit.cover,
                          imageUrl:
                              '${Constants.baseUrl}${widget.images![4].posterPath}',
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.images![4].posterPath = null;
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: PlantaColors.colorWhite,
                          radius: 20.0,
                          child: Icon(
                            Ionicons.close_circle_outline,
                            color: PlantaColors.colorDarkOrange,
                            size: 25.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: allPadding24,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.images![4].posterPath != null
                ? emptyWidget
                : ButtomSkip(
                    color: PlantaColors.colorTransparent,
                    onTap: () async {
                      if ((_image != null) &&
                          (widget.images![4].posterPath == null)) {
                        null;
                      } else if ((_image == null) &&
                          (widget.images![4].posterPath != null)) {
                        null;
                      } else {
                        File f = await optionServices
                            .getImageFileFromAssets(Constants.noPicture);

                        // widget.pictures.add(f);
                        // log(widget.pictures.toString());

                        widget.valores
                            .add({"imagen": f, "name": widget.images![4].type});

                        Navigator.push(
                            context,
                            SlideRightRoute(
                                page: GetApiEditInformation06(
                              id: widget.details.id!,
                              valores: widget.valores,
                              // pictures: widget.pictures,
                            )));
                        // return PlantaColors.colorBlack;
                      }
                    },
                    title: 'Omitir',
                    colorText: getColorOmitir(),
                  ),
            ButtomSmall(
                color: getColor(),
                onTap: () async {
                  if ((_image != null) &&
                      (widget.images![4].posterPath == null)) {
                    // return PlantaColors.colorGreen;
                    if (flag == true) {
                      // widget.pictures.add(_image!);
                      // log(widget.pictures.toString());

                      widget.valores.add(
                          {"imagen": _image!, "name": widget.images![4].type});

                      Navigator.push(
                          context,
                          SlideRightRoute(
                              page: GetApiEditInformation06(
                            id: widget.details.id!,
                            valores: widget.valores,
                            // pictures: widget.pictures,
                          )));
                    } else {
                      EasyLoading.show();
                      try {
                        final String foto =
                            '${Constants.baseUrl}${widget.images?[4].posterPath}';
                        final pictureFile = await urlToFile(foto);
                        EasyLoading.dismiss();

                        // widget.pictures.add(pictureFile);
                        // log(widget.pictures.toString());
                        widget.valores.add({
                          "imagen": pictureFile,
                          "name": widget.images![4].type
                        });

                        Navigator.push(
                            context,
                            SlideRightRoute(
                                page: GetApiEditInformation06(
                              id: widget.details.id!,
                              valores: widget.valores,
                            )));
                      } on Exception catch (e) {
                        log(e.toString());
                        throw Exception('Something Error');
                      }
                    }
                  } else if ((_image == null) &&
                      (widget.images![4].posterPath != null)) {
                    // return PlantaColors.colorGreen;
                    if (flag == true) {
                      // widget.pictures.add(_image!);
                      // log(widget.pictures.toString());

                      widget.valores.add({
                        "imagen": _image!,
                        "name": widget.images![4].type,
                      });

                      Navigator.push(
                          context,
                          SlideRightRoute(
                              page: GetApiEditInformation06(
                            id: widget.details.id!,
                            valores: widget.valores,
                          )));
                    } else {
                      EasyLoading.show();

                      try {
                        final String foto =
                            '${Constants.baseUrl}${widget.images?[4].posterPath}';
                        final pictureFile = await urlToFile(foto);
                        EasyLoading.show();
                        // widget.pictures.add(pictureFile);
                        // log(widget.pictures.toString());
                        widget.valores.add({
                          "imagen": pictureFile,
                          "name": widget.images![4].type
                        });

                        Navigator.push(
                            context,
                            SlideRightRoute(
                                page: GetApiEditInformation06(
                              id: widget.details.id!,
                              valores: widget.valores,
                            )));
                      } on Exception catch (e) {
                        log(e.toString());
                        throw Exception('Something Error');
                      }
                    }
                  } else {
                    // return PlantaColors.colorGrey;
                    null;
                  }
                },
                title: AppLocalizations.of(context)!.text_buttom_next),
          ],
        ),
      ),
    );
  }

  Color getColor() {
    if ((_image != null) && (widget.images![4].posterPath == null)) {
      return PlantaColors.colorGreen;
    } else if ((_image == null) && (widget.images![4].posterPath != null)) {
      return PlantaColors.colorGreen;
    } else {
      return PlantaColors.colorGrey;
    }
  }

  Color getColorOmitir() {
    if ((_image != null) && (widget.images![4].posterPath == null)) {
      return PlantaColors.colorGrey;
    } else if ((_image == null) && (widget.images![4].posterPath != null)) {
      return PlantaColors.colorGrey;
    } else {
      return PlantaColors.colorBlack;
    }
  }
}
