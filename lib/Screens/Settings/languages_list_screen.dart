import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controller/locale/locale_controller.dart';
import '../../Controller/locale/localization_service_controller.dart';
import '../../Widgets/headers/navigation_header.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../Config/themes/sizes.dart';
import '../../Utils/flag_utils.dart';

class LanguagesListScreen extends StatelessWidget {
  const LanguagesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LocaleController localeController = Get.find();
    final locales = AppLocalizations.supportedLocales;

    return Scaffold(
      appBar: NavigationHeader(title: tr.selectLanguage, centerTitle: true),
      body: ListView.separated(
        itemCount: locales.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final loc = locales[index];
          final isSelected =
              loc.languageCode == localeController.locale.value.languageCode;
          String langName;
          switch (loc.languageCode) {
            case 'ar':
              langName = tr.arabic;
              break;
            case 'es':
              langName = tr.spanish;
              break;
            case 'en':
            default:
              langName = tr.english;
          }
          final cs = Theme.of(context).colorScheme;
          final flag = FlagUtils.flagForLanguage(code: loc.languageCode);
          return ListTile(
            leading: Text(
              flag,
              style: const TextStyle(fontSize: 24),
            ),
            title: Text(langName),
            trailing: isSelected
                ? Icon(Icons.check_circle, color: cs.primary)
                : null,
            onTap: () async {
              await localeController.changeLocale(loc.languageCode);
              if (context.mounted) Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }
}
