extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

///uses process of StringExtension
//                 'Demo string'.toString()
//                 .replaceAll(RegExp(r"(?=[A-Z])"), ' ')
//                 .capitalize(),

String capitalizeFirstLetters(String input, {onlyOne = true}) {
  if (input.isEmpty) {
    return input;
  }
  input = input.replaceAll('_', ' ');
  if (onlyOne) {
    return input[0].toUpperCase() + input.substring(1);
  } else {
    return input.replaceAllMapped(
      RegExp(r'\b\w'),
      (match) => match.group(0) != null ? match.group(0)!.toUpperCase() : '',
    );
  }
}

String getFormattedAddress(
  dynamic address, {
  List<String> excludeKeys = const [], // 👈 Pass dynamic exclusions here
}) {
  if (address == null) return '';

  T? _safe<T>(T Function() getter) {
    try {
      return getter();
    } catch (_) {
      return null;
    }
  }

  dynamic _fromMap(dynamic map, String key) {
    if (map is Map) {
      if (map.containsKey(key)) return map[key];
      // try common alternatives
      final alt = {
        'firstName': ['first_name', 'firstname', 'first'],
        'lastName': ['last_name', 'lastname', 'last'],
        'address1': ['address_1', 'addressLine1', 'line1', 'street1'],
        'address2': ['address_2', 'addressLine2', 'line2', 'street2'],
        'postCode': ['postcode', 'zipCode', 'zip', 'postalCode'],
        'city': ['town', 'locality'],
        'state': ['province', 'region', 'stateCode'],
        'country': ['countryCode'],
        'phone': ['phoneNumber', 'tel'],
        'email': ['mail', 'emailAddress'],
      }[key];
      if (alt != null) {
        for (final k in alt) {
          if (map.containsKey(k)) return map[k];
        }
      }
    }
    return null;
  }

  // Collect values safely from either Map or object with properties.
  final Map<String, dynamic> addressValue = {
    'firstName': address is Map
        ? _fromMap(address, 'firstName')
        : _safe(() => address.firstName),
    'lastName': address is Map
        ? _fromMap(address, 'lastName')
        : _safe(() => address.lastName),
    'address1': address is Map
        ? _fromMap(address, 'address1')
        : _safe(() => address.address1) ?? _safe(() => address.addressLine1),
    'address2': address is Map
        ? _fromMap(address, 'address2')
        : _safe(() => address.address2) ?? _safe(() => address.addressLine2),
    'state': address is Map
        ? _fromMap(address, 'state')
        : _safe(() => address.state),
    'city': address is Map
        ? _fromMap(address, 'city')
        : _safe(() => address.city),
    'postCode': address is Map
        ? _fromMap(address, 'postCode')
        : _safe(() => address.postCode) ?? _safe(() => address.postcode) ?? _safe(() => address.zipCode) ?? _safe(() => address.zip),
    'country': address is Map
        ? _fromMap(address, 'country')
        : _safe(() => address.country),
    'phone': address is Map
        ? _fromMap(address, 'phone')
        : _safe(() => address.phone),
    'email': address is Map
        ? _fromMap(address, 'email')
        : _safe(() => address.email),
  };

  // Build components list dynamically, respecting exclusions
  final List<String> components = [];

  addressValue.forEach((key, value) {
    if (!excludeKeys.contains(key) &&
        value != null &&
        value.toString().trim().isNotEmpty) {
      components.add(value.toString().trim());
    }
  });

  // Join with comma + space
  String result = components.join(', ');

  // Replace comma before postCode with a hyphen (only if postCode exists)
  final postCode = addressValue['postCode'];
  if (postCode != null && postCode.toString().isNotEmpty) {
    // Handles both ", 1234" and ",1234"
    result = result.replaceFirst(
      RegExp(r',\s?' + RegExp.escape(postCode.toString())),
      '-$postCode',
    );
  }

  return result;
}

String removeHtmlTags(String? htmlString) {
  if (htmlString == null) return '';
  return htmlString.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').trim();
}
