import 'package:flutter/material.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
    required String hintText,
    required String labelText,
    Icon? icon,
    IconButton? suffix,
    InputBorder? enabledBorder,
  }) {
    return InputDecoration(
      enabledBorder: enabledBorder,
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: PlantaColors.colorGrey),
        borderRadius: borderRadius10,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: PlantaColors.colorGreen, width: 2),
        borderRadius: borderRadius10,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: PlantaColors.colorRed),
        borderRadius: borderRadius10,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: PlantaColors.colorRed),
        borderRadius: borderRadius10,
      ),
      hintText: hintText,
      labelText: labelText,
      alignLabelWithHint: true,
      labelStyle: TextStyle(color: PlantaColors.colorGrey),
      // contentPadding: EdgeInsets.zero,
      prefixIcon: icon,
      suffixIcon: suffix,
    );
  }
}
