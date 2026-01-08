// ==========================
// Unified Searchable Dropdown Field
// ==========================

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/context_ext.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';

import 'unified_input_field.dart';

/// Unified Searchable Dropdown that matches UnifiedInputField structure
class UnifiedDropdownField extends StatefulWidget {
  // Core properties
  final String name;
  final String? label;
  final String? hintText;
  final dynamic initialValue;

  // Field behavior
  final bool isRequired;
  final bool isEnabled;

  // Styling
  final InputFieldStyle style;
  final IconData? prefixIcon;
  final double spacing;

  // Dropdown data
  final List<DropdownOption>? options;
  final Future<List<DropdownOption>> Function(String filter, int page)? onFind;
  final String? initialLabel;

  // Callbacks
  final String? Function(dynamic)? validator;
  final Function(dynamic)? onChanged;

  // Behavior
  final bool showSearchBox;
  final bool allowCustomValue;
  final String? searchHint;
  final String? emptyMessage;

  // Advanced
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final double? width;

  final bool passFullObject;

  const UnifiedDropdownField({
    super.key,
    required this.name,
    this.label,
    this.hintText,
    this.initialValue,
    this.initialLabel,
    this.isRequired = false,
    this.isEnabled = true,
    this.style = InputFieldStyle.floating,
    this.prefixIcon,
    this.spacing = 16.0,
    this.options,
    this.onFind,
    this.validator,
    this.onChanged,
    this.showSearchBox = true,
    this.allowCustomValue = false,
    this.searchHint = 'Search here...',
    this.emptyMessage = 'No items found',
    this.contentPadding,
    this.hintStyle,
    this.textStyle,
    this.width,
    this.passFullObject = true,
  });

  @override
  State<UnifiedDropdownField> createState() => _UnifiedDropdownFieldState();
}

class _UnifiedDropdownFieldState extends State<UnifiedDropdownField> {
  int _currentPage = 1;
  String _currentFilter = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode(debugLabel: 'UnifiedDropdownField');

  // Keep track of the currently selected item internally
  DropdownOption? _selectedOption;

  @override
  void initState() {
    super.initState();
    _initializeSelectedOption();
  }

  @override
  void didUpdateWidget(covariant UnifiedDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-initialize if initialValue changes
    if (oldWidget.initialValue != widget.initialValue) {
      _initializeSelectedOption();
    }
  }

  void _initializeSelectedOption() {
    if (widget.initialValue == null) {
      _selectedOption = null;
      return;
    }

    // If initialValue is already a DropdownOption, use it
    if (widget.initialValue is DropdownOption) {
      _selectedOption = widget.initialValue as DropdownOption;
      return;
    }

    // Try to find matching option from the options list
    final options = widget.options ?? [];
    try {
      _selectedOption = options.firstWhere(
        (opt) => opt.value == widget.initialValue,
      );
      return;
    } catch (_) {
      // If not found and we have initialLabel, create synthetic option
      if (widget.initialLabel != null && widget.initialLabel!.isNotEmpty) {
        _selectedOption = DropdownOption(
          value: widget.initialValue,
          label: widget.initialLabel!,
        );
      } else {
        _selectedOption = null;
      }
    }
  }

  dynamic _formValueFor(DropdownOption? option) {
    if (option == null) return null;
    return widget.passFullObject ? option : option.value;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  dynamic _getItemValue(dynamic item) {
    if (item == null) return null;
    if (item is DropdownOption) return item.value;
    if (item is Map) return item['value'] ?? item['id'];
    return item;
  }

  bool _isSameItem(dynamic a, dynamic b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;

    final aValue = _getItemValue(a);
    final bValue = _getItemValue(b);

    return aValue == bValue;
  }

  Future<List<DropdownOption>> _loadData(
    String? filter,
    dynamic infiniteScrollProps,
  ) async {
    if (widget.onFind == null) {
      return widget.options ?? [];
    }

    try {
      final page = infiniteScrollProps?.page ?? 1;
      _currentPage = page;
      _currentFilter = filter ?? '';

      final results = await widget.onFind!(_currentFilter, _currentPage);
      return results;
    } catch (e) {
      debugPrint('Error loading dropdown data: $e');
      return [];
    }
  }

  Future<bool> _handleBeforePopupOpening(dynamic selectedValue) async {
    FocusManager.instance.primaryFocus?.unfocus();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Wrap in container for spacing
    final field = SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show label on top for standard style
          if (widget.style == InputFieldStyle.standard &&
              widget.label != null &&
              widget.label!.isNotEmpty)
            _buildTopLabel(context),

          if (widget.style == InputFieldStyle.standard &&
              widget.label != null &&
              widget.label!.isNotEmpty)
            10.height,

          // The actual dropdown field
          FormBuilderField<dynamic>(
            name: widget.name,
            initialValue: _formValueFor(_selectedOption),
            validator: widget.validator,
            enabled: widget.isEnabled,
            builder: (FormFieldState<dynamic> field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownSearch<DropdownOption>(
                    items: (filter, infiniteScrollProps) =>
                        _loadData(filter, infiniteScrollProps),
                    selectedItem: _selectedOption,
                    onBeforePopupOpening: _handleBeforePopupOpening,
                    enabled: widget.isEnabled,

                    dropdownBuilder: (context, item) {
                      if (item == null) {
                        return const SizedBox.shrink();
                      }

                      return Row(
                        children: [
                          if (item.icon != null) ...[
                            Icon(item.icon, color: context.onSurface, size: 20),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              item.label,
                              style:
                                  widget.textStyle ??
                                  context.bodyMedium?.copyWith(
                                    color: context.onSurface,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    },

                    decoratorProps: DropDownDecoratorProps(
                      decoration: _buildDecoration(context, field),
                    ),

                    suffixProps: DropdownSuffixProps(
                      dropdownButtonProps: DropdownButtonProps(
                        iconOpened: Icon(
                          FeatherIcons.chevronUp,
                          color: context.onSurfaceVariant,
                        ),
                        iconClosed: Icon(
                          FeatherIcons.chevronDown,
                          color: context.onSurfaceVariant,
                        ),
                      ),
                    ),

                    // Popup configuration
                    popupProps: PopupProps.menu(
                      showSearchBox: widget.showSearchBox,
                      searchDelay: Duration.zero,
                      fit: FlexFit.loose,
                      constraints: const BoxConstraints(maxHeight: 350),

                      // Search field
                      searchFieldProps: TextFieldProps(
                        controller: _searchController,
                        cursorColor: context.primary,
                        decoration: InputDecoration(
                          hintText: widget.searchHint,
                          prefixIcon: const Icon(FeatherIcons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),

                      itemBuilder: (context, item, isDisabled, isSelected) {
                        final selected = _isSameItem(item, _selectedOption);

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          color: selected
                              ? context.primaryContainer.withValues(alpha: 0.3)
                              : null,
                          child: Row(
                            children: [
                              if (item.icon != null) ...[
                                Icon(
                                  item.icon,
                                  size: 20,
                                  color: context.onSurface,
                                ),
                                const SizedBox(width: 12),
                              ],
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: context.bodyMedium,
                                ),
                              ),
                              if (selected)
                                Icon(
                                  FeatherIcons.check,
                                  color: context.primary,
                                  size: 20,
                                ),
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
                              widget.emptyMessage ?? 'No items found',
                              style: context.bodyMedium?.copyWith(
                                color: context.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ];

                        if (widget.allowCustomValue && query.isNotEmpty) {
                          children.add(
                            ListTile(
                              leading: const Icon(FeatherIcons.plusCircle),
                              title: Text('Add "$query"'),
                              onTap: () {
                                final customOption = DropdownOption(
                                  value: query,
                                  label: query,
                                );
                                setState(() {
                                  _selectedOption = customOption;
                                });
                                field.didChange(_formValueFor(customOption));
                                if (widget.onChanged != null) {
                                  widget.onChanged!(
                                    _formValueFor(customOption),
                                  );
                                }
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

                    onChanged: (DropdownOption? value) {
                      if (_isSameItem(_selectedOption, value)) return;

                      setState(() {
                        _selectedOption = value;
                      });

                      final emit = _formValueFor(value);
                      field.didChange(emit);

                      if (widget.onChanged != null) {
                        widget.onChanged!(emit);
                      }
                    },
                  ),

                  field.hasError
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8, left: 12),
                          child: Text(
                            field.errorText ?? '',
                            style: TextStyle(
                              color: context.error,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              );
            },
          ),
        ],
      ),
    );

    // Add bottom spacing
    return Padding(
      padding: EdgeInsets.only(bottom: widget.spacing),
      child: field,
    );
  }

  Widget _buildTopLabel(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: widget.label,
        style: context.labelMedium?.copyWith(color: context.onSurface),
        children: widget.isRequired
            ? [
                TextSpan(
                  text: ' *',
                  style: context.labelMedium?.copyWith(color: context.error),
                ),
              ]
            : [],
      ),
    );
  }

  /// Build input decoration using centralized style builder
  InputDecoration _buildDecoration(BuildContext context, FormFieldState field) {
    return buildInputDecoration(
      context: context,
      style: widget.style,
      labelWidget:
          (widget.style == InputFieldStyle.floating && widget.label != null)
          ? _buildFloatingLabel(context)
          : null,
      labelText: widget.style == InputFieldStyle.outlined ? widget.label : null,
      hintText: widget.hintText,
      hintStyle: widget.hintStyle,
      prefixIcon: widget.prefixIcon,
      suffixIcon: null,
      contentPadding: widget.contentPadding,
      filled: true,
      fillColor: null,
    );
  }

  Widget _buildFloatingLabel(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: widget.label,
        style: context.labelLarge?.copyWith(color: context.onSurfaceVariant),
        children: widget.isRequired
            ? [
                TextSpan(
                  text: ' *',
                  style: context.labelMedium?.copyWith(color: context.error),
                ),
              ]
            : [],
      ),
    );
  }
}

// ==========================
// Helper: Convert to DropdownOptions
// ==========================

List<DropdownOption> convertToDropdownOptions(List<dynamic>? options) {
  if (options == null) return [];

  return options.map((opt) {
    if (opt is Map) {
      return DropdownOption(
        value: opt['value'],
        label: opt['label']?.toString() ?? '',
        icon: opt['icon'] as IconData?,
        isEnabled: opt['isEnabled'] ?? true,
      );
    }
    if (opt is DropdownOption) return opt;
    return DropdownOption(value: opt, label: opt.toString());
  }).toList();
}

// ==========================
// Dropdown Data Model
// ==========================

class DropdownOption {
  final dynamic value;
  final String label;
  final IconData? icon;
  final bool isEnabled;
  final dynamic extra;

  const DropdownOption({
    required this.value,
    required this.label,
    this.icon,
    this.isEnabled = true,
    this.extra,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropdownOption &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'DropdownOption{value: $value, label: $label}';
  }
}
