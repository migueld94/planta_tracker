// ignore_for_file: use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/pages/all_plants/all_plants.dart';
import 'package:planta_tracker/pages/login/login.dart';
import 'package:planta_tracker/pages/map/map.dart';
import 'package:planta_tracker/pages/my_plants/my_plants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:planta_tracker/services/auth_services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final storage = const FlutterSecureStorage();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: AutoSizeText(
              'Planta! Tracker',
              style: context.theme.textTheme.titleApBar,
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: PlantaColors.colorGreen,
            actions: [
              IconButton(
                icon: Icon(Icons.logout, color: PlantaColors.colorWhite),
                tooltip: AppLocalizations.of(context)!.logout,
                onPressed: () async {
                  warning(
                    context,
                    AppLocalizations.of(context)!.warning_exit,
                    () async {
                      EasyLoading.show();

                      final token = await storage.read(key: 'token');
                      var res = await authService.logout(token!);

                      switch (res!.statusCode) {
                        case 200:
                          EasyLoading.dismiss();
                          Navigator.pop(context);

                          WidgetsBinding.instance
                              .addPostFrameCallback((_) async {
                            Navigator.push(
                                context, SlideRightRoute(page: const Login()));
                          });
                          await storage.delete(key: 'token');
                          break;
                        case 400:
                          EasyLoading.dismiss();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: AutoSizeText(
                                AppLocalizations.of(context)!
                                    .verify_credentials,
                                style: context.theme.textTheme.text_01,
                              ),
                            ),
                          );
                          break;
                        case 401:
                          EasyLoading.dismiss();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: AutoSizeText(
                                AppLocalizations.of(context)!
                                    .verify_credentials,
                                style: context.theme.textTheme.text_01,
                              ),
                            ),
                          );
                          break;
                        default:
                          EasyLoading.dismiss();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: AutoSizeText(
                                AppLocalizations.of(context)!
                                    .verify_credentials,
                                style: context.theme.textTheme.text_01,
                              ),
                            ),
                          );
                          break;
                      }
                    },
                  );
                },
              ),
            ],
            bottom: TabBar(
              indicatorColor: PlantaColors.colorOrange,
              dividerColor: PlantaColors.colorWhite,
              labelStyle: context.theme.textTheme.text_01
                  .copyWith(color: PlantaColors.colorWhite),
              labelColor: PlantaColors.colorWhite,
              tabs: [
                Tab(
                  text: AppLocalizations.of(context)!.plants,
                  icon: const Icon(Ionicons.list_outline),
                ),
                Tab(
                  text: AppLocalizations.of(context)!.map,
                  icon: const Icon(Ionicons.map_outline),
                ),
                Tab(
                  text: AppLocalizations.of(context)!.my_plants,
                  icon: const Icon(Ionicons.leaf_outline),
                ),
              ],
            ),
          ),
          body: Center(
            child: PopScope(
              canPop: false,
              onPopInvoked: (bool didPop) async {
                if (!didPop) {
                  warning(
                    context,
                    AppLocalizations.of(context)!.warning_exit,
                    () async {
                      await storage.deleteAll();
                      Navigator.pop(context);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.push(
                            context, SlideRightRoute(page: const Login()));
                      });
                    },
                  );
                }
              },
              child: const TabBarView(
                children: [
                  AllPlants(),
                  MapView(),
                  MyPlants(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
