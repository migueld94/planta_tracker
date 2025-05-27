// // ignore_for_file: use_build_context_synchronously
// ignore_for_file: use_build_context_synchronously
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:planta_tracker/assets/l10n/l10n.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/card_plant.dart';
import 'package:planta_tracker/assets/utils/widgets/circular_progress.dart';
import 'package:planta_tracker/blocs/all_plants/all_plants_bloc.dart';
import 'package:planta_tracker/blocs/all_plants/all_plants_event.dart';
import 'package:planta_tracker/blocs/all_plants/all_plants_state.dart';
import 'package:planta_tracker/pages/details_plant/details.dart';

class AllPlants extends StatefulWidget {
  const AllPlants({super.key});

  @override
  State<AllPlants> createState() => _AllPlantsState();
}

class _AllPlantsState extends State<AllPlants> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final locale = Localizations.localeOf(context);
      final language = L10n.getFlag(locale.languageCode);
      context.read<AllPlantsBloc>().add(LoadMoreAllPlants(language: language));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AllPlantsBloc, AllPlantsState>(
        builder: (context, state) {
          if (state is AllPlantsLoading) {
            return Center(child: CircularPlantaTracker());
          } else if (state is AllPlantsLoaded ||
              state is AllPlantsBackgroundLoading) {
            final allPlants =
                (state is AllPlantsLoaded)
                    ? state.plants
                    : (state as AllPlantsBackgroundLoading).plants;

            return allPlants.results.isNotEmpty
                ? ListView.builder(
                  controller: _scrollController,
                  itemCount: allPlants.results.length + 1,
                  itemBuilder: (context, index) {
                    if (index < allPlants.results.length) {
                      final plants = allPlants.results[index];
                      final date = DateTime.parse(
                        plants.fechaRegistro.toString(),
                      );
                      return CardPlant(
                        picture: plants.imagenPrincipal,
                        title:
                            plants.especiePlanta.isNotEmpty
                                ? plants.especiePlanta
                                : AppLocalizations.of(context)!.name_plant,
                        lifestage: plants.lifestage,
                        status: plants.estadoActual,
                        date: '${date.day} / ${date.month} / ${date.year}',
                        onTap: () {
                          Navigator.push(
                            context,
                            SlideRightRoute(page: Details(id: plants.id)),
                          );
                        },
                      );
                    } else if (state is AllPlantsLoadingMore) {
                      return Center(child: CircularPlantaTracker());
                    }
                    return SizedBox.shrink();
                  },
                )
                : Center(
                  child: Text(
                    AppLocalizations.of(context)!.non_plant_registered,
                    style: context.theme.textTheme.h2,
                  ),
                );
          } else if (state is AllPlantsError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Ionicons.wifi_outline,
                    size: 90.0,
                    color: PlantaColors.colorGrey,
                  ),
                  Text(
                    AppLocalizations.of(context)!.error_connection,
                    style: context.theme.textTheme.h2.copyWith(
                      color: PlantaColors.colorGrey,
                      fontSize: 20.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final locale = Localizations.localeOf(context);
                      final language = L10n.getFlag(locale.languageCode);
                      context.read<AllPlantsBloc>().add(
                        LoadAllPlants(language: language),
                      );
                    },
                    icon: Icon(Ionicons.refresh_outline, size: 30.0),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: PlantaColors.colorGreen,
        onPressed: () => goToRegisterPlant(context),
        child: Icon(Ionicons.add_outline, color: PlantaColors.colorWhite),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Ink(
          height: 60.0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: borderRadius10.topLeft,
              topRight: borderRadius10.topRight,
            ),
            child: BottomAppBar(
              color: PlantaColors.colorGreen,
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => goToProfile(context),
                    child: Icon(
                      Ionicons.people_outline,
                      color: PlantaColors.colorWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// // // ignore_for_file: use_build_context_synchronously

// // ignore_for_file: use_build_context_synchronously

// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

// import 'package:http/http.dart' as http;

// import 'package:flutter/material.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:planta_tracker/assets/l10n/l10n.dart';
// import 'package:planta_tracker/assets/utils/constants.dart';
// import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
// import 'package:planta_tracker/assets/utils/methods/utils.dart';
// import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
// import 'package:planta_tracker/assets/utils/widgets/card_plant.dart';
// import 'package:planta_tracker/pages/details_plant/details.dart';
// import 'package:planta_tracker/assets/l10n/app_localizations.dart';

// class AllPlants extends StatefulWidget {
//   const AllPlants({super.key});

//   @override
//   State<AllPlants> createState() => _AllPlantsState();
// }

// class _AllPlantsState extends State<AllPlants> {
//   List items = [];
//   int next = 1;
//   var secretUrl = Uri.parse('${Constants.baseUrl}/en/api/o/token/');
//   ScrollController scroll = ScrollController();
//   bool isLoadMore = false;

//   _loadMore() async {
//     try {
//       String client = 'IMIUgjEXwzviJeCfVzCQw4g8GkhUpYGbcDieCxSE';
//       String secret =
//           'rOsMV2OjTPs89ku5NlWuukWNMfm9CDO3nZuzOxRWYCPUSSxnZcCfUl8XnU1HcPTfCqCTpZxYhv3zNYUB0H1hlQ6b7heLWsoqgJjLSkwAsZp7NTwT2B1D8nwfTS6bfvpw';
//       String basicAuth =
//           'Basic ${base64.encode(utf8.encode('$client:$secret'))}';
//       var resp = await http.post(secretUrl, headers: <String, String>{
//         'authorization': basicAuth
//       }, body: {
//         "grant_type": "client_credentials",
//       });

//       final Map<String, dynamic> data = json.decode(resp.body);
//       final accessToken = data["access_token"];

//       String idioma = getFlag();
//       final allplants =
//           Uri.parse('${Constants.baseUrl}/$idioma/api/plants_api?page=$next');

//       final response = await http.get(allplants,
//           headers: <String, String>{'authorization': "Bearer $accessToken"});

//       final utf = const Utf8Decoder().convert(response.body.codeUnits);

//       if (response.statusCode == 200) {
//         final json = jsonDecode(utf)['results'] as List;
//         setState(() {
//           items.addAll(json);
//         });
//       }
//     } on SocketException {
//       EasyLoading.dismiss();
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: PlantaColors.colorDarkOrange,
//         content: Center(
//           child: AutoSizeText(
//             AppLocalizations.of(context)!.no_internet,
//             style: context.theme.textTheme.text_01.copyWith(
//               color: PlantaColors.colorWhite,
//               fontSize: 16.0,
//             ),
//           ),
//         ),
//       ));
//     } catch (e) {
//       log('Error => $e');
//       EasyLoading.dismiss();
//       throw Exception(e);
//     }
//   }

//   String getFlag() {
//     final locale = Localizations.localeOf(context);
//     var flag = L10n.getFlag(locale.languageCode);
//     return flag;
//   }

//   @override
//   void initState() {
//     EasyLoading.show();
//     _loadMore();
//     scroll.addListener(() async {
//       if (isLoadMore == true) return;
//       if (scroll.position.pixels == scroll.position.maxScrollExtent) {
//         setState(() {
//           isLoadMore = true;
//         });
//         next++;
//         await _loadMore();
//         setState(() {
//           isLoadMore = false;
//         });
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.separated(
//               controller: scroll,
//               itemCount: isLoadMore ? items.length + 1 : items.length,
//               separatorBuilder: (context, index) => verticalMargin4,
//               itemBuilder: (context, index) {
//                 EasyLoading.dismiss();
//                 if (index >= items.length) {
//                   return const Center(
//                     child: CircularPlantaTracker(),
//                   );
//                 } else {
//                   final date = DateTime.parse(items[index]["fecha_registro_"]);
//                   return CardPlant(
//                     picture: items[index]['imagen_principal'],
//                     title: items[index]['especie_planta'] ??
//                         AppLocalizations.of(context)!.name_plant,
//                     lifestage: items[index]['lifestage'] ?? '',
//                     status: items[index]['estado_actual'] ?? '',
//                     date: '${date.day} / ${date.month} / ${date.year}',
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         SlideRightRoute(
//                           page: Details(
//                             id: items[index]['id'],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         shape: const CircleBorder(),
//         backgroundColor: PlantaColors.colorGreen,
//         onPressed: () => goToRegisterPlant(context),
//         child: Icon(
//           Ionicons.add_outline,
//           color: PlantaColors.colorWhite,
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).padding.bottom, // Add this
//         ),
//         child: Ink(
//           height: 60.0,
//           child: ClipRRect(
//             borderRadius: BorderRadius.only(
//               topLeft: borderRadius10.topLeft,
//               topRight: borderRadius10.topRight,
//             ),
//             child: BottomAppBar(
//               color: PlantaColors.colorGreen,
//               elevation: 0,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () => goToProfile(context),
//                     child: Icon(
//                       Ionicons.people_outline,
//                       color: PlantaColors.colorWhite,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
