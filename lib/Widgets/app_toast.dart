import 'package:flutter/material.dart';

class AppToast {
  static void show(BuildContext context, String message, {int duration = 3}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.all(20),
        content: Text(message),
        duration: Duration(seconds: duration),
        behavior: SnackBarBehavior.floating,
        //   action: SnackBarAction(
        //     label: 'Close',
        //     onPressed: () {
        //       // ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //       GlobalVariables.rootScaffoldMessengerKey.currentState!.hideCurrentSnackBar();
        //     },
        //   ),
      ),
    );
  }
}