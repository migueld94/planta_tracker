import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planta_tracker/assets/l10n/l10n.dart';
import 'package:planta_tracker/assets/utils/assets.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/circular_progress.dart';
import 'package:planta_tracker/blocs/all_plants/all_plants_bloc.dart';
import 'package:planta_tracker/blocs/all_plants/all_plants_event.dart';
import 'package:planta_tracker/blocs/lifestage_nomenclador/lifestage_nomenclador_bloc.dart';
import 'package:planta_tracker/blocs/lifestage_nomenclador/lifestage_nomenclador_event.dart';
import 'package:planta_tracker/blocs/my_plants/my_plants_bloc.dart';
import 'package:planta_tracker/blocs/my_plants/my_plants_event.dart';
import 'package:planta_tracker/blocs/profile/profile_bloc.dart';
import 'package:planta_tracker/blocs/profile/profile_event.dart';
import 'package:planta_tracker/pages/login/login.dart';
import 'package:planta_tracker/pages/onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? language;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    language = L10n.getFlag(locale.languageCode);
    _loadData();
  }

  Future<void> _loadData() async {
    context.read<AllPlantsBloc>().add(LoadAllPlants(language: language!));
    context.read<ProfileBloc>().add(FetchProfile());
    context.read<MyPlantsBloc>().add(LoadMyPlants());
    context.read<LifestageNomBloc>().add(LoadLifestageNom());

    await Future.delayed(Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final showHome = prefs.getBool('showHome') ?? false;

    if (!mounted) return;

    if (showHome) {
      Navigator.push(context, FadeTransitionRoute(page: const Login()));
    } else {
      Navigator.push(context, FadeTransitionRoute(page: const Onboarding()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PlantaColors.colorGreen.withOpacity(0.2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.logo, fit: BoxFit.cover, width: 256.0),
            verticalMargin16,
            Text('Cargando plantas...', style: context.theme.textTheme.h2),
            verticalMargin12,
            CircularPlantaTracker(),
          ],
        ),
      ),
    );
  }
}
