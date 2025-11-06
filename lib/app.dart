import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/dark_theme.dart';
import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';
import 'Config/themes/text_styles.dart';
import 'Config/themes/light_theme.dart';
import 'Config/themes/theme_controller.dart';
import 'Navigation/routes.dart';
import 'Screens/Auth/signin.dart';
import 'Screens/DashBoard/index.dart';
import 'Utils/local_storage_manager.dart';
import 'Utils/pop_scope_wrapper.dart';
import 'Utils/token_manager.dart';
import 'Widgets/app_loaders.dart';
import 'l10n/generated/app_localizations.dart';
import 'Utils/global_variables.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();

  /// InheritedWidget style accessor to our State object.
  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;
}

class MyAppState extends State<MyApp> {
  final ThemeController _themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    AppTextStyle.init(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Getx Wireframe',
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: GlobalVariables.rootScaffoldMessengerKey,
      locale: Get.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: _themeController.themeMode.value,
      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,
      onGenerateRoute: AppRoutes.generateRoute,
      builder: (context, child) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            final currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
              currentFocus.unfocus();
            }
          },
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: _buildHome(),
    );
  }

  Widget _buildHome() {
    return FutureBuilder<String?>(
      future: TokenManager().readToken(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Scaffold(body: Center(child: AppLoader()));
          case ConnectionState.waiting:
            return const Scaffold(body: Center(child: AppLoader()));
          case ConnectionState.active:
            return const Scaffold(body: Center(child: AppLoader()));
          case ConnectionState.done:
            final token = snapshot.data;
            final userdata = LocalStorageManager.readData('userData');

            // Check token and decide which screen to show
            final homeScreen = PopScopeWrapper(
              child: token == null || token.isEmpty || userdata == null
                  ? SignIn() // Navigate to sign-in screen
                  : const Dashboard(), // Navigate to dashboard if token exists
            );

            // home screen with upgrader
            return UpgradeAlert(
              showIgnore: false,
              showLater: false,
              showReleaseNotes: false,
              upgrader: Upgrader(
                debugLogging: true,
                debugDisplayAlways: false,
                languageCode: Get.locale?.languageCode,
                durationUntilAlertAgain: const Duration(days: 0),
              ),
              child: homeScreen,
            );
        }
      },
    );
  }
}
