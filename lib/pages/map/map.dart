// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:latlong2/latlong.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  double fabBottomOffset = 140; // Offset inicial para el botón flotante
  List items = [];
  int next = 1;
  var secretUrl = Uri.parse('${Constants.baseUrl}/en/api/o/token/');
  ScrollController scroll = ScrollController();
  bool isLoadMore = false;

  double maxLat = 0.0;
  double minLat = 0.0;
  late LatLngBounds visibleRegion;

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
                      return BlocProvider(
                        create: (_) => PlantsMapBloc(AllPlantServices()),
                        child: const AppFlutterMap(),
                      );
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
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              final screenHeight = MediaQuery.of(context).size.height;
              final bottomSheetHeight = notification.extent * screenHeight;
              final bottomOffset = screenHeight - bottomSheetHeight;
              setState(() {
                fabBottomOffset =
                    screenHeight - bottomOffset - 2; // margen adicional
              });
              return true;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.2,
              minChildSize: 0.1,
              maxChildSize: 0.8,
              builder: (context, scroll) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10.0,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  child: CustomScrollView(
                    controller: scroll,
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
                              child: TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                  hintText: '$maxLat, $minLat',
                                  hintStyle:
                                      const TextStyle(color: Colors.blue),
                                  prefixIcon: const Icon(Icons.search,
                                      color: Colors.blue),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                  ),
                                ),
                                onSubmitted: (String value) {
                                  setState(() {
                                    search = controller!.text;
                                  });
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  //filtros aqui,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount:
                              isLoadMore ? items.length + 1 : items.length,
                          (BuildContext context, int index) {
                            if (index >= items.length) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              return MyCustomCard(
                                title: items[index]['nombre_especie'],
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            right: 20,
            bottom: fabBottomOffset,
            child: FloatingActionButton(
              onPressed: () {
                // getLocations();
                context.read<GpsBloc>().add(GpsStarted());
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.my_location),
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
        children: [
          Icon(icon),
          const SizedBox(width: 8.0),
          Text(text),
        ],
      ),
    );
  }

  void getLocations() async {
    var positions = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (positions.latitude > maxLat) {
      maxLat = positions.latitude;
    }

    if (positions.latitude < minLat) {
      minLat = positions.latitude;
    }

    log('Max Latitud $maxLat');
    log('Min Latitud $minLat');
  }
}

//class CustomMaker para otros pines en el mapa
class CustomMarker extends Marker {
  const CustomMarker(LatLng point, Widget child)
      : super(
          point: point,
          child: child,
        );
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
              plant.lifestage!,
              plant.estadoActual!,
              plant.especiePlanta ?? AppLocalizations.of(context)!.name_plant,
              getColor(), () {
            Navigator.push(
                context, SlideRightRoute(page: Details(id: plant.id!)));
          });
        },
        child: Icon(
          Ionicons.location_sharp,
          color: getColor(),
          size: 40,
        ),
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
      BuildContext context, double shrinkOffset, bool overlapsContent) {
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
          return const Center(child: Text('Obteniendo ubicación...'));
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
            MarkerLayer(markers: [
              Marker(
                point: state.userLocation ?? const LatLng(0, 0),
                child: const Icon(
                  Icons.person_pin_circle,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
              ...createMarkers(state.plants, context),
            ]),
          ],
        );
      },
    );
  }
}
