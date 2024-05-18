import 'package:flutter/material.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';

class MenuCard extends StatelessWidget {
  const MenuCard(
      {super.key,
      required this.backgroundImage,
      required this.widget,
      required this.width,
      required this.height});

  final String backgroundImage;
  final Widget widget;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.2,
            child: Center(
              child: Image.asset(
                backgroundImage,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Ink(
            decoration: const BoxDecoration(
              // gradient: context.gradientGreen.revert(),
              borderRadius: borderRadius10,
            ),
          ),
          SizedBox.expand(
            child: widget,
          ),
        ],
      ),
    );
  }
}
