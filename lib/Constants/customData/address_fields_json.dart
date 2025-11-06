import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../Controller/locale/localization_service_controller.dart';

List<Map<String, dynamic>> addressFieldJson(dynamic widget, showState, context) {
  return [
    {
      'name': "firstName",
      'title': tr.firstName,
      'placeHolder': tr.firstName,
      'showSuffixIcon': false,
      'isRequired': true,
      'initialValue': widget.address?.firstName,
      'isShowing': true
    },
    {
      'name': "lastName",
      'title': tr.lastName,
      'placeHolder': tr.lastName,
      'showSuffixIcon': false,
      'isRequired': true,
      'initialValue': widget.address?.lastName,
      'isShowing': true
    },
    {
      'name': "country",
      'title': tr.country,
      'placeHolder': tr.country,
      'suffixIcon': FeatherIcons.eyeOff,
      'showSuffixIcon': true,
      'isRequired': true,
      'initialValue': widget.address?.country,
      'isShowing': true
    },
    {
      'name': "address1",
      'title': tr.address,
      'placeHolder': tr.address,
      'suffixIcon': FeatherIcons.mail,
      'showSuffixIcon': false,
      'isRequired': true,
      'initialValue': widget.address?.address1,
      'isShowing': true
    },
    {
      'name': "address2",
      'title': tr.apartmentOptional,
      'placeHolder': tr.apartmentOptionalValue,
      'showSuffixIcon': false,
      'isRequired': false,
      'initialValue': widget.address?.address2,
      'isShowing': true
    },
    {
      'name': "state",
      'title': tr.state,
      'placeHolder': tr.state,
      'showSuffixIcon': false,
      'isRequired': true,
      'initialValue': widget.address?.state,
      'isShowing': showState,
    },
    {
      'name': "city",
      'title': tr.city,
      'placeHolder': tr.city,
      'showSuffixIcon': false,
      'isRequired': true,
      'initialValue': widget.address?.city,
      'isShowing': true
    },
    {
      'name': "postCode",
      'title': tr.zipCode,
      'placeHolder': tr.zipCode,
      'showSuffixIcon': false,
      'isRequired': true,
      'initialValue': widget.address?.postCode,
      'isShowing': true
    },
    {
      'name': "phone",
      'title': tr.phoneOptional,
      'placeHolder': 'xxx xxx xxxx',
      'showSuffixIcon': false,
      'isRequired': false,
      'initialValue': widget.address?.phone,
      'isShowing': true
    },
  ];
}
