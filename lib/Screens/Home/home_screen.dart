import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Widgets/custom_shadow.dart';
import 'package:flutter_getx_wireframe/Widgets/headers/navigation_header.dart';
import '../../Widgets/app_scaffold.dart';
import '../../Widgets/custom_shape_icon.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: const EdgeInsets.all(16),
      body:Center(
        child: Text('dashboard'),
      ),
    );
  }
}
