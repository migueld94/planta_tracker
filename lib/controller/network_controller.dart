import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:planta_tracker/assets/utils/theme/themes_provider.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionsStatus);
  }

  void _updateConnectionsStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      Get.rawSnackbar(
        messageText: AutoSizeText(
          'Please Connect to the internet',
          style: TextStyle(
            color: PlantaColors.colorWhite,
            fontSize: 14.0,
            fontFamily: 'Nunito',
          ),
        ),
        isDismissible: false,
        duration: const Duration(days: 1),
        backgroundColor: PlantaColors.colorDarkOrange,
        icon: Icon(Ionicons.wifi_outline, color: PlantaColors.colorWhite),
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.FLOATING,
      );
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}
