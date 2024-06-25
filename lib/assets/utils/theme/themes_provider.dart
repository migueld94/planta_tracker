import 'package:flutter/material.dart';
import 'package:planta_tracker/assets/l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_data.dart';
part 'theme_colors.dart';
part 'common.dart';

class ThemeProvider with ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  ThemeProvider() {
    _loadLocaleFromSharedPreferences();
  }

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
    _saveLocaleToSharedPreferences(locale);
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
    _clearLocaleFromSharedPreferences();
  }

  Future<void> _saveLocaleToSharedPreferences(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }

  Future<void> _clearLocaleFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('locale');
  }

  Future<void> _loadLocaleFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('locale');
    if (localeCode != null) {
      _locale = Locale(localeCode);
      notifyListeners();
    }
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
