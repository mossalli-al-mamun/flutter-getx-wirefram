import 'dart:developer';
import 'package:flutter/foundation.dart';

void appLogger(String message) {
  if (kDebugMode) {
    log(message);
  }
}