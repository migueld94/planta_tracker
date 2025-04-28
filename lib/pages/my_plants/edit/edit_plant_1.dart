// ignore_for_file: use_build_context_synchronously, unused_element
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:exif/exif.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/models/details_edit_model.dart';
import 'package:planta_tracker/pages/my_plants/edit/edit_plant_2.dart';
import 'package:planta_tracker/services/plants_services.dart';

class GetApiEditInformation01 extends StatefulWidget {
  final int id;
  const GetApiEditInformation01({super.key, required this.id});

  @override
  State<GetApiEditInformation01> createState() =>
      _GetApiEditInformation01State();
}

class _GetApiEditInformation01State extends State<GetApiEditInformation01> {
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
            return EditPlants01(
              details: snapshot.data!,
              images: snapshot.data!.imageneseditar,
              // details: snapshot.data!,
              // images: snapshot.data!.imagenes,
            );
          }
        },
      ),
    );
  }
}

class EditPlants01 extends StatefulWidget {
  final DetailsEditPlant details;
  final List<Imageneseditar>? images;
  const EditPlants01({required this.details, required this.images, super.key});

  @override
  State<EditPlants01> createState() => _EditPlants01State();
}

class _EditPlants01State extends State<EditPlants01> {
  File? _image;
  List<File> pictures = [];
  List<Map<String, dynamic>> valores = [];
  bool flag = false;

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
        } else {}
      });

      return _image;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Ionicons.arrow_back_outline,
            color: PlantaColors.colorWhite,
          ),
        ),
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
              Flexible(
                child: AutoSizeText(
                  AppLocalizations.of(context)!.take_photo,
                  style: context.theme.textTheme.text_01.copyWith(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              verticalMargin57,
              GestureDetector(
                onTap: () => getImage(),
                child: Container(
                  padding: allPadding16,
                  child: ClipRRect(
                    borderRadius: borderRadius10,
                    child: _image != null
                        ? Image.file(
                            File(
                              _image!.path,
                            ),
                          )
                        : CachedNetworkImage(
                            filterQuality: FilterQuality.low,
                            fit: BoxFit.cover,
                            imageUrl:
                                '${Constants.baseUrl}${widget.images![0].posterPath}',
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                  ),
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
            emptyWidget,
            ButtomSmall(
                color: PlantaColors.colorGreen,
                onTap: () async {
                  if (_image != null) {
                    valores.add(
                        {"imagen": _image, "name": widget.images![0].type});
                    // pictures.add(_image!);

                    Navigator.push(
                        context,
                        SlideRightRoute(
                            page: GetApiEditInformation02(
                                valores: valores, id: widget.details.id!)));
                  } else {
                    EasyLoading.show();
                    try {
                      final String foto =
                          '${Constants.baseUrl}${widget.images?[0].posterPath}';
                      final pictureFile = await urlToFile(foto);
                      EasyLoading.dismiss();

                      // pictures.add(pictureFile);
                      valores.add({
                        "imagen": pictureFile,
                        "name": widget.images![0].type
                      });

                      Navigator.push(
                          context,
                          SlideRightRoute(
                              page: GetApiEditInformation02(
                                  valores: valores, id: widget.details.id!)));
                    } on Exception catch (e) {
                      log(e.toString());
                      throw Exception('Something Error');
                    }
                  }
                },
                title: AppLocalizations.of(context)!.text_buttom_next),
          ],
        ),
      ),
    );
  }

  // Metodo para calcular la latitud y longitud que nos envia la foto en su metadata
  double _parseCoordinate(IfdTag coordinate) {
    final values = coordinate.values.toList();
    final degrees = values[0]?.toDouble() ?? 0.0;
    final minutes = values[1]?.toDouble() ?? 0.0;
    final seconds = values[2]?.toDouble() ?? 0.0;
    return degrees + (minutes / 60) + (seconds / 3600);
  }
}
