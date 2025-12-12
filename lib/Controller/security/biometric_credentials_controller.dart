import 'package:get/get.dart';

import '../../Services/apis/auth_api_service.dart';

class BiometricCredentialsController extends GetxController {
  final isLoading = false.obs;
  final errorText = RxnString();

  final AuthService _authService = Get.find<AuthService>();

  Future<bool> verify(String emailOrUsername, String password) async {
    if (isLoading.value) return false;

    errorText.value = null;
    isLoading.value = true;

    try {
      // final ok = await _authService.verifyCredentialsWithServer(
      //   emailOrUsername.trim(),
      //   password,
      // );

      // if (!ok) {
      //   errorText.value =
      //       'invalidCredentials'; // fallback key UI resolves via tr
      //   return false;
      // }

      return true;
    } catch (e) {
      // server message if available, otherwise fallback
      final message = e.toString().trim();
      if (message.isNotEmpty && message != 'Exception') {
        errorText.value = message; // show server error message directly
      } else {
        errorText.value = 'error'; // generic translation key
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
