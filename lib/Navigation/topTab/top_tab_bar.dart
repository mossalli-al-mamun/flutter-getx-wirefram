import 'package:flutter/material.dart';
import '../../Config/themes/app_colors.dart';

class TopTab extends StatefulWidget {
  final List<Widget> tabs;
  final double? tabBarBottomSpace;
  final TabController? controller;

  const TopTab(
      {super.key,
      required this.tabs,
      this.tabBarBottomSpace = 30.0,
      this.controller});

  @override
  TopTabState createState() => TopTabState();
}

class TopTabState extends State<TopTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: widget.controller,
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          indicator: BoxDecoration(
              color: AppColors.blackColor,
              borderRadius: BorderRadius.circular(40)),
          labelColor: AppColors.whiteColor,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: widget.tabs,
          labelPadding: EdgeInsets.zero,
          padding: EdgeInsets.symmetric(horizontal: 20),
          dividerColor: Colors.transparent,
        ),
        SizedBox(
          height: widget.tabBarBottomSpace,
        )
      ],
    );
  }
}
