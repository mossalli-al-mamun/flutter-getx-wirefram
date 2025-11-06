import 'package:flutter/material.dart';

import '../../Controller/locale/localization_service_controller.dart';
import '../../Widgets/app_scaffold.dart';
import '../../Screens/Home/home_screen.dart';
import '../../Screens/Profile/profile_screen.dart';
import '../../Screens/Settings/index.dart';

class BottomTabs extends StatefulWidget {
  const BottomTabs({super.key});

  @override
  State<BottomTabs> createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _currentIndex = 0;

  final List<Widget> _pages =  [
    HomeScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scrollable: false,
      useSafeArea: true,
      padding: EdgeInsets.zero,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: tr.dashboard),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: tr.profile),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: tr.settings),
        ],
      ),
    );
  }
}
