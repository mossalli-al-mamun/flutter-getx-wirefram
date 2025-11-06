import 'package:flutter/material.dart';

bool isRTL(BuildContext context) {
  return Directionality.of(context) == TextDirection.rtl;
}