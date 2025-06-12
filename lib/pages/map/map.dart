// ignore_for_file: unused_local_variable, use_build_context_synchronously
import 'dart:convert';

import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:http/http.dart' as http;

import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:planta_tracker/assets/utils/helpers/sliderightroute.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/my_custom_card.dart';
import 'package:planta_tracker/blocs/gps/gps_bloc.dart';
import 'package:planta_tracker/blocs/gps/gps_event.dart';
import 'package:planta_tracker/blocs/gps/gps_state.dart';
import 'package:planta_tracker/blocs/map/map_bloc.dart';
import 'package:planta_tracker/blocs/map/map_state.dart';
import 'package:planta_tracker/models/plants_models.dart';
import 'package:planta_tracker/pages/details_plant/details.dart';
import 'package:planta_tracker/pages/map/bloc/plants_map_bloc.dart';
import 'package:planta_tracker/services/all_plants_services.dart';
import 'package:planta_tracker/assets/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final AllPlantServices plantServices = AllPlantServices();
  TextEditingController? controller;
  String search = '';
  String selectedFilter = '';
  double fabBottomOffset = 110; // Offset inicial para el botón flotante
  List items = [];
  int next = 1;
  var secretUrl = Uri.parse('${Constants.baseUrl}/en/api/o/token/');
  DraggableScrollableController scroll = DraggableScrollableController();
  bool isLoadMore = false;
  List copy = [];
  final debouncer = Debouncer();
  bool filter = false;
  int selectedIndex = -1;

  double maxLat = 0.0;
  double minLat = 0.0;
  late LatLngBounds visibleRegion;

  _loadMore() async {
    String client = 'IMIUgjEXwzviJeCfVzCQw4g8GkhUpYGbcDieCxSE';
    String secret =
        'rOsMV2OjTPs89ku5NlWuukWNMfm9CDO3nZuzOxRWYCPUSSxnZcCfUl8XnU1HcPTfCqCTpZxYhv3zNYUB0H1hlQ6b7heLWsoqgJjLSkwAsZp7NTwT2B1D8nwfTS6bfvpw';
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';

    var resp = await http.post(
      secretUrl,
      headers: <String, String>{'authorization': basicAuth},
      body: {"grant_type": "client_credentials"},
    );

    final Map<String, dynamic> data = json.decode(resp.body);
    final accessToken = data["access_token"];

    final allspecie = Uri.parse(
      '${Constants.baseUrl}/es/api/especie_list?page=$next',
    );

    final response = await http.get(
      allspecie,
      headers: <String, String>{'authorization': "Bearer $accessToken"},
    );

    final utf = const Utf8Decoder().convert(response.body.codeUnits);

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      final json = jsonDecode(utf)['results'] as List;
      setState(() {
        items.addAll(json);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.show();
    _loadMore();
    scroll.addListener(() async {
      if (scroll.size >= 1.0) {
        if (isLoadMore == true) return;
        setState(() {
          isLoadMore = true;
        });
        next++;
        _loadMore().then((_) {
          setState(() {
            isLoadMore = false;
          });
        });
      }
      // if (scroll. == scroll.position.maxScrollExtent) {
      //   setState(() {
      //     isLoadMore = true;
      //   });
      //   next++;
      //   await _loadMore();
      //   setState(() {
      //     isLoadMore = false;
      //   });
      // }
    });
    _loadSelectedIndex();
  }

  _loadSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedIndex = prefs.getInt('selected_index') ?? -1;
      // filter = prefs.getBool('filter') ?? false;
    });
  }

  _saveSelectedIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('selected_index', index);
    // prefs.setBool('filter', filter);
  }

  updateList(String value) async {
    if (copy.isEmpty) {
      copy = items;
    } else {
      items = copy;
    }

    String client = 'IMIUgjEXwzviJeCfVzCQw4g8GkhUpYGbcDieCxSE';
    String secret =
        'rOsMV2OjTPs89ku5NlWuukWNMfm9CDO3nZuzOxRWYCPUSSxnZcCfUl8XnU1HcPTfCqCTpZxYhv3zNYUB0H1hlQ6b7heLWsoqgJjLSkwAsZp7NTwT2B1D8nwfTS6bfvpw';
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';

    var resp = await http.post(
      secretUrl,
      headers: <String, String>{'authorization': basicAuth},
      body: {"grant_type": "client_credentials"},
    );

    final Map<String, dynamic> data = json.decode(resp.body);
    final accessToken = data["access_token"];

    final searchSpecie = Uri.parse(
      '${Constants.baseUrl}/en/api/especie_list/search?q=$value',
    );

    final response = await http.get(
      searchSpecie,
      headers: <String, String>{'authorization': "Bearer $accessToken"},
    );

    final utf = const Utf8Decoder().convert(response.body.codeUnits);

    if (response.statusCode == 200) {
      setState(() {
        items = jsonDecode(utf)['results'] as List;
      });
      EasyLoading.dismiss();
    } else {
      log('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocConsumer<GpsBloc, GpsState>(
            listener: (context, gpsState) {
              if (gpsState is GpsPermissionDenied ||
                  gpsState is GpsPermissionDeniedForever) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('acepte los permisos')),
                );
              }
            },
            builder: (context, gpsState) {
              if (gpsState is GpsLoadSuccess) {
                return BlocBuilder<MapBloc, MapState>(
                  builder: (context, mapState) {
                    if (mapState is MapLoadSuccess) {
                      return const AppFlutterMap();
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.4,
            controller: scroll,
            builder: (context, scroll) {
              return Container(
                decoration: BoxDecoration(
                  color: PlantaColors.colorWhite,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10.0,
                      color: PlantaColors.colorBlack.withOpacity(0.7),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    verticalMargin8,
                    Container(
                      width: 40.0,
                      height: 5.0,
                      decoration: BoxDecoration(
                        borderRadius: borderRadius10,
                        color: PlantaColors.greyDisabled.withOpacity(0.3),
                      ),
                    ),
                    Padding(
                      padding: allPadding8,
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.search,
                          border: OutlineInputBorder(
                            borderRadius: borderRadius10,
                            borderSide: BorderSide(
                              color: PlantaColors.colorBlack,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.toLowerCase().length >= 3) {
                            debouncer.debounce(
                              duration: const Duration(milliseconds: 500),
                              onDebounce: () {
                                EasyLoading.show();
                                updateList(value);
                              },
                            );
                          } else {
                            debouncer.debounce(
                              duration: const Duration(milliseconds: 500),
                              onDebounce: () {
                                EasyLoading.show();
                                setState(() {
                                  items.clear();
                                });
                                _loadMore();
                              },
                            );
                          }
                        },
                      ),
                    ),
                    items.isEmpty
                        ? AutoSizeText(
                          AppLocalizations.of(context)!.search_without_results,
                          style: context.theme.textTheme.text_01.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontSize: 16,
                          ),
                        )
                        : Expanded(
                          child: ListView.builder(
                            controller: scroll,
                            itemCount:
                                isLoadMore ? items.length + 1 : items.length,
                            itemBuilder: (context, index) {
                              if (index >= items.length) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return MyCustomCard(
                                  backgroundColor:
                                      selectedIndex == items[index]['id']
                                          ? PlantaColors.colorGreen
                                          : PlantaColors.colorWhite,
                                  colorText:
                                      selectedIndex == items[index]['id']
                                          ? PlantaColors.colorWhite
                                          : PlantaColors.colorBlack,
                                  title: items[index]['nombre_especie'],
                                  onTap: () {
                                    // setState(() {
                                    //   filter = !filter;
                                    //   if (selectedIndex ==
                                    //       items[index]['id']) {
                                    //     selectedIndex = -1;
                                    //   } else {
                                    //     selectedIndex = items[index]['id'];
                                    //   }
                                    // });

                                    setState(() {
                                      if (selectedIndex == items[index]['id']) {
                                        // Si el usuario vuelve a presionar el mismo elemento, deselecciónalo
                                        context.read<PlantsMapBloc>().add(
                                          const PlantsMapEvent.load(),
                                        );
                                        selectedIndex = -1;
                                      } else {
                                        // De lo contrario, selecciona el nuevo elemento y deselecciona el anterior
                                        context.read<PlantsMapBloc>().add(
                                          PlantsMapEvent.loadById(
                                            items[index]['id'],
                                          ),
                                        );
                                        selectedIndex = items[index]['id'];
                                      }
                                    });

                                    _saveSelectedIndex(selectedIndex);

                                    // if (filter == false) {
                                    // context.read<PlantsMapBloc>().add(
                                    //       const PlantsMapEvent.load(),
                                    //     );
                                    // } else {
                                    // context.read<PlantsMapBloc>().add(
                                    //       PlantsMapEvent.loadById(
                                    //         items[index]['id'],
                                    //       ),
                                    //     );
                                    // }
                                  },
                                );
                              }
                            },
                          ),
                        ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            right: 10,
            bottom: 270,
            child: FloatingActionButton(
              onPressed: () {
                context.read<GpsBloc>().add(GpsStarted());
              },
              backgroundColor: PlantaColors.colorGreen,
              child: Icon(Icons.my_location, color: PlantaColors.colorBlack),
            ),
          ),
        ],
      ),
    );
  }

  Widget filterButton(String text, IconData icon, String filter) {
    final bool isSelected = selectedFilter == filter;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedFilter = filter;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.black,
        backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        elevation: 5.0,
        shadowColor: Colors.black,
        side: BorderSide(color: isSelected ? Colors.blue : Colors.grey),
      ),
      child: Row(
        children: [Icon(icon), const SizedBox(width: 8.0), Text(text)],
      ),
    );
  }

  void getLocations() async {
    var positions = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (positions.latitude > maxLat) {
      maxLat = positions.latitude;
    }

    if (positions.latitude < minLat) {
      minLat = positions.latitude;
    }
  }
}

//class CustomMaker para otros pines en el mapa
class CustomMarker extends Marker {
  const CustomMarker(LatLng point, Widget child)
    : super(point: point, child: child);
}

//funcion para generar lista de posiciones para el customMarker
// List<CustomMarker> createMarkers(List<Plant> plants, Widget child) {
//   return plants.map((plant) {
//     LatLng location = LatLng(plant.latitude!, plant.longitude!);
//     return CustomMarker(location, child);
//   }).toList();
// }
List<CustomMarker> createMarkers(List<Plant> plants, BuildContext context) {
  return plants.map((plant) {
    LatLng location = LatLng(plant.latitude!, plant.longitude!);

    Color getColor() {
      if ((plant.estadoActual?.toLowerCase() == 'aprobado') ||
          (plant.estadoActual?.toLowerCase() == 'approved')) {
        return PlantaColors.colorDarkGreen;
      } else if ((plant.estadoActual?.toLowerCase() == 'en revision') ||
          (plant.estadoActual?.toLowerCase() == 'revision')) {
        return PlantaColors.colorLightGreen;
      }
      return PlantaColors.colorDarkOrange;
    }

    return CustomMarker(
      location,
      GestureDetector(
        onTap: () {
          info(
            context,
            // plant.lifestage!,
            plant.estadoActual!,
            plant.especiePlanta ?? AppLocalizations.of(context)!.name_plant,
            getColor(),
            () {
              Navigator.push(
                context,
                SlideRightRoute(page: Details(id: plant.id!)),
              );
            },
          );
        },
        child: Icon(Ionicons.location_sharp, color: getColor(), size: 40),
      ),
    );
  }).toList();
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

//andres
class AppFlutterMap extends StatelessWidget {
  const AppFlutterMap({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlantsMapBloc, PlantsMapState>(
      builder: (context, state) {
        if (state.userLocation == null) {
          return Center(
            child: AutoSizeText(
              AppLocalizations.of(context)!.get_location,
              style: context.theme.textTheme.text_01,
            ),
          );
        }

        return FlutterMap(
          mapController: MapController(),
          options: MapOptions(
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
            initialCenter: state.userLocation ?? const LatLng(0, 0),
            minZoom: 5,
            maxZoom: 25,
            initialZoom: 18,
            onPositionChanged: (position, hasGesture) {
              if (hasGesture) {
                final (northEast, southWest) = (
                  position.bounds!.northEast,
                  position.bounds!.southWest,
                );

                context.read<PlantsMapBloc>().add(
                  PlantsMapEvent.loadMoreByBoundries(northEast, southWest),
                );
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: state.userLocation ?? const LatLng(0, 0),
                  child: const Icon(
                    Icons.person_pin_circle,
                    color: Colors.blue,
                    size: 40,
                  ),
                ),
                ...createMarkers(state.plants, context),
              ],
            ),
          ],
        );
      },
    );
  }
}
