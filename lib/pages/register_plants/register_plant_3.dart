import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/pages/register_plants/register_plant_4.dart';
import 'package:planta_tracker/pages/register_plants/widget/camera_widget.dart';

class RegisterPlant3 extends StatefulWidget {
  final List<String>? pictures;

  const RegisterPlant3({super.key, this.pictures});

  @override
  State<RegisterPlant3> createState() => _RegisterPlant3State();
}

class _RegisterPlant3State extends State<RegisterPlant3> {
  File? _image;

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
      body: Center(
        child: GestureDetector(
          onTap: () => getImage(),
          child: CameraWidget(
            text: AppLocalizations.of(context)!.plant_register_image_branches,
            picture: _image,
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: allPadding24,
        child: ButtomLarge(
            color: PlantaColors.colorGreen,
            onTap: () {
              widget.pictures!.add(_image!.path);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterPlant4(pictures: widget.pictures,)),
              );
            },
            title: AppLocalizations.of(context)!.text_buttom_next),
      ),
    );
  }
}
