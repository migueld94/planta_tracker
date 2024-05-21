// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';
import 'package:planta_tracker/assets/utils/constants.dart';
import 'package:planta_tracker/assets/utils/methods/utils.dart';
import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';

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
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              controller: scroll,
              itemCount: isLoadMore ? items.length + 1 : items.length,
              separatorBuilder: (context, index) => verticalMargin4,
              itemBuilder: (context, index) {
                if (index >= items.length) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Container(
                    width: double.infinity,
                    height: 90.0,
                    color: PlantaColors.colorBlue,
                    child: Center(
                      child: Text(
                        items[index]['nombre_especie'],
                      ),
                    ),
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
