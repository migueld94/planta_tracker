import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';

class ButtomLarge extends StatelessWidget {
  const ButtomLarge({
    super.key,
    required this.color,
    required this.onTap,
    required this.title,
  });

  final Color color;
  final Function() onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: borderRadius10,
          color: color,
        ),
        child: Center(
          child: AutoSizeText(
            title,
            style: context.theme.textTheme.textButtomLarge,
          ),
        ),
      ),
    );
  }
}

class ButtomSmall extends StatelessWidget {
  const ButtomSmall({
    super.key,
    required this.color,
    required this.onTap,
    required this.title,
  });

  final Color color;
  final Function() onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius10,
        ),
        child: Center(
          child: AutoSizeText(
            title,
            style: context.theme.textTheme.textButtomMedium,
          ),
        ),
      ),
    );
  }
}

class ButtomSkip extends StatelessWidget {
  const ButtomSkip({
    super.key,
    required this.color,
    required this.onTap,
    required this.title,
    required this.colorText,
  });

  final Color color;
  final Function() onTap;
  final String title;
  final Color colorText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius10,
        ),
        child: Center(
          child: AutoSizeText(
            title,
            style: context.theme.textTheme.textButtomMedium.copyWith(
              color: colorText,
              decoration: TextDecoration.underline,
              decorationThickness: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
