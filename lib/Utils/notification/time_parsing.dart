import '../app_logger.dart';

DateTime? combineWithToday(String? hhmmss) {
  if (hhmmss == null || hhmmss.isEmpty) {
    appLogger('combineWithToday: input is null or empty');
    return null;
  }
  try {
    final now = DateTime.now();
    final parts = hhmmss.split(':');
    if (parts.isEmpty) return null;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
    final s = parts.length > 2 ? (int.tryParse(parts[2]) ?? 0) : 0;
    return DateTime(now.year, now.month, now.day, h, m, s);
  } catch (e) {
    appLogger('combineWithToday: error parsing - $e');
    return null;
  }
}

DateTime? parseFlexibleDateTime(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  try {
    final cleaned = value.replaceAll(' AM', '').replaceAll(' PM', '');
    final dt = DateTime.tryParse(cleaned);
    if (dt != null) return dt;
  } catch (_) {}
  try {
    return DateTime.parse(value);
  } catch (_) {}
  try {
    final parts = value.split(' ');
    if (parts.length >= 3) {
      final date = parts[0];
      final time = parts[1];
      final ampm = parts[2].toUpperCase();
      final t = time.split(':');
      var h = int.tryParse(t[0]) ?? 0;
      final m = int.tryParse(t[1]) ?? 0;
      if (ampm == 'PM' && h < 12) h += 12;
      if (ampm == 'AM' && h == 12) h = 0;
      final hs = h.toString().padLeft(2, '0');
      final ms = m.toString().padLeft(2, '0');
      return DateTime.parse('$date $hs:$ms:00');
    }
  } catch (_) {}
  return null;
}
