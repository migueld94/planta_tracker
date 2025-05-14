// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/models/plantas_hive.dart';
import 'package:planta_tracker/pages/my_plants/edit/edit_plant_3.dart';
import 'package:planta_tracker/services/plants_services.dart';

class GetApiEditInformation02 extends StatefulWidget {
  final int index;
  final Planta planta;
  // final List<File> pictures;
  List<Map<String, dynamic>> valores = [
    {"imagen": "", "name": ""},
  ];
  GetApiEditInformation02({
    required this.planta,
    required this.valores,
    required this.index,
    super.key,
  });

  @override
  State<GetApiEditInformation02> createState() =>
      _GetApiEditInformation02State();
}

class _GetApiEditInformation02State extends State<GetApiEditInformation02> {
  OptionPlantServices detailsEditServices = OptionPlantServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EditPlants02(
        // pictures: widget.pictures,
        valores: widget.valores,
        planta: widget.planta,
        index: widget.index,
      ),
    );
  }
}

class EditPlants02 extends StatefulWidget {
  // final List<File> pictures;
  List<Map<String, dynamic>> valores = [
    {"imagen": "", "name": ""},
  ];
  final Planta planta;
  final int index;
  EditPlants02({
    // required this.pictures,
    required this.valores,
    required this.planta,
    required this.index,
    super.key,
  });

  @override
  State<EditPlants02> createState() => _EditPlants02State();
}

class _EditPlants02State extends State<EditPlants02> {
  File? _image;
  bool flag = false;
  final List<File> pic = [];
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
          widget.planta.images[1].posterPath = null;
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
      body: PopScope(
        canPop: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if ((_image != null) ||
                  (widget.planta.images[1].posterPath != null) &&
                      (!widget.planta.images[1].posterPath!
                          .split('/')
                          .last
                          .endsWith("De7au1t.png")))
                Flexible(
                  child: AutoSizeText(
                    AppLocalizations.of(context)!.take_photo,
                    style: context.theme.textTheme.text_01.copyWith(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              verticalMargin57,
              if (widget.planta.images[1].posterPath == null ||
                  widget.planta.images[1].posterPath!
                      .split('/')
                      .last
                      .endsWith("De7au1t.png"))
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => getImage(),
                      child: Stack(
                        children: [
                          Container(
                            padding: allPadding16,
                            decoration: BoxDecoration(
                              color:
                                  _image != null
                                      ? null
                                      : PlantaColors.colorWhite,
                              borderRadius: borderRadius10,
                              boxShadow: [
                                if (_image == null)
                                  BoxShadow(
                                    offset: const Offset(5, 7),
                                    blurRadius: 12,
                                    color: PlantaColors.colorBlack.withOpacity(
                                      0.3,
                                    ),
                                  ),
                              ],
                            ),
                            child:
                                _image != null
                                    ? ClipRRect(
                                      borderRadius: borderRadius10,
                                      child: Image.file(_image!),
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
                    verticalMargin16,
                    if (_image == null)
                      AutoSizeText(
                        widget.planta.images[1].type,
                        style: context.theme.textTheme.text_01,
                      ),
                  ],
                ),
              if (widget.planta.images[1].posterPath != null &&
                  !widget.planta.images[1].posterPath!
                      .split('/')
                      .last
                      .endsWith("De7au1t.png"))
                GestureDetector(
                  onTap: () => getImage(),
                  child: Stack(
                    children: [
                      Container(
                        padding: allPadding16,
                        child: ClipRRect(
                          borderRadius: borderRadius10,
                          child: Image.file(
                            File(widget.planta.images[1].posterPath!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.planta.images[1].posterPath = null;
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
      ),
      bottomSheet: Padding(
        padding: allPadding16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.planta.images[1].posterPath != null &&
                    !widget.planta.images[1].posterPath!
                        .split('/')
                        .last
                        .endsWith("De7au1t.png")
                ? emptyWidget
                : ButtomSkip(
                  color: PlantaColors.colorTransparent,
                  onTap: () async {
                    if ((_image != null) &&
                        (widget.planta.images[1].posterPath == null)) {
                      null;
                    } else if ((_image == null) &&
                        (widget.planta.images[1].posterPath != null &&
                            !widget.planta.images[1].posterPath!
                                .split('/')
                                .last
                                .endsWith("De7au1t.png"))) {
                      null;
                    } else {
                      File f = await optionServices.getImageFileFromAssets(
                        Constants.noPicture,
                      );

                      widget.valores.add({
                        "imagen": f.path,
                        "name": widget.planta.images[1].type,
                      });

                      Navigator.push(
                        context,
                        SlideRightRoute(
                          page: GetApiEditInformation03(
                            planta: widget.planta,
                            valores: widget.valores,
                            index: widget.index,
                          ),
                        ),
                      );
                    }
                  },
                  title: AppLocalizations.of(context)!.skip,
                  colorText: getColorOmitir(),
                ),
            ButtomSmall(
              color: getColor(),
              onTap: () async {
                if ((_image == null) &&
                    (widget.planta.images[1].posterPath == null ||
                        widget.planta.images[1].posterPath!
                            .split('/')
                            .last
                            .endsWith("De7au1t.png"))) {
                  null;
                } else if (_image != null) {
                  //Si tomo la foto
                  widget.valores.add({
                    "imagen": _image!.path,
                    "name": widget.planta.images[1].type,
                  });

                  Navigator.push(
                    context,
                    SlideRightRoute(
                      page: GetApiEditInformation03(
                        planta: widget.planta,
                        valores: widget.valores,
                        index: widget.index,
                      ),
                    ),
                  );
                } else {
                  widget.valores.add({
                    "imagen": widget.planta.images[1].posterPath,
                    "name":
                        AppLocalizations.of(
                          context,
                        )!.plant_register_trunk_image,
                  });

                  Navigator.push(
                    context,
                    SlideRightRoute(
                      page: GetApiEditInformation03(
                        planta: widget.planta,
                        valores: widget.valores,
                        index: widget.index,
                      ),
                    ),
                  );
                }
              },
              title: AppLocalizations.of(context)!.text_buttom_next,
            ),
          ],
        ),
      ),
    );
  }

  Color getColor() {
    if ((_image != null) && (widget.planta.images[1].posterPath == null)) {
      return PlantaColors.colorGreen;
    } else if ((_image == null) &&
        (widget.planta.images[1].posterPath != null &&
            !widget.planta.images[1].posterPath!
                .split('/')
                .last
                .endsWith("De7au1t.png"))) {
      return PlantaColors.colorGreen;
    } else {
      return PlantaColors.colorGrey;
    }
  }

  Color getColorOmitir() {
    if ((_image != null) && (widget.planta.images[1].posterPath == null)) {
      return PlantaColors.colorGrey;
    } else if ((_image == null) &&
        (widget.planta.images[1].posterPath != null &&
            !widget.planta.images[1].posterPath!
                .split('/')
                .last
                .endsWith("De7au1t.png"))) {
      return PlantaColors.colorGrey;
    } else {
      return PlantaColors.colorBlack;
    }
  }
}
