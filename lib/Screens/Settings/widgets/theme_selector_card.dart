import 'package:flutter/material.dart';
import '../../../Widgets/app_card.dart';

class ThemeSelectorCard extends StatelessWidget {
  const ThemeSelectorCard({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      icon: icon,
      label: label,
      isSelected: isSelected,
      showSelectionState: true,
      onTap: onTap,
      enableShadow: false, // No shadow for theme selector
    );
  }
}