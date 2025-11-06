import 'package:flutter/material.dart';

import '../Controller/locale/localization_service_controller.dart';
import '../Screens/Auth/forgot_password.dart';
import '../Screens/Auth/signin.dart';
import '../Screens/Auth/signup.dart';
import 'bottomTab/bottom_tabs.dart';

class AppRoutes {
  static const String signIn = '/signIn';
  static const String signUp = '/signUp';
  static const String forgotPassword = '/forgotPassword';
  static const String dashboard = '/dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args =
        settings.arguments as Map<String, dynamic>?; // Extract arguments

    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(builder: (_) => SignIn());
      case signUp:
        return MaterialPageRoute(builder: (_) => SignUp());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => ForgotPassword());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const BottomTabs());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text(tr.noRouteFound))),
        );
    }
  }
}
