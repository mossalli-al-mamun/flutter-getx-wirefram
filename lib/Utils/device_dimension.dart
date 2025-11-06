import 'package:flutter/material.dart';

Size deviceDimension(BuildContext context) {
  MediaQueryData queryData;
  queryData = MediaQuery.of(context);
  var size = queryData.size;
  return size;
}
