// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:planta_tracker/assets/utils/widgets/language.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:planta_tracker/pages/login/login.dart';
import 'package:planta_tracker/assets/utils/assets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planta_tracker/assets/utils/widgets/buttoms.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/widgets/container_onboarding.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: allPadding16,
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 2;
            });
          },
          children: [
            ContainerOnboarding(
              color: PlantaColors.colorWhite,
              urlImage: Assets.logo,
              title: 'Planta! Tracker',
              subtitle_00: AppLocalizations.of(context)!.text_onboarding_first,
              icon: const LanguagePickerWidget(),
              action: AppLocalizations.of(context)!.slide_to_continue,
            ),
            ContainerOnboarding(
              color: PlantaColors.colorWhite,
              urlImage: Assets.logo,
              title: AppLocalizations.of(context)!.title_onboarding_second,
              subtitle_00: AppLocalizations.of(context)!.text_onboarding_second,
              action: AppLocalizations.of(context)!.slide_to_continue,
            ),
            ContainerOnboarding(
              color: PlantaColors.colorWhite,
              urlImage: Assets.logo,
              title: AppLocalizations.of(context)!.title_onboarding_three,
              subtitle_00:
                  AppLocalizations.of(context)!.text_onboarding_three_00,
              subtitle_01:
                  AppLocalizations.of(context)!.text_onboarding_three_01,
              subtitle_02:
                  AppLocalizations.of(context)!.text_onboarding_three_02,
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? Padding(
              padding: allPadding16,
              child: ButtomLarge(
                color: PlantaColors.colorGreen,
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('showHome', true);
                  Navigator.push(context, SlideRightRoute(page: const Login()));
                },
                title: AppLocalizations.of(context)!.text_buttom_continue,
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              height: 80.0,
              color: PlantaColors.colorWhite,
              child: Center(
                child: SmoothPageIndicator(
                  controller: controller,
                  count: 3,
                  effect: WormEffect(
                    spacing: 8.0,
                    dotColor: PlantaColors.colorGrey,
                    activeDotColor: PlantaColors.colorOrange,
                  ),
                  onDotClicked: (index) => controller.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  ),
                ),
              ),
            ),
    );
  }
}
