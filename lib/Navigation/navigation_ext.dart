import 'package:flutter/material.dart';

extension NavigationExt on BuildContext {
  // Basic Navigation
  Future<T?> push<T extends Object?>(Widget page) =>
      Navigator.of(this).push<T>(MaterialPageRoute(builder: (_) => page));

  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(Widget page, {TO? result}) =>
      Navigator.of(this).pushReplacement<T, TO>(
        MaterialPageRoute(builder: (_) => page),
        result: result,
      );

  Future<T?> pushAndRemoveAll<T extends Object?>(Widget page) =>
      Navigator.of(this).pushAndRemoveUntil<T>(
        MaterialPageRoute(builder: (_) => page),
            (_) => false,
      );

  Future<T?> pushAndRemoveUntil<T extends Object?>(Widget page, bool Function(Route<dynamic>) predicate) =>
      Navigator.of(this).pushAndRemoveUntil<T>(
        MaterialPageRoute(builder: (_) => page),
        predicate,
      );

  Future<T?> pushAndRemoveUntilRoute<T extends Object?>(Widget page, String routeName) =>
      Navigator.of(this).pushAndRemoveUntil<T>(
        MaterialPageRoute(builder: (_) => page),
            (route) => route.settings.name == routeName,
      );

  // Named Route Navigation
  Future<T?> pushNamed<T extends Object?>(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
      String routeName, {
        TO? result,
        Object? arguments,
      }) =>
      Navigator.of(this).pushReplacementNamed<T, TO>(
        routeName,
        arguments: arguments,
        result: result,
      );

  Future<T?> pushNamedAndRemoveAll<T extends Object?>(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushNamedAndRemoveUntil<T>(
        routeName,
            (_) => false,
        arguments: arguments,
      );

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
      String routeName,
      bool Function(Route<dynamic>) predicate, {
        Object? arguments,
      }) =>
      Navigator.of(this).pushNamedAndRemoveUntil<T>(
        routeName,
        predicate,
        arguments: arguments,
      );

  Future<T?> pushNamedAndRemoveUntilRoute<T extends Object?>(
      String routeName,
      String untilRouteName, {
        Object? arguments,
      }) =>
      Navigator.of(this).pushNamedAndRemoveUntil<T>(
        routeName,
            (route) => route.settings.name == untilRouteName,
        arguments: arguments,
      );

  // Pop Methods
  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop<T>(result);

  void popUntil(bool Function(Route<dynamic>) predicate) => Navigator.of(this).popUntil(predicate);

  void popUntilRoute(String routeName) =>
      Navigator.of(this).popUntil((route) => route.settings.name == routeName);

  Future<bool> maybePop<T extends Object?>([T? result]) =>
      Navigator.of(this).maybePop<T>(result);

  bool get canPop => Navigator.of(this).canPop();

  // Custom Transitions
  Future<T?> pushFade<T extends Object?>(
      Widget page, {
        Duration duration = const Duration(milliseconds: 300),
        Curve curve = Curves.easeInOut,
      }) =>
      Navigator.of(this).push<T>(
        PageRouteBuilder<T>(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: duration,
        ),
      );

  Future<T?> pushSlide<T extends Object?>(
      Widget page, {
        Duration duration = const Duration(milliseconds: 300),
        Curve curve = Curves.easeInOut,
        Offset begin = const Offset(1.0, 0.0),
        Offset end = Offset.zero,
      }) =>
      Navigator.of(this).push<T>(
        PageRouteBuilder<T>(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
            return SlideTransition(
              position: Tween<Offset>(begin: begin, end: end).animate(curvedAnimation),
              child: child,
            );
          },
          transitionDuration: duration,
        ),
      );

  Future<T?> pushScale<T extends Object?>(
      Widget page, {
        Duration duration = const Duration(milliseconds: 300),
        Curve curve = Curves.easeInOut,
        double begin = 0.0,
        double end = 1.0,
      }) =>
      Navigator.of(this).push<T>(
        PageRouteBuilder<T>(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
            return ScaleTransition(
              scale: Tween<double>(begin: begin, end: end).animate(curvedAnimation),
              child: child,
            );
          },
          transitionDuration: duration,
        ),
      );

  Future<T?> pushRotation<T extends Object?>(
      Widget page, {
        Duration duration = const Duration(milliseconds: 500),
        Curve curve = Curves.easeInOut,
        double begin = 0.0,
        double end = 1.0,
      }) =>
      Navigator.of(this).push<T>(
        PageRouteBuilder<T>(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
            return RotationTransition(
              turns: Tween<double>(begin: begin, end: end).animate(curvedAnimation),
              child: child,
            );
          },
          transitionDuration: duration,
        ),
      );

  // Dialog Methods - Using Flutter's built-in showDialog
  Future<T?> showCustomDialog<T extends Object?>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) =>
      showDialog<T>(
        context: this,
        builder: builder,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        useSafeArea: useSafeArea,
        useRootNavigator: useRootNavigator,
        routeSettings: routeSettings,
      );

  Future<T?> showAlertDialog<T extends Object?>({
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) =>
      showDialog<T>(
        context: this,
        barrierDismissible: barrierDismissible,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            if (cancelText != null)
              TextButton(
                onPressed: () {
                  onCancel?.call();
                  context.pop();
                },
                child: Text(cancelText),
              ),
            TextButton(
              onPressed: () {
                onConfirm?.call();
                context.pop();
              },
              child: Text(confirmText ?? 'OK'),
            ),
          ],
        ),
      );

  // Bottom Sheet - Using Flutter's built-in showModalBottomSheet
  Future<T?> showBottomSheet<T extends Object?>(
      WidgetBuilder builder, {
        Color? backgroundColor,
        double? elevation,
        ShapeBorder? shape,
        Clip? clipBehavior,
        BoxConstraints? constraints,
        Color? barrierColor,
        bool isScrollControlled = false,
        bool useRootNavigator = false,
        bool isDismissible = true,
        bool enableDrag = true,
        RouteSettings? routeSettings,
      }) =>
      showModalBottomSheet<T>(
        context: this,
        builder: builder,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
        constraints: constraints,
        barrierColor: barrierColor,
        isScrollControlled: isScrollControlled,
        useRootNavigator: useRootNavigator,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        routeSettings: routeSettings,
      );

  // Utility Methods
  RouteSettings? get routeSettings => ModalRoute.of(this)?.settings;

  Object? get routeArguments => ModalRoute.of(this)?.settings.arguments;

  String? get routeName => ModalRoute.of(this)?.settings.name;

  // Fullscreen Dialog
  Future<T?> pushFullscreenDialog<T extends Object?>(Widget page) =>
      Navigator.of(this).push<T>(
        MaterialPageRoute<T>(
          builder: (_) => page,
          fullscreenDialog: true,
        ),
      );

  // For Result (explicitly named for clarity)
  Future<T?> pushForResult<T extends Object?>(Widget page) => push<T>(page);

  Future<T?> pushNamedForResult<T extends Object?>(String routeName, {Object? arguments}) =>
      pushNamed<T>(routeName, arguments: arguments);

  // Cupertino-style transitions
  Future<T?> pushCupertino<T extends Object?>(Widget page) =>
      Navigator.of(this).push<T>(
        PageRouteBuilder<T>(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );

  // No transition (instant)
  Future<T?> pushNoTransition<T extends Object?>(Widget page) =>
      Navigator.of(this).push<T>(
        PageRouteBuilder<T>(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
}