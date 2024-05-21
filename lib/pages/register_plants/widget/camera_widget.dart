import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';

class CameraWidget extends StatefulWidget {
  final String? text;
  final File? picture;
  final Function()? onTap;
  const CameraWidget({super.key, this.text, this.picture, this.onTap});

  @override
  CameraWidgetState createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        child: widget.picture == null
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
                      widget.picture!,
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
