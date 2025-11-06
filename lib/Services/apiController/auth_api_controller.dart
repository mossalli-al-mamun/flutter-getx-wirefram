// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../Utils/app_logger.dart';
// import '../auth_service.dart';
//
//
// class AuthApiController extends GetxController {
//   RxBool isLoading = RxBool(false);
//
//   final AuthService _authService = Get.find().authService;
//
//
//   Future<void> signIn(BuildContext context, formData) async {
//     try {
//       await _authService.signIn(context, formData);
//     } catch (e, stack) {
//       appLogger('Error signIn: $e, $stack');
//     }
//   }
//
//   Future<void> signOut(BuildContext context, screen) async {
//     try {
//       _authService.signOut(context, screen);
//     } catch (e) {
//       appLogger('Error signOut: $e');
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/app_logger.dart';
import '../apis/auth_api_service.dart';

class AuthApiController extends GetxController {
  RxBool isLoading = RxBool(false);

  final AuthService _authService = Get.find<AuthService>();

  Future<void> signIn(BuildContext context, formData) async {
    try {
      await _authService.signIn(context, formData);
    } catch (e, stack) {
      appLogger('Error signIn: $e, $stack');
    }
  }

  Future<void> signUp(BuildContext context, formData) async {
    try {
      await _authService.signUp(context, formData);
    } catch (e, stack) {
      appLogger('Error signIn: $e, $stack');
    }
  }

  Future<void> signOut(BuildContext context, screen) async {
    try {
      _authService.signOut(context, screen);
    } catch (e) {
      appLogger('Error signOut: $e');
    }
  }
}
