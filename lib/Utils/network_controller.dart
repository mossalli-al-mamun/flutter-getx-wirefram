import 'dart:async';
import 'dart:io';
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

  final RxBool isShowingPopup = false.obs;
  RxBool isNoConnectionSnackbarActive = false.obs;
  final RxBool _isInitialCheck = true.obs;

  // Track if we're in a network transition
  Timer? _transitionTimer;
  bool isInTransition = false;

  // Helper: wait until Get has an overlay/context ready, to safely show snackbars
  Future<bool> _waitForOverlay({
    int retries = 30,
    Duration interval = const Duration(milliseconds: 200),
  }) async {
    for (int i = 0; i < retries; i++) {
      if (Get.overlayContext != null || Get.context != null) {
        return true;
      }
      await Future.delayed(interval);
    }
    return false;
  }

  // Helper: safe close current snackbar (guards against uninitialized controller)
  void _safeCloseCurrentSnackbar() {
    try {
      if (Get.isSnackbarOpen == true) {
        Get.closeCurrentSnackbar();
      }
    } catch (e) {
      appLogger('Safe close snackbar ignored: $e');
    }
  }

  // Check actual internet connectivity
  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
        // Alternative hosts for internet check: If Google is blocked in your region, you can use 'cloudflare.com', '1.1.1.1', or '8.8.8.8' instead.
      ).timeout(Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      appLogger('Internet check failed: $e');
      return false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _initConnectivity().then((_) {
      _setupConnectivityListener();
    });
  }

  @override
  void onClose() {
    _transitionTimer?.cancel();
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  dynamic _connectivitySubscription;

  Future<void> _initConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      activeConnections.value = results;
      connectionStatus.value = results.isNotEmpty
          ? results.first
          : ConnectivityResult.none;

      appLogger('Initial connectivity: ${connectionStatus.value}');

      if (connectionStatus.value == ConnectivityResult.none) {
        await _showDisconnectedSnackbar();
      }
    } catch (e) {
      if (await _waitForOverlay()) {
        Get.snackbar(tr.error, '${tr.connectivityStatusError} $e');
      } else {
        appLogger('Connectivity init error (no overlay yet): $e');
      }
    }
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
        List<ConnectivityResult> results,
        ) async {
      if (_isInitialCheck.value) {
        _isInitialCheck.value = false;
        return;
      }

      final bool wasConnected =
          connectionStatus.value != ConnectivityResult.none;

      activeConnections.value = results;
      final newStatus = results.isNotEmpty
          ? results.first
          : ConnectivityResult.none;
      final bool isNowConnected = newStatus != ConnectivityResult.none;

      appLogger(
        'Network change: $wasConnected → $isNowConnected, Status: ${connectionStatus.value} → $newStatus',
      );

      // Case 1: Connected to disconnected
      if (wasConnected && !isNowConnected) {
        appLogger('Detected possible disconnect, starting transition timer...');

        // Mark that we're in a transition
        isInTransition = true;
        _transitionTimer?.cancel();

        // Wait briefly to see if we reconnect (network switch scenario)
        _transitionTimer = Timer(Duration(milliseconds: 1500), () async {
          isInTransition = false;

          // Check current status again
          final currentResults = await _connectivity.checkConnectivity();
          final currentStatus = currentResults.isNotEmpty
              ? currentResults.first
              : ConnectivityResult.none;

          appLogger('After transition timer: $currentStatus');

          // If still disconnected, check actual internet
          if (currentStatus == ConnectivityResult.none) {
            final hasInternet = await _hasInternetConnection();
            appLogger('Internet check result: $hasInternet');

            if (!hasInternet) {
              connectionStatus.value = ConnectivityResult.none;
              await _showDisconnectedSnackbar();
            } else {
              appLogger('False alarm - still have internet');
            }
          } else {
            // Reconnected during the wait period (likely network switch)
            appLogger(
              'Reconnected during transition - network switch detected',
            );
            connectionStatus.value = currentStatus;
          }
        });
      }
      // Case 2: Disconnected to connected
      else if (!wasConnected && isNowConnected) {
        appLogger('Detected reconnection');

        // Cancel any pending disconnect check
        _transitionTimer?.cancel();
        isInTransition = false;

        connectionStatus.value = newStatus;
        await _showConnectedSnackbar();
      }
      // Case 3: Network type change (wifi to mobile or vice versa)
      else if (wasConnected &&
          isNowConnected &&
          connectionStatus.value != newStatus) {
        appLogger(
          'Network type changed: ${connectionStatus.value} → $newStatus',
        );

        // Cancel any pending actions
        _transitionTimer?.cancel();
        isInTransition = false;

        connectionStatus.value = newStatus;

        // Close any existing disconnected snackbar
        if (isNoConnectionSnackbarActive.value) {
          _safeCloseCurrentSnackbar();
          isNoConnectionSnackbarActive.value = false;
        }
      }
      // Case 4: Still connected (no change in connectivity state)
      else {
        appLogger('No significant change in connectivity');
        connectionStatus.value = newStatus;
      }
    });
  }

  Future<void> _showConnectedSnackbar() async {
    appLogger('Attempting to show connected snackbar...');

    // First close any existing no-connection snackbar
    if (isNoConnectionSnackbarActive.value) {
      _safeCloseCurrentSnackbar();
      isNoConnectionSnackbarActive.value = false;
    }

    // Wait for overlay/context to be ready
    final ready = await _waitForOverlay();
    if (!ready) {
      appLogger('Overlay not ready to show connected snackbar. Skipping.');
      return;
    }

    try {
      appLogger('Showing connected snackbar');
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
            _safeCloseCurrentSnackbar();
          },
          child: Text(tr.ok, style: TextStyle(color: Colors.white)),
        ),
      );
    } catch (e) {
      appLogger('Failed to show connected snackbar: $e');
    }
  }

  Future<void> _showDisconnectedSnackbar() async {
    appLogger('Attempting to show disconnected snackbar...');

    if (isNoConnectionSnackbarActive.value) {
      appLogger('Disconnected snackbar already active');
      return;
    }

    final ready = await _waitForOverlay();
    if (!ready) {
      appLogger('Overlay not ready to show disconnected snackbar. Skipping.');
      return;
    }

    try {
      appLogger('Showing disconnected snackbar');
      isNoConnectionSnackbarActive.value = true;
      Get.snackbar(
        tr.noInternetConnection,
        tr.deviceOffline,
        icon: Icon(Icons.wifi_off, color: Colors.white),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(days: 1),
        isDismissible: true,
        mainButton: TextButton(
          onPressed: () {
            _safeCloseCurrentSnackbar();
            isNoConnectionSnackbarActive.value = false;
          },
          child: Text(tr.ok, style: TextStyle(color: Colors.white)),
        ),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isNoConnectionSnackbarActive.value = false;
      appLogger('Failed to show disconnected snackbar: $e');
    }
  }
}