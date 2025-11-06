import 'package:flutter/material.dart';

BoxShadow customShadow(BuildContext context, {double elevation = 0}) {
  return BoxShadow(
    color: Colors.black.withValues(alpha: 0.3),
    blurRadius: elevation > 0 ? elevation * 2 : 8,
    offset: Offset(0, elevation > 0 ? elevation / 2 : 2),
    spreadRadius: 0,
  );
}
