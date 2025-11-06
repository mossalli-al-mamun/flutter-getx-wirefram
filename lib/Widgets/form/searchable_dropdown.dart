import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';

import '../../Config/themes/appStyles/form_style.dart';
import '../../Config/themes/text_styles.dart';
import '../../Config/themes/app_colors.dart';
import '../../Controller/locale/localization_service_controller.dart';
import '../../Utils/label_translator.dart';

class SearchableDropdown extends StatefulWidget {
  final List<dynamic>? items;
  final String? placeholder;
  final Function(dynamic)? onChanged;
  final dynamic initialValue;
  final bool showSearchBox;
  final Future<List<dynamic>> Function(String, int)? onFind;
  final Future<dynamic> Function()? onBeforePopupOpening;
  final bool enabled;
  final bool allowCustomValueWhenEmpty;
  // localization support
  final bool translateLabels;
  final String Function(String)? translate;

  const SearchableDropdown(
      {super.key,
      this.items,
      this.placeholder,
      this.onChanged,
      this.initialValue,
      this.showSearchBox = true,
      this.onFind,
      this.onBeforePopupOpening,
      this.enabled = true,
      this.allowCustomValueWhenEmpty = false,
      this.translateLabels = true,
      this.translate});

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  dynamic selectedItem;
  int _currentPage = 1;
  String _currentFilter = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedItem = widget.initialValue;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SearchableDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        selectedItem = widget.initialValue;
      });
    }
  }

  String _getItemLabel(dynamic item) {
    if (item == null) return widget.placeholder ?? '';
    String label;
    if (item is String) {
      label = item;
    } else {
      label = item['name'] ?? item['country'] ?? '';
    }
    return LabelTranslator.maybeTranslate(label);
  }

  bool _isSameItem(dynamic a, dynamic b) {
    if (a == null || b == null) return false;

    // If both are strings
    if (a is String && b is String) {
      return a == b;
    }

    // If a is String and b is Map
    if (a is String && b is Map) {
      return a == (b['id']?.toString() ?? '') ||
          a == (b['name']?.toString() ?? '') ||
          a == (b['code']?.toString() ?? '') ||
          a == (b['country']?.toString() ?? '');
    }

    // If a is Map and b is String
    if (a is Map && b is String) {
      return (a['id']?.toString() ?? '') == b ||
          (a['name']?.toString() ?? '') == b ||
          (a['code']?.toString() ?? '') == b ||
          (a['country']?.toString() ?? '') == b;
    }

    // If both are maps
    if (a is Map && b is Map) {
      return a['id'] == b['id'];
    }

    // Fallback
    return a == b;
  }

  Future<List<dynamic>> _loadData(
      String? filter, dynamic infiniteScrollProps) async {
    if (widget.onFind == null) return widget.items ?? [];

    try {
      final page = infiniteScrollProps?.page ?? 1; // <--- use current page
      _currentPage = page;
      _currentFilter = filter ?? '';

      final results = await widget.onFind!(_currentFilter, _currentPage);

      // Remove duplicates using Set if needed
      // final unique = {
      //   for (var e in results) e[widget.valueProperty]: e
      // }.values.toList();

      return results;
    } catch (e) {
      debugPrint('Error loading dropdown data: $e');
      return [];
    }
  }

  Future<bool> _handleBeforePopupOpening(dynamic selectedValue) async {
    // unfocused any focused text fields
    FocusManager.instance.primaryFocus?.unfocus();
    return true; // Always allow opening
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<dynamic>(
      /// here infiniteScrollProps not working properly
      items: (filter, infiniteScrollProps) =>
          _loadData(filter, infiniteScrollProps),
      selectedItem: selectedItem,
      onBeforePopupOpening: (selectedValue) =>
          _handleBeforePopupOpening(selectedValue),
      enabled: widget.enabled,
      dropdownBuilder: (context, item) {
        final label = _getItemLabel(item);
        return Text(
          label,
          style: AppTextStyle.labelMedium,
        );
      },
      decoratorProps: DropDownDecoratorProps(
        decoration: appFormStyle(
          context: context,
        ),
      ),
      suffixProps: DropdownSuffixProps(
        dropdownButtonProps: DropdownButtonProps(
          iconOpened: const Icon(FeatherIcons.chevronUp),
          iconClosed: const Icon(FeatherIcons.chevronDown),
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: widget.showSearchBox,
        searchDelay: Duration.zero,
        fit: FlexFit.loose,
        searchFieldProps: TextFieldProps(
          controller: _searchController,
          cursorColor: context.primary,
          decoration: appSearchFieldStyle(
            context: context,
            hintText: tr.searchHere,
            prefixIcon: Icon(
              FeatherIcons.search,
            ),
          ),
        ),
        itemBuilder: (context, item, isDisabled, isSelectedProperty) {
          final label = _getItemLabel(item);
          final isSelected = _isSameItem(item, selectedItem);
          return Container(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: AppTextStyle.labelMedium,
                  ),
                ),
                if (isSelected)
                  Icon(FeatherIcons.checkCircle, color: Colors.green),
              ],
            ),
          );
        },
        emptyBuilder: (context, searchEntry) {
          final query = _searchController.text.trim();
          final List<Widget> children = [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                tr.emptyData('Value'),
                style: AppTextStyle.bodyMedium,
              ),
            ),
          ];

          if (widget.allowCustomValueWhenEmpty && query.isNotEmpty) {
            children.add(
              ListTile(
                title: Text('${tr.add} "$query"'),
                leading: const Icon(FeatherIcons.plusCircle),
                onTap: () {
                  setState(() {
                    selectedItem = query;
                  });
                  if (widget.onChanged != null) widget.onChanged!(query);
                  Navigator.of(context).pop();
                },
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: children,
          );
        },
      ),
      compareFn: (item1, item2) => _isSameItem(item1, item2),
      onChanged: (value) {
        setState(() {
          selectedItem = value;
        });
        widget.onChanged!(value);
      },
    );
  }
}
