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
