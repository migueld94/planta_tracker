// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/l10n/l10n.dart';
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';
import 'package:planta_tracker/assets/utils/widgets/card_plant.dart';

class MyPlants extends StatefulWidget {
  const MyPlants({super.key});

  @override
  State<MyPlants> createState() => _MyPlantsState();
}

class _MyPlantsState extends State<MyPlants> {
  List items = [];
  int next = 1;
  var secretUrl = Uri.parse('${Constants.baseUrl}/en/api/o/token/');
  ScrollController scroll = ScrollController();
  bool isLoadMore = false;
  final storage = const FlutterSecureStorage();

  _loadMore() async {
    final token = await storage.read(key: "token");
    String idioma = getFlag();

    final myPlantsUri =
        Uri.parse('${Constants.baseUrl}/$idioma/api/my_plants?page=$next');

    final response = await http.get(myPlantsUri,
        headers: <String, String>{'authorization': "Bearer $token"});

    try {
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body)['results'] as List;
        setState(() {
          items.addAll(json);
        });
      }
    } catch (e) {
      log('Error => ${e.toString()}');
    }
  }

  String getFlag() {
    final locale = Localizations.localeOf(context);
    var flag = L10n.getFlag(locale.languageCode);
    return flag;
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
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              controller: scroll,
              itemCount: isLoadMore ? items.length + 1 : items.length,
              separatorBuilder: (context, index) => verticalMargin4,
              itemBuilder: (context, index) {
                log(isLoadMore.toString());
                if (items.isEmpty) {
                  return const AutoSizeText('No se encontraron elementos');
                } else if (index >= items.length) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final date = DateTime.parse(items[index]["fecha_registro_"]);
                  return CardMyPlants(
                    picture: items[index]['imagen_principal'],
                    title: items[index]['especie_planta'],
                    lifestage: items[index]['lifestage'],
                    status: items[index]['estado_actual'],
                    date: '${date.day} / ${date.month} / ${date.year}',
                    onTap: () {
                      // Navigator.push(
                      //     context, SlideRightRoute(page: const Details()));
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
