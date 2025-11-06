// re-usable scaffold
import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Config/themes/sizes.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final EdgeInsetsGeometry? padding;
  final bool useSafeArea;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final String? restorationId;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? persistentFooterButtons;
  final bool scrollable;

  const AppScaffold({
    super.key,
    required this.body,
    this.padding,
    this.useSafeArea = true,
    this.physics,
    this.controller,
    this.appBar,
    this.drawer,
    this.endDrawer,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.restorationId,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.persistentFooterButtons,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: appBar,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      restorationId: restorationId,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      persistentFooterButtons: persistentFooterButtons != null
          ? [persistentFooterButtons!]
          : null,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    Widget content = body;

    content = Padding(padding: padding ?? AppSizes.pagePadding, child: content);

    // Wrap in SingleChildScrollView for scrollable content
    if (scrollable) {
      content = SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        child: content,
      );
    }

    // Wrap in SafeArea if needed
    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return content;
  }
}
