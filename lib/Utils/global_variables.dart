import 'package:flutter/material.dart';

class GlobalVariables {
  /// This global key is used in material app for navigation through firebase notifications.
  // static final GlobalKey<NavigatorState> navigatorState = GlobalKey<NavigatorState>();
  /// This global key is used in material app for toast with snackbar.
  static final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
}