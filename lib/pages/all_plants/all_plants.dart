// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/l10n/l10n.dart';
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/card_plant.dart';
import 'package:planta_tracker/pages/details_plant/details.dart';

class AllPlants extends StatefulWidget {
  const AllPlants({super.key});

  @override
  State<AllPlants> createState() => _AllPlantsState();
}

class _AllPlantsState extends State<AllPlants> {
  List items = [];
  int next = 1;
  var secretUrl = Uri.parse('${Constants.baseUrl}/en/api/o/token/');
  ScrollController scroll = ScrollController();
  bool isLoadMore = false;
  final String noPicture =
      'https://static.vecteezy.com/system/resources/previews/004/141/669/non_2x/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not-available-or-image-coming-soon-sign-simple-nature-silhouette-in-frame-isolated-illustration-vector.jpg';

  _loadMore() async {
    String client = 'IMIUgjEXwzviJeCfVzCQw4g8GkhUpYGbcDieCxSE';
    String secret =
        'rOsMV2OjTPs89ku5NlWuukWNMfm9CDO3nZuzOxRWYCPUSSxnZcCfUl8XnU1HcPTfCqCTpZxYhv3zNYUB0H1hlQ6b7heLWsoqgJjLSkwAsZp7NTwT2B1D8nwfTS6bfvpw';
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';

    var resp = await http.post(secretUrl, headers: <String, String>{
      'authorization': basicAuth
    }, body: {
      "grant_type": "client_credentials",
    });

    final Map<String, dynamic> data = json.decode(resp.body);
    final accessToken = data["access_token"];

    String idioma = getFlag();

    final allplants =
        Uri.parse('${Constants.baseUrl}/$idioma/api/plants_api?page=$next');

    final response = await http.get(allplants,
        headers: <String, String>{'authorization': "Bearer $accessToken"});

    final utf = const Utf8Decoder().convert(response.body.codeUnits);
    
    if (response.statusCode == 200) {
      final json = jsonDecode(utf)['results'] as List;
      setState(() {
        items.addAll(json);
      });
    }
  }

  String getFlag() {
    final locale = Localizations.localeOf(context);
    var flag = L10n.getFlag(locale.languageCode);
    return flag;
  }

  @override
  void initState() {
    EasyLoading.show();
    _loadMore();
    scroll.addListener(() async {
      if (isLoadMore == true) return;
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        setState(() {
          isLoadMore = true;
        });
        next++;
        await _loadMore();
        setState(() {
          isLoadMore = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              controller: scroll,
              itemCount: isLoadMore ? items.length + 1 : items.length,
              separatorBuilder: (context, index) => verticalMargin4,
              itemBuilder: (context, index) {
                EasyLoading.dismiss();
                if (index >= items.length) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final date = DateTime.parse(items[index]["fecha_registro_"]);
                  return CardPlant(
                    picture: items[index]['imagen_principal'] ?? noPicture,
                    title: items[index]['especie_planta'] ?? 'Determinación pendiente',
                    lifestage: items[index]['lifestage'] ?? '',
                    status: items[index]['estado_actual'] ?? '',
                    date: '${date.day} / ${date.month} / ${date.year}',
                    onTap: () {
                      Navigator.push(
                        context,
                        SlideRightRoute(
                          page: Details(
                            id: items[index]['id'],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: PlantaColors.colorGreen,
        onPressed: () => goToRegisterPlant(context),
        child: Icon(
          Ionicons.add_outline,
          color: PlantaColors.colorWhite,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Ink(
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
    );
  }
}

// class All extends StatefulWidget {
//   const All({super.key});

//   @override
//   State<All> createState() => _AllState();
// }

// class _AllState extends State<All> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: const AllPlants(),
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
//       bottomNavigationBar: Ink(
//         height: 60.0,
//         child: ClipRRect(
//           borderRadius: BorderRadius.only(
//             topLeft: borderRadius10.topLeft,
//             topRight: borderRadius10.topRight,
//           ),
//           child: BottomAppBar(
//             color: PlantaColors.colorGreen,
//             elevation: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     Ionicons.people_outline,
//                     color: PlantaColors.colorWhite,
//                   ),
//                   onPressed: () => goToProfile(context),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AllPlants extends StatefulWidget {
//   const AllPlants({super.key});

//   @override
//   State<AllPlants> createState() => _AllPlantsState();
// }

// class _AllPlantsState extends State<AllPlants> {
//   final ScrollController _scrollController = ScrollController();
//   int currentPage = 1;
//   List<Plant> movies = [];
//   final AllPlantServices plantServices = AllPlantServices();

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(() async {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         currentPage++;
//         await plantServices
//             .getAllPlants(context, currentPage)
//             .then((newMovies) {
//           setState(() {
//             movies.addAll(newMovies);
//           });
//         });
//         log(movies.length.toString());
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Plant>>(
//       future: plantServices.getAllPlants(context, currentPage),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return const Text('Error loading data');
//         } else if (snapshot.hasData) {
//           movies.addAll(snapshot.data!);
//           return ListView.builder(
//             controller: _scrollController,
//             itemCount: movies.length,
//             itemBuilder: (context, index) {
//               log(movies.length.toString());
//               return CardPlant(
//                 picture: movies[index].imagenPrincipal,
//                 title: movies[index].name,
//                 lifestage: movies[index].lifestage,
//                 status: movies[index].status,
//                 date: '17/02/90',
//                 onTap: () {
//                   Navigator.push(
//                       context, SlideRightRoute(page: const Details()));
//                 },
//               );
//             },
//           );
//         } else {
//           return const Text('No data available');
//         }
//       },
//     );
//   }
// }
