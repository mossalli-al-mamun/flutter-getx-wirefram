Object? dynamicValueAdapter(Map<dynamic, dynamic>? json, String primaryKey,
    List<String> alternateKeys) {
  if (json == null) return null;

  if (json.containsKey(primaryKey)) {
    return json[primaryKey];
  }

  for (final altKey in alternateKeys) {
    if (json.containsKey(altKey)) {
      return json[altKey];
    }
  }
  return null;
}