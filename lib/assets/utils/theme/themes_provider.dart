import 'package:flutter/material.dart';
import 'package:planta_tracker/assets/l10n/l10n.dart';

part 'theme_data.dart';
part 'theme_colors.dart';
part 'common.dart';

class ThemeProvider extends ChangeNotifier {
  //============== Cambio de Modo ============
  // ThemeMode themeMode = ThemeMode.light;
  // bool get isDarkTheme => themeMode == ThemeMode.light;

  // void toogleTheme(bool isOn) {
  //   themeMode = isOn ? ThemeMode.light : ThemeMode.dark;
  //   notifyListeners();
  // }

  //============== Internacionalizacion ============
  Locale? _locale;
  Locale? get locale => _locale;
  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
}

class MyThemes {
  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Inter',
    useMaterial3: true,
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.deepPurple.withOpacity(0.3),
      titleTextStyle: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
    ),
    colorScheme: ColorScheme.dark(
      background: Colors.grey[900]!,
      primary: Colors.deepPurple.withOpacity(0.05),
      secondary: Colors.grey[900]!,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Inter',
    useMaterial3: true,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(color: Colors.black, fontFamily: 'Inte'),
    ),
    colorScheme: ColorScheme.light(
      background: Colors.white38,
      primary: Colors.deepPurple.withOpacity(0.10),
      secondary: Colors.white,
    ),
  );
}
