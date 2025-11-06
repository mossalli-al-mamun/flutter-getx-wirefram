import 'package:flutter/material.dart';

/// Centralized app-wide border radius definitions for consistency.
class AppSizes {
  AppSizes._(); // private constructor

  static const extraSmall = 2.0;
  static const small = 4.0;
  static const medium = 8.0;
  static const largeMedium = 10.0;
  static const large = 12.0;
  static const extraLarge1 = 13.0;
  static const extraLarge2 = 14.0;
  static const extraLarge = 20.0;
  static const extraExtraLarge = 30.0;
  static const extraExtraExtraLarge = 45.0;


  // For convenience: border radius types
  static const BorderRadius smallAll = BorderRadius.all(Radius.circular(small));
  static const BorderRadius mediumAll = BorderRadius.all(Radius.circular(medium));
  static const BorderRadius largeMediumAll = BorderRadius.all(Radius.circular(largeMedium));
  static const BorderRadius largeAll = BorderRadius.all(Radius.circular(large));
  static const BorderRadius extralargeAll = BorderRadius.all(Radius.circular(extraLarge));
  static const BorderRadius extraExtraLargeAll = BorderRadius.all(Radius.circular(extraExtraLarge));
  static const BorderRadius extraExtraExtraLargeAll = BorderRadius.all(Radius.circular(extraExtraExtraLarge));
}
