import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

import 'app_logger.dart';

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  phoneNumber.isNotEmpty ? await launchUrl(launchUri): null;
}

Future<void> sendMailTo(String emailAddress) async {
  final Uri launchUri = Uri(
    scheme: 'mailto',
    path: emailAddress,
  );
  emailAddress.isNotEmpty ?await launchUrl(launchUri): null;
}

Future openMaps( dynamic latitude, longitude) async {
  appLogger('The map lat long : $latitude, $longitude');
  final url = Platform.isAndroid
      ? 'https://maps.google.com/?q=$latitude,$longitude'
      : 'https://maps.apple.com/?q=$latitude,$longitude';

  final uri = Uri.parse(url);

  if (latitude != null || longitude != null ) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}