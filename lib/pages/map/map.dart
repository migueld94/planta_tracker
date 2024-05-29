import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:planta_tracker/assets/utils/widgets/my_custom_card.dart';
import 'package:planta_tracker/blocs/gps/gps_bloc.dart';
import 'package:planta_tracker/blocs/gps/gps_event.dart';
import 'package:planta_tracker/blocs/gps/gps_state.dart';
import 'package:planta_tracker/blocs/map/map_bloc.dart';
import 'package:planta_tracker/blocs/map/map_state.dart';
import 'package:http/http.dart' as http;
import 'package:planta_tracker/models/plants_models.dart';
import 'package:planta_tracker/services/all_plants_services.dart';

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

    final allspecie =
        Uri.parse('${Constants.baseUrl}/es/api/especie_list?page=$next');

    final response = await http.get(allspecie,
        headers: <String, String>{'authorization': "Bearer $accessToken"});

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)['results'] as List;
      setState(() {
        items.addAll(json);
      });
    }
  }

  @override
  void initState() {
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
      body: Stack(
        children: [
          BlocConsumer<GpsBloc, GpsState>(
            listener: (context, gpsState) {
              if (gpsState is GpsPermissionDenied ||
                  gpsState is GpsPermissionDeniedForever) {
                // final l10n = AppLocalizations.of(context);
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
                      return _buildMap(context, mapState.location);
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
                                  hintText: 'buscar',
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

  Widget _buildMap(BuildContext context, LatLng location) {
    return FutureBuilder<List<Plant>>(
      future:
          AllPlantServices().getAllPlants(context, 1), // el 1 es el currentPage
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Plant> plants = snapshot.data!;
          return FlutterMap(
            options: MapOptions(
              initialCenter: location,
              minZoom: 5,
              maxZoom: 25,
              initialZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              ),
              MarkerLayer(markers: [
                Marker(
                  point: location,
                  child: const Icon(
                    Icons.person_pin_circle,
                    color: Colors.blue,
                    size: 40,
                  ),
                ),
                ...createMarkers(
                  plants,
                  const Icon(
                    Icons.pin_drop,
                    color: Colors.blue,
                    size: 40,
                  ),
                ),
              ]),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );

    // FlutterMap(
    //   options: MapOptions(
    //     initialCenter: location,
    //     minZoom: 5,
    //     maxZoom: 25,
    //     initialZoom: 18,
    //   ),
    //   children: [
    //     TileLayer(
    //       urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    //       userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    //     ),
    //     MarkerLayer(markers: [
    //       Marker(
    //         point: location,
    //         child: const Icon(
    //           Icons.person_pin_circle,
    //           color: Colors.blue,
    //           size: 40,
    //         ),
    //       ),

    //     ]),
    //   ],
    // );
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
}

//class CustomMaker para otros pines en el mapa
class CustomMarker extends Marker {
  CustomMarker(LatLng point, Widget child) : super(point: point, child: child);
}

//funcion para generar lista de posiciones para el customMarker
List<CustomMarker> createMarkers(List<Plant> plants, Widget child) {
  return plants.map((plant) {
    LatLng location = LatLng(plant.latitude!, plant.longitude!);
    return CustomMarker(location, child);
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
