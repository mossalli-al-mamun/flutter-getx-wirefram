import 'package:flutter/material.dart';

import '../../Navigation/bottomTab/bottom_tabs.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return const BottomTabs();
  }
}

