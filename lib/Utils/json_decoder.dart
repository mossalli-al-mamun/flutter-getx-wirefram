import 'dart:convert';

jsonDecoder(dynamic response) {
  return jsonDecode(response.toString());
}