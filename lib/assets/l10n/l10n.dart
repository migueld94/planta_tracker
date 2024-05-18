import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('es'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'en':
        return 'en';
      case 'es':
      default:
        return 'es';
    }
  }
}
