part of 'themes_provider.dart';

class PlantaColors {
  // Colors

  static Color colorPrimarys = const Color(0xFFf8f7f2);
  static Color colorPrimary = const Color(0xFFf9f5f1);
  static Color colorText = const Color(0xFFb3916e);
  static Color colorSimbols = const Color(0xFFb1e8be);
  static Color colorPrimaryDark = const Color(0xFF91776b);
  static Color colorPrimaryLight = const Color(0xFFf3ebdc);

  // Green
  static const _primaryGreenValue = 0xFFAED800;
  static Color colorGreen = const Color(_primaryGreenValue);
  static Color colorDarkGreen = const Color(0xFF004B49);
  static Color colorAvalibleGreen = const Color(0xFF66f0ad);
  static Color colorLightGreen = const Color(0xFFCCCC00);

  // Red
  static const _primaryRedValue = 0xFFE86065;
  static Color colorRed = const Color(_primaryRedValue);
  static Color colorLightRed = const Color(0xFFFF3936).withOpacity(0.8);

  // Orange
  static const _primaryOrangeValue = 0xFFFF6B28;
  static Color colorOrange = const Color(_primaryOrangeValue);
  static Color colorLightOrange = const Color(0xFFFF6B28).withOpacity(0.15);
  static Color colorDarkOrange = const Color(0xFFFF4500);

  // Blue
  static const _primaryBlueValue = 0xFF007CC3;
  static Color colorBlue = const Color(_primaryBlueValue);
  static Color colorLightBlue = const Color(0xFF00A2FF);
  static Color colorDarkBlue = const Color(0xFF003C5F);
  static Color colorMiddleDarkBlue = const Color(0xFF2B507A);
  static Color colorSecondaryLightBlue = const Color(0xFFA8DDFC);

  // Yellow
  static const _primaryYellowValue = 0xFFFDB827;
  static Color colorYellow = const Color(_primaryYellowValue);
  static Color colorLightYellow = const Color(0xFFFBFF3B).withOpacity(0.57);
  static Color colorDarkYellow = const Color(0xFFFFB32B);

  // Black and White
  static Color colorBlack = const Color(0xFF000000);
  static Color colorWhite = const Color(0xFFFBFBFB);

  // Grey
  static Color colorGrey = const Color(0xFFA5A1A1);
  static Color colorLightGrey = const Color(0xFFF6F6F6);
  static Color colorDarkGrey = Colors.grey[800]!;
  static Color colorDarkDarkGrey = Colors.grey[900]!;
  static Color greyDisabled = const Color(0xFF838383);

  // Blue Dark
  static const _secundaryBlueValue = 0xFF006496;
  static Color colorSecundaryBlue = const Color(_secundaryBlueValue);

  // Pink
  static const _primaryPinkValue = 0xFFD45E5E;
  static Color colorPink = const Color(_primaryPinkValue);
  static Color colorLightPink = const Color(0xFFF47F6B);

  // Purple
  static Color colorPurple = const Color(0xFF7A5197);
  static Color colorLightPurple = const Color(0xFFBB5098);
  static Color colorDarkPurple = const Color(0xFF5344A9);

  // Transparent
  static Color colorTransparent = Colors.transparent;

  static const MaterialColor primaryPinkSwatch = MaterialColor(
    _primaryPinkValue,
    <int, Color>{
      50: Color(0xFFFFDAB9),
      100: Color(0xFFFCB4AB),
      200: Color(0xFFF8AD9D),
      300: Color(0xFFF4978E),
      350: Color(0xFFF08080),
      400: Color(_primaryPinkValue),
    },
  );

  static const MaterialColor secundaryBlueSwatch = MaterialColor(
    _secundaryBlueValue,
    <int, Color>{
      50: Color(0xFFF0F3FA),
      100: Color(0xFFD5DEEF),
      200: Color(0xFFB1C9EF),
      300: Color(0xFF8AAEE0),
      350: Color(0xFF638ECB),
      400: Color(0xFF006DA4),
      500: Color(_secundaryBlueValue),
      600: Color(0xFF395886),
      700: Color(0xFF004D74),
      800: Color(0xFF003554),
      850: Color(0xFF022B42),
      900: Color(0xFF032030),
    },
  );

  static const MaterialColor primaryBlueSwatch = MaterialColor(
    _primaryBlueValue,
    <int, Color>{
      50: Color(0xff61C5FF),
      100: Color(0xff34B4FF),
      200: Color(0xff1DACFF),
      300: Color(0xff07A4FF),
      350: Color(0xff0097EF),
      400: Color(0xff0089D8),
      500: Color(_primaryBlueValue),
      600: Color(0xff0072B4),
      700: Color(0xff0069A6),
      800: Color(0xff006098),
      850: Color(0xff00588A),
      900: Color(0xff004F7D),
    },
  );

  static const MaterialColor primaryGreenSwatch = MaterialColor(
    _primaryGreenValue,
    <int, Color>{
      50: Color(0xff6BEAE1),
      100: Color(0xff59E7DE),
      200: Color(0xff46E5DA),
      300: Color(0xff34E2D6),
      350: Color(
          0xff21DFD3), // only for raised button while pressed in light theme
      400: Color(0xff1DCEC2),
      500: Color(_primaryGreenValue),
      600: Color(0xff19AEA4),
      700: Color(0xff17A197),
      800: Color(0xff15938B),
      850: Color(0xff13867E), // only for background color in dark theme
      900: Color(0xff117872),
    },
  );

  static const MaterialColor primaryYellowSwatch = MaterialColor(
    _primaryYellowValue,
    <int, Color>{
      50: Color(0xffFED783),
      100: Color(0xffFED273),
      200: Color(0xffFDCD64),
      300: Color(0xffFDC854),
      350: Color(
          0xffFDC345), // only for raised button while pressed in light theme
      400: Color(0xffFDBE35),
      500: Color(_primaryYellowValue),
      600: Color(0xffFDB211),
      700: Color(0xffF7A902),
      800: Color(0xffE29B02),
      850: Color(0xffCE8D02), // only for background color in dark theme
      900: Color(0xffB97F02),
    },
  );

  static const MaterialColor primaryOrangeSwatch = MaterialColor(
    _primaryOrangeValue,
    <int, Color>{
      50: Color(0xffF8C280),
      100: Color(0xffF7BA70),
      200: Color(0xffF6B361),
      300: Color(0xffF5AB51),
      350: Color(
          0xffF4A341), // only for raised button while pressed in light theme
      400: Color(0xffF39C31),
      500: Color(_primaryOrangeValue),
      600: Color(0xffF18B0F),
      700: Color(0xffDF810D),
      800: Color(0xffCC760C),
      850: Color(0xffBA6B0B), // only for background color in dark theme
      900: Color(0xffA7600A),
    },
  );

  static const MaterialColor primaryRedSwatch = MaterialColor(
    _primaryRedValue,
    <int, Color>{
      50: Color(0xffF2A3A6),
      100: Color(0xffF0989B),
      200: Color(0xffEF8C90),
      300: Color(0xffED8184),
      350: Color(
          0xffEB7579), // only for raised button while pressed in light theme
      400: Color(0xffEA6A6E),
      500: Color(_primaryRedValue),
      600: Color(0xffE54A4F),
      700: Color(0xffE2363B),
      800: Color(0xffDF2127),
      850: Color(0xffCC1D23), // only for background color in dark theme
      900: Color(0xffB81A1F),
    },
  );

  static LinearGradient gradientBlackWhite = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE9E9E9),
      Color(0xFF262230),
    ],
  );

  static LinearGradient gradientOcean = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00FFE0),
      Color(0xFF110543),
    ],
  );

  static LinearGradient gradientNature = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00FFB2),
      Color(0xFF02131D),
    ],
  );

  static LinearGradient gradientSun = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFC700),
      Color(0xFF1D0219),
    ],
  );

  static LinearGradient gradientSpring = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF6B00),
      Color(0xFF180702),
    ],
  );

  static LinearGradient gradientRedBlue = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF004C),
      Color(0xFF10067D),
    ],
  );

  static LinearGradient gradientPurple = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF00F5),
      Color(0xFF09067D),
    ],
  );

  static LinearGradient gradientFrost = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF000428),
      Color(0xFF004E92),
    ],
  );

  static LinearGradient gradientCoolSky = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF2980B9),
      Color(0xFF6DD5FA),
    ],
  );

  static LinearGradient gradientDarkBlue = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      PlantaColors.colorMiddleDarkBlue,
      PlantaColors.colorBlue,
    ],
  );

  static LinearGradient gradientMiddleBlue = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      PlantaColors.colorBlue,
      Colors.blue.withOpacity(0.45),
    ],
  );

  static LinearGradient gradientOrange = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.topRight,
    colors: [
      PlantaColors.colorOrange,
      // PlantaColors.colorOrange.withOpacity(0.80),
      PlantaColors.colorLightOrange,
    ],
  );

  static LinearGradient gradientYellow = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      PlantaColors.colorYellow,
      PlantaColors.colorYellow.withOpacity(0.80),
    ],
  );

  static LinearGradient gradientRed = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      PlantaColors.colorRed,
      PlantaColors.colorLightRed,
    ],
  );

  static LinearGradient gradientGreen = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      PlantaColors.colorGreen,
      PlantaColors.colorLightGreen,
    ],
  );

  // ColorScheme get lightColorScheme {
  //   return ColorScheme.fromSwatch(
  //     accentColor: darkDarkBlue,
  //     cardColor: primaryLigthGrey,
  //     backgroundColor: primaryLigthGrey,
  //     errorColor: primaryRed,
  //     brightness: Brightness.light,
  //   );
  // }

  // ColorScheme get darkColorScheme {
  //   return ColorScheme.fromSwatch(
  //     accentColor: darkDarkBlue,
  //     cardColor: primaryLigthGrey,
  //     backgroundColor: primaryLigthGrey,
  //     errorColor: primaryRed,
  //     brightness: Brightness.dark,
  //   );
  // }
}
