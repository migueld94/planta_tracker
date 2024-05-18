import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';

class CameraWidget extends StatefulWidget {
  final String? text;
  const CameraWidget({super.key, this.text});

  @override
  CameraWidgetState createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
  File? _image;

  Future<void> getImage() async {
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
    } else {
      //print('Permiso de cámara no concedido.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => getImage(),
      child: Container(
        child: _image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: allPadding20,
                    margin: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                    ),
                    decoration: BoxDecoration(
                        color: PlantaColors.colorWhite,
                        borderRadius: borderRadius10,
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(5, 7),
                            blurRadius: 12,
                            color: PlantaColors.colorBlack.withOpacity(0.3),
                          ),
                        ]),
                    child: Icon(
                      Ionicons.camera_outline,
                      size: 40,
                      color: PlantaColors.colorOrange,
                    ),
                  ),
                  verticalMargin12,
                  AutoSizeText(widget.text!,
                      style: context.theme.textTheme.text_01),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: borderRadius15,
                    child: Image.file(
                      _image!,
                      scale: 10.0,
                    ),
                  ),
                  verticalMargin12,
                  AutoSizeText(widget.text!,
                      style: context.theme.textTheme.text_01),
                ],
              ),
      ),
    );
  }
}
