import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/context_ext.dart';
import 'package:get/get.dart';
import '../../../Controller/locale/localization_service_controller.dart';
import '../../../Services/apiController/auth_api_controller.dart';
import '../../../Widgets/alerts/app_alert.dart';
import '../../../Widgets/buttons/primary_button.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: PrimaryButton(
        elevation: 0,
        height: 58,
        label: tr.logout,
        icon: Icons.logout_rounded,
        iconPosition: IconPosition.start,
        color: context.dangerColor,
        iconWithText: true,
        onPressed: () async {
          final confirmed = await AppAlert.showConfirm(
            context,
            title: tr.logout,
            message: tr.logoutConfirmation,
            confirmText: tr.logout,
            cancelText: tr.cancel,
            danger: true,
          );
          if (confirmed == true) {
            final auth = Get.find<AuthApiController>();
            await auth.signOut(context, null);
          }
        },
      ),
    );
  }
}
