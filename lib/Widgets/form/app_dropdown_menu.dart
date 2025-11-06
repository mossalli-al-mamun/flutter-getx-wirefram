import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';

import '../../Config/themes/text_styles.dart';
import '../../Utils/string_modifier.dart';

class AppDropdownMenu extends StatelessWidget {
  final String? label;
  final String? hintText;
  final Color? color;
  final Color? textColor;
  final double? height;
  final double? width;
  final bool? isDisable;
  final List<String> itemList;
  final String? initialSelectionValue;
  final Function onSelected;

  const AppDropdownMenu({
    super.key,
    this.label,
    this.color = const Color(0xFFF9F9F9),
    this.textColor,
    this.height = 65.0,
    this.width,
    this.isDisable = false,
    required this.onSelected,
    required this.itemList,
    this.initialSelectionValue,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      hintText: hintText,
      enabled: itemList.isNotEmpty,
      textStyle: AppTextStyle.bodyMedium,
      selectedTrailingIcon: Icon(
        FeatherIcons.chevronUp,
        size: 22,
      ),
      trailingIcon: Icon(
        FeatherIcons.chevronDown,
        size: 22,
      ),
      initialSelection: initialSelectionValue!,
      width: width,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
        filled: true,
        hintStyle: AppTextStyle.bodyMedium,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.primary,
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.disabledColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5))),

        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.primary,
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
      onSelected: (String? value) {
        onSelected(value);
      },
      dropdownMenuEntries:
          itemList.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry(
            value: value, label: capitalizeFirstLetters(value));
      }).toList(),
    );
  }
}
