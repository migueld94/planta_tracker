import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';

class ContainerOnboarding extends StatelessWidget {
  const ContainerOnboarding({
    super.key,
    required this.color,
    required this.urlImage,
    required this.title,
    required this.subtitle_00,
    this.subtitle_01,
    this.subtitle_02,
    this.action,
    this.icon,
  });

  final Color color;
  final String urlImage;
  final String title;
  final String subtitle_00;
  final String? subtitle_01;
  final String? subtitle_02;
  final String? action;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: color,
          padding: allPadding24,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  urlImage,
                  fit: BoxFit.cover,
                  width: 256.0,
                ),
                verticalMargin64,
                AutoSizeText(
                  title,
                  style: context.theme.textTheme.h1,
                  textAlign: TextAlign.center,
                ),
                verticalMargin24,
                SizedBox(
                  width: 242.0,
                  child: AutoSizeText(
                    subtitle_00,
                    style: context.theme.textTheme.text_01,
                    textAlign: TextAlign.center,
                  ),
                ),
                verticalMargin16,
                SizedBox(
                  width: 242.0,
                  child: AutoSizeText(
                    subtitle_01 ?? '',
                    style: context.theme.textTheme.text_01,
                    textAlign: TextAlign.center,
                  ),
                ),
                verticalMargin16,
                SizedBox(
                  width: 242.0,
                  child: AutoSizeText(
                    subtitle_02 ?? '',
                    style: context.theme.textTheme.text_01,
                    textAlign: TextAlign.center,
                  ),
                ),
                verticalMargin16,
                SizedBox(
                  width: 242.0,
                  child: AutoSizeText(
                    action ?? '',
                    style: context.theme.textTheme.text_01,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 30,
          right: 10,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: PlantaColors.colorBlack),
              borderRadius: borderRadius10,
            ),
            child: icon,
          ),
        ),
      ],
    );
  }
}
