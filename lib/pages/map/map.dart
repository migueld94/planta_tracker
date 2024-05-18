import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:planta_tracker/assets/utils/widgets/my_custom_card.dart';
import 'package:planta_tracker/blocs/gps/gps_bloc.dart';
import 'package:planta_tracker/blocs/gps/gps_event.dart';
import 'package:planta_tracker/blocs/gps/gps_state.dart';
import 'package:planta_tracker/blocs/map/map_bloc.dart';
import 'package:planta_tracker/blocs/map/map_state.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  TextEditingController? controller;
  String search = '';
  String selectedFilter = '';
  double fabBottomOffset = 140; // Offset inicial para el botón flotante

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
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                    controller: scrollController,
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
                          (BuildContext context, int index) {
                            return const MyCustomCard(
                              title:
                                  'Excoecaria biglandulosa var. petiolaris Mull. Arg.',
                            );
                          },
                          childCount: 10,
                        ),
                      ),
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
        ]),
      ],
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
