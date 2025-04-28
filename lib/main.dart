import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get/get.dart';

import 'package:planta_tracker/assets/l10n/l10n.dart';
// import 'package:planta_tracker/dependency_injection.dart';
import 'package:planta_tracker/pages/login/login.dart';
import 'package:planta_tracker/blocs/gps/gps_bloc.dart';
import 'package:planta_tracker/blocs/gps/gps_event.dart';
import 'package:planta_tracker/blocs/map/map_event.dart';
import 'package:planta_tracker/pages/map/bloc/plants_map_bloc.dart';
import 'package:planta_tracker/pages/onboarding/onboarding.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/services/all_plants_services.dart';

import 'assets/l10n/app_localizations.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'blocs/map/map_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;
  configLoading();
  clearSecureStorageOnReinstall();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GpsBloc()..add(GpsStarted())),
        BlocProvider(create: (context) => MapBloc()..add(MapStarted())),
        BlocProvider(create: (context) => PlantsMapBloc(AllPlantServices())),
      ],
      child: MyApp(showHome: showHome),
    ),
  );
  // DependencyInjection.init();
}

void clearSecureStorageOnReinstall() async {
  String key = 'hasRunBefore';
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getBool(key) != true) {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.deleteAll();
    prefs.setBool(key, true);
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = const Color.fromARGB(255, 255, 200, 0)
    ..backgroundColor = const Color.fromARGB(255, 0, 0, 0)
    ..indicatorColor = const Color.fromARGB(255, 255, 200, 0)
    ..textColor = const Color.fromARGB(255, 255, 200, 0)
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  final bool showHome;
  const MyApp({
    super.key,
    required this.showHome,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return ThemeProvider();
      },
      builder: (context, child) {
        final provider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          title: 'Planta! Tracker',
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Nunito',
            appBarTheme: AppBarTheme(
              backgroundColor: PlantaColors.colorGreen,
              iconTheme: IconThemeData(
                color: PlantaColors.colorWhite,
              ),
            ),
            bottomSheetTheme: BottomSheetThemeData(
              surfaceTintColor: PlantaColors.colorWhite,
            ),
          ),
          locale: provider.locale,
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: showHome ? const Login() : const Onboarding(),
        );
      },
    );
  }
}
