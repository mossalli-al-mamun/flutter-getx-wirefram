import 'package:flutter/material.dart';

import 'back_button.dart';
import 'navigation_header.dart';

class SliverHeader extends StatelessWidget {
  final Color? backgroundColor;
  final String title;

  const SliverHeader({super.key, this.backgroundColor, required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      centerTitle: false,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      leading: AppBackButton(),
      title: CustomHeader(
        title: title,
      ),
      titleSpacing: 0,
    );
  }
}
