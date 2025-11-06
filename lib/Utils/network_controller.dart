import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/locale/localization_service_controller.dart';
import 'app_logger.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final Rx<ConnectivityResult> connectionStatus = ConnectivityResult.none.obs;
  final RxList<ConnectivityResult> activeConnections =
      <ConnectivityResult>[].obs;

  // Add this to track if popup is showing
  final RxBool isShowingPopup = false.obs;
  RxBool isNoConnectionSnackbarActive = false.obs;
  final RxBool _isInitialCheck = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity().then((_) {
      _setupConnectivityListener();
    });
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  dynamic _connectivitySubscription;

  Future<void> _initConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      activeConnections.value = results;
      connectionStatus.value =
          results.isNotEmpty ? results.first : ConnectivityResult.none;

      if (connectionStatus.value == ConnectivityResult.none) {
        _showDisconnectedSnackbar();
      }
    } catch (e) {
      Get.snackbar(tr.error, '${tr.connectivityStatusError} $e');
    }
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final bool wasConnected =
            connectionStatus.value != ConnectivityResult.none;

        if (_isInitialCheck.value) {
          _isInitialCheck.value = false;
          return;
        }

        activeConnections.value = results;
        connectionStatus.value =
            results.isNotEmpty ? results.first : ConnectivityResult.none;

        final bool isNowConnected =
            connectionStatus.value != ConnectivityResult.none;

        appLogger('✅ Was connected: $wasConnected, Now: $isNowConnected');

        if (wasConnected != isNowConnected) {
          if (isNowConnected) {
            _showConnectedSnackbar();
          } else {
            _showDisconnectedSnackbar();
          }
        }
      },
    );
  }

  void _showConnectedSnackbar() {
    // First close any existing no-connection snackbar
    if (isNoConnectionSnackbarActive.value) {
      Get.closeCurrentSnackbar();
      isNoConnectionSnackbarActive.value = false;
    }

    // Then show connected notification
    Get.snackbar(
      tr.connected,
      tr.deviceOnline,
      icon: Icon(Icons.wifi, color: Colors.white),
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
      mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
          isNoConnectionSnackbarActive.value = false;
        },
        child: Text(tr.ok, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showDisconnectedSnackbar() {
    final bool isConnected = connectionStatus.value != ConnectivityResult.none;
    if (!isNoConnectionSnackbarActive.value) {
      isNoConnectionSnackbarActive.value = true;

      Get.snackbar(
        tr.noInternetConnection,
        tr.deviceOffline,
        icon: Icon(!isConnected ? Icons.wifi_off : Icons.wifi,
            color: Colors.white),
        backgroundColor: !isConnected ? Colors.red : Colors.green,
        colorText: Colors.white,
        duration: Duration(days: 1),
        isDismissible: true,
        mainButton: TextButton(
          onPressed: () {
            Get.closeCurrentSnackbar();
            isNoConnectionSnackbarActive.value = false;
          },
          child: Text(tr.ok, style: TextStyle(color: Colors.white)),
        ),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

// Public method to manually show the popup from anywhere in the app
// showNetworkStatusPopup() {
//   _showDisconnectedSnackbar();
// }
}
