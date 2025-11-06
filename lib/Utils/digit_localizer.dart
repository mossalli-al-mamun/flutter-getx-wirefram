import 'package:intl/intl.dart';

String localizeDigits(String input, {String? locale, bool group = true}) {
  final baseLocale = locale ?? Intl.getCurrentLocale();

  final formatter = NumberFormat.decimalPattern(baseLocale);

  // Use custom formatter: group for numbers like 1,234; disable for IDs
  if (!group) formatter.turnOffGrouping();

  return input.replaceAllMapped(RegExp(r'\d+'), (match) {
    final number = int.tryParse(match.group(0)!);
    return number != null ? formatter.format(number) : match.group(0)!;
  });
}
