part of 'themes_provider.dart';

extension ThemeDataCommonExtension on ThemeData {
  ThemeData get common => copyWith(
        elevatedButtonTheme: _CommonAppThemeData.elevatedButtonThemeData,
        bottomAppBarTheme: _CommonAppThemeData.bottomAppBarThemeData,
      );
}

class _CommonAppThemeData {
  static final ElevatedButtonThemeData elevatedButtonThemeData = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      padding: horizontalPadding32 + verticalPadding12,
      shape: const RoundedRectangleBorder(
        borderRadius: borderRadius10,
      ),
    ),
  );

  static const BottomAppBarTheme bottomAppBarThemeData = BottomAppBarTheme(
    elevation: 12,
    shape: CircularNotchedRectangle(),
  );
}
