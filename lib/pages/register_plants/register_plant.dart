// ignore_for_file: use_build_context_synchronously, unused_element
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:exif/exif.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/pages/register_plants/register_plant_2.dart';
import 'package:planta_tracker/pages/register_plants/widget/camera_widget.dart';

class RegisterPlant extends StatefulWidget {
  const RegisterPlant({super.key});

  @override
  State<RegisterPlant> createState() => _RegisterPlantState();
}

class _RegisterPlantState extends State<RegisterPlant> {
  File? _image;
  List<String>? pictures = [];
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
      await Permission.accessMediaLocation.request();
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
        // automaticallyImplyLeading: false,
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
                  // 'Para volver a tomar la foto pulse la imagén',
                  AppLocalizations.of(context)!.take_photo,
                  style: context.theme.textTheme.text_01.copyWith(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            verticalMargin57,
            Center(
              child: GestureDetector(
                onTap: () => getImage(),
                child: CameraWidget(
                  text: AppLocalizations.of(context)!.plant_register_full_image,
                  picture: _image,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: allPadding16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            emptyWidget,
            ButtomSmall(
                color: flag ? PlantaColors.colorGreen : PlantaColors.colorGrey,
                onTap: () async {
                  if (flag == true) {
                    // final bytes = await _image!.readAsBytes();
                    // final data = await readExifFromBytes(Uint8List.fromList(bytes));

                    final fileBytes = File(_image!.path).readAsBytesSync();
                    final data = await readExifFromBytes(fileBytes);

                    log(data.toString());

                    final latitude = data['GPS GPSLatitude'];
                    final longitude = data['GPS GPSLongitude'];

                    if (longitude != null && latitude != null) {
                      valores.add({
                        "imagen": _image!.path,
                        "name": AppLocalizations.of(context)!
                            .plant_register_full_image
                      });

                      Navigator.push(
                          context,
                          SlideRightRoute(
                              page: RegisterPlant2(valores: valores)));
                    } else {
                      alert(context,
                          'La imagen capturada no tiene informacion de GPS, por favor usted debe activar los permisos de su camara para continuar con el registro de su planta.');
                    }
                  } else {
                    null;
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
