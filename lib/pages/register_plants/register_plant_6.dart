// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/pages/register_plants/register_plant_end.dart';
import 'package:planta_tracker/pages/register_plants/widget/camera_widget.dart';
import 'package:planta_tracker/services/plants_services.dart';

class RegisterPlant6 extends StatefulWidget {
  // final List<String>? pictures;
  List<Map<String, dynamic>> valores = [
    {"imagen": "", "name": ""},
  ];

  final double latitude;
  final double longitude;

  RegisterPlant6({
    super.key,
    required this.valores,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<RegisterPlant6> createState() => _RegisterPlant6State();
}

class _RegisterPlant6State extends State<RegisterPlant6> {
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
              if (flag == true)
                Flexible(
                  child: AutoSizeText(
                    // 'Para volver a tomar la foto pulse la imagén',
                    AppLocalizations.of(context)!.take_photo,
                    style: context.theme.textTheme.text_01.copyWith(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              verticalMargin57,
              GestureDetector(
                onTap: () => getImage(),
                child: CameraWidget(
                  text:
                      AppLocalizations.of(context)!.plant_register_image_flower,
                  picture: _image,
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
            ButtomSkip(
              color: PlantaColors.colorTransparent,
              onTap: () async {
                if (flag == true) {
                  null;
                } else {
                  File f = await optionServices.getImageFileFromAssets(
                    Constants.noPicture,
                  );

                  widget.valores.add({
                    "imagen": f.path,
                    "name":
                        AppLocalizations.of(
                          context,
                        )!.plant_register_image_flower,
                  });

                  Navigator.push(
                    context,
                    FadeTransitionRoute(
                      page: RegisterPlantEnd(
                        valores: widget.valores,
                        latitude: widget.latitude,
                        longitude: widget.longitude,
                      ),
                    ),
                  );
                }
              },
              title: AppLocalizations.of(context)!.skip,
              colorText:
                  flag ? PlantaColors.colorGrey : PlantaColors.colorBlack,
            ),
            ButtomSmall(
              color: flag ? PlantaColors.colorGreen : PlantaColors.colorGrey,
              onTap: () async {
                if (flag == true) {
                  final imageBytes = await _image!.readAsBytes();
                  final compressedBytes =
                      await FlutterImageCompress.compressWithList(
                        imageBytes,
                        quality: 75,
                      );

                  final tempDir = await getTemporaryDirectory();
                  final compressedFile = await File(
                    '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
                  ).writeAsBytes(compressedBytes);

                  widget.valores.add({
                    "imagen": compressedFile.path,
                    "name":
                        AppLocalizations.of(
                          context,
                        )!.plant_register_image_flower,
                  });

                  Navigator.push(
                    context,
                    FadeTransitionRoute(
                      page: RegisterPlantEnd(
                        valores: widget.valores,
                        latitude: widget.latitude,
                        longitude: widget.longitude,
                      ),
                    ),
                  );
                } else {
                  null;
                }
              },
              title: AppLocalizations.of(context)!.text_buttom_next,
            ),
          ],
        ),
      ),
    );
  }
}
