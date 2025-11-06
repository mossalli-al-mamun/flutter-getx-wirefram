import 'dart:ui';
import 'package:get/get.dart';

import '../Config/themes/theme_controller.dart';
import '../Controller/locale/locale_controller.dart';
import '../Controller/locale/localization_service_controller.dart';
import '../Services/apiController/auth_api_controller.dart';
import '../Services/api_service.dart';
import '../Services/apis/auth_api_service.dart';
import '../Utils/network_controller.dart';

class CoreBindings extends Bindings {
  @override
  void dependencies() async {
    // Global singletons for always-needed
    Get.put(ThemeController(), permanent: true);
    Get.put(NetworkController(), permanent: true);
    Get.put<ApiService>(ApiService(), permanent: true);

    //Localization
    Get.put(LocaleController(), permanent: true);
    final locale = Get.locale ?? const Locale('en');
    await initializeLocalizationService(locale);

    // Auth services
    Get.put(AuthService(), permanent: true);
    Get.put(AuthApiController(), permanent: true);
  }
}

