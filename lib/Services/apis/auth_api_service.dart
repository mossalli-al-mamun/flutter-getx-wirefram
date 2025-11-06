import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_getx_wireframe/Navigation/navigation_ext.dart';
import 'package:flutter_getx_wireframe/Utils/app_logger.dart';

import '../../Models/user/user_model.dart';
import '../../Navigation/routes.dart';
import '../../Utils/local_storage_manager.dart';
import '../../Utils/token_manager.dart';
import '../../Widgets/app_toast.dart';
import '../base_api.dart';
import '../base_service.dart';

class AuthService extends BaseService {
  Future<void> signIn(BuildContext context, dynamic formData) async {
    appLogger('The url...${BaseApi.signInUrl}');
    final response = await apiService.post(
      url: BaseApi.signInUrl,
      data: {'username': formData['Email'], 'password': formData['Password']},
      fromJson: (json) => UserModel.fromJson(json),
    );

    response.when(
      onSuccess: (responseData, message) async {
        final token = responseData?.token;
        await TokenManager().saveToken(token!);
        await LocalStorageManager.saveData(
          'userData',
          jsonEncode(responseData),
        );

        if (!context.mounted) return;

        context.pushNamedAndRemoveAll(AppRoutes.dashboard);

      },
      onError: (message, errors, statusCode) {
        if (!context.mounted) return;
        AppToast.show(context, message!);
      },
    );
  }

  Future<void> signUp(BuildContext context, dynamic formData) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  void signOut(BuildContext context, screen) {}
}
