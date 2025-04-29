// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/blocs/my_plants/my_plants_bloc.dart';
import 'package:planta_tracker/blocs/my_plants/my_plants_event.dart';
import 'package:planta_tracker/blocs/my_plants/my_plants_state.dart';

class MyPlants extends StatefulWidget {
  const MyPlants({super.key});

  @override
  State<MyPlants> createState() => _MyPlantsState();
}

class _MyPlantsState extends State<MyPlants> {
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
      context.read<MyPlantsBloc>().add(LoadMoreMyPlants());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<MyPlantsBloc>().add(LoadMyPlants());

    return Scaffold(
      body: BlocBuilder<MyPlantsBloc, MyPlantsState>(
        builder: (context, state) {
          if (state is MyPlantsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MyPlantsLoaded ||
              state is MyPlantsBackgroundLoading) {
            final movies =
                (state is MyPlantsLoaded)
                    ? state.plants
                    : (state as MyPlantsBackgroundLoading).plants;

            return movies.results.isNotEmpty
                ? ListView.builder(
                  controller: _scrollController,
                  itemCount: movies.results.length + 1,
                  itemBuilder: (context, index) {
                    if (index < movies.results.length) {
                      final movie = movies.results[index];
                      return ListTile(title: Text(movie.especiePlanta));
                    } else if (state is MyPlantsLoadingMore) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return SizedBox.shrink();
                  },
                )
                : Text('Usted no tiene plantas');
          } else if (state is MyPlantsError) {
            return Center(child: Text('Error: ${state.error}'));
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
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom, // Add this
        ),
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
                  IconButton(
                    icon: Icon(
                      Ionicons.people_outline,
                      color: PlantaColors.colorWhite,
                    ),
                    onPressed: () => goToProfile(context),
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


// CODIGO VIEJO ++++++++++++++++++++++++++++++++++++++++++++


// // ignore_for_file: use_build_context_synchronously

// import 'dart:convert';
// import 'dart:io';

// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:ionicons/ionicons.dart';
// import 'package:planta_tracker/assets/l10n/l10n.dart';
// import 'package:planta_tracker/assets/utils/constants.dart';
// import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
// import 'package:planta_tracker/assets/utils/methods/utils.dart';
// import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
// import 'package:planta_tracker/assets/utils/widgets/card_plant.dart';
// import 'package:planta_tracker/pages/details_plant/details.dart';
// import 'package:planta_tracker/pages/my_plants/edit/edit_plant_1.dart';
// import 'package:planta_tracker/services/plants_services.dart';
// import 'package:planta_tracker/assets/l10n/app_localizations.dart';

// class MyPlants extends StatefulWidget {
//   const MyPlants({super.key});

//   @override
//   State<MyPlants> createState() => _MyPlantsState();
// }

// class _MyPlantsState extends State<MyPlants> {
//   final OptionPlantServices optionServices = OptionPlantServices();
//   final storage = const FlutterSecureStorage();
//   List items = [];
//   int next = 1;
//   var secretUrl = Uri.parse('${Constants.baseUrl}/en/api/o/token/');
//   ScrollController scroll = ScrollController();
//   bool isLoadMore = false;

//   _loadMore() async {
//     final token = await storage.read(key: "token");
//     String idioma = getFlag();

//     try {
//       final myPlantsUri =
//           Uri.parse('${Constants.baseUrl}/$idioma/api/my_plants?page=$next');

//       final response = await http.get(myPlantsUri,
//           headers: <String, String>{'authorization': "Token $token"});

//       final utf = const Utf8Decoder().convert(response.body.codeUnits);

//       if (response.statusCode == 200) {
//         final json = jsonDecode(utf)['results'] as List;
//         if (json.isEmpty) {
//           EasyLoading.dismiss();
//           return tutorial(context);
//           // return alert(context, AppLocalizations.of(context)!.no_elements);
//         } else {
//           setState(() {
//             items.addAll(json);
//           });
//         }
//       }
//     } on SocketException {
//       EasyLoading.dismiss();
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: PlantaColors.colorOrange,
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
//                     child: CircularProgressIndicator(),
//                   );
//                 } else {
//                   final date = DateTime.parse(items[index]["fecha_registro_"]);
//                   return CardMyPlants(
//                     id: items[index]['id'],
//                     picture: items[index]['imagen_principal'],
//                     title: items[index]['especie_planta'] ??
//                         AppLocalizations.of(context)!.name_plant,
//                     lifestage: items[index]['lifestage'] ?? '',
//                     status: items[index]['estado_actual'] ?? '',
//                     date: '${date.day} / ${date.month} / ${date.year}',

//                     // Este es el onTap de enviar el id a Detalles
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           SlideRightRoute(
//                               page: Details(id: items[index]['id'])));
//                     },

//                     // Este es el onTap del servicio Eliminar Planta solo se pueden eliminar los PENDIENTES
//                     onTapDelete: () {
//                       var status = items[index]['estado_actual']
//                           .toString()
//                           .toLowerCase();
//                       if ((status == 'pendiente') || (status == 'earring')) {
//                         warning(
//                           context,
//                           AppLocalizations.of(context)!.message_delete_plant,
//                           () async {
//                             EasyLoading.show();
//                             Navigator.pop(context);

//                             await optionServices
//                                 .delete(items[index]['id'].toString());

//                             setState(() {
//                               items = [];
//                             });

//                             _loadMore();
//                           },
//                         );
//                       } else {
//                         null;
//                       }
//                     },

//                     // Este es el onTap del servicio EDITAR Planta solo se pueden eliminar los PENDIENTES
//                     onTapEdit: () {
//                       var status = items[index]['estado_actual']
//                           .toString()
//                           .toLowerCase();
//                       if ((status == 'pendiente') || (status == 'earring')) {
//                         warning(
//                           context,
//                           AppLocalizations.of(context)!.message_edit_plant,
//                           () async {
//                             Navigator.pop(context);
//                             Navigator.push(
//                                 context,
//                                 SlideRightRoute(
//                                     page: GetApiEditInformation01(
//                                   id: items[index]['id'],
//                                 )));
//                           },
//                         );
//                       } else {
//                         null;
//                       }
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
//                   IconButton(
//                     icon: Icon(
//                       Ionicons.people_outline,
//                       color: PlantaColors.colorWhite,
//                     ),
//                     onPressed: () => goToProfile(context),
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
