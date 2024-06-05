// ignore_for_file: use_build_context_synchronously, unused_element

import 'dart:developer';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:exif/exif.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
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
  bool flag = false;

  Future<File?> getImage() async {
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }

    if (await Permission.camera.isGranted) {
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
      //print('Permiso de cámara no concedido.');
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
                  'Para volver a tomar la foto pulse la imagén',
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
        padding: allPadding24,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            emptyWidget,
            ButtomSmall(
                color: flag ? PlantaColors.colorGreen : PlantaColors.colorGrey,
                onTap: () async {
                  if (flag == true) {
                    final bytes = await _image!.readAsBytes();
                    final data =
                        await readExifFromBytes(Uint8List.fromList(bytes));
                    // final gpsData = data['GPS'];
                    final latitude = data['GPS GPSLatitude'];
                    final longitude = data['GPS GPSLongitude'];

                    if (longitude != null && latitude != null) {
                      // final lat = _parseCoordinate(latitude);
                      // final lon = _parseCoordinate(longitude);
                      // log('Latitud: $lat, Longitud: $lon');

                      pictures!.add(_image!.path);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RegisterPlant2(pictures: pictures)));
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
