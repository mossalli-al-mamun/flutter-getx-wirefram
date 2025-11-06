// ==========================
// Unified Searchable Dropdown Field
// ==========================
// Matches UnifiedInputField structure and uses centralized buildInputDecoration

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/context_ext.dart';
import 'package:flutter_getx_wireframe/Utils/app_logger.dart';
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

  /// When true (default), the full selected object is passed to Form and onChanged.
  /// When false, only the primitive value is passed (backward compatibility).
  final bool passFullObject;

  const UnifiedDropdownField({
    super.key,
    required this.name,
    this.label,
    this.hintText,
    this.initialValue,
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
  dynamic _selectedItem;
  int _currentPage = 1;
  String _currentFilter = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode(debugLabel: 'UnifiedDropdownField');

  dynamic _resolveSelectedFromInitial(dynamic initial) {
    if (initial == null) return null;
    if (initial is DropdownOption) return initial;

    // Try to resolve primitive/map to a provided option by value
    final options = widget.options ?? [];
    try {
      return options.firstWhere(
        (opt) => _getItemValue(opt) == _getItemValue(initial),
      );
    } catch (_) {
      // Fallback: keep the initial as-is
      return initial;
    }
  }

  dynamic _formValueFor(dynamic selected) {
    return widget.passFullObject ? selected : _getItemValue(selected);
  }

  @override
  void initState() {
    super.initState();
    _selectedItem = _resolveSelectedFromInitial(widget.initialValue);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant UnifiedDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue || widget.options != oldWidget.options) {
      setState(() {
        _selectedItem = _resolveSelectedFromInitial(widget.initialValue);
      });
    }
  }

  String _getItemLabel(dynamic item) {
    if (item == null) return widget.hintText ?? '';

    if (item is DropdownOption) return item.label;
    if (item is String) return item;
    if (item is Map) {
      return item['label']?.toString() ??
          item['name']?.toString() ??
          item['title']?.toString() ??
          '';
    }
    return item.toString();
  }

  dynamic _getItemValue(dynamic item) {
    if (item == null) return null;
    if (item is DropdownOption) return item.value;
    if (item is Map) return item['value'] ?? item['id'];
    return item;
  }

  DropdownOption? _getSelectedOption() {
    if (_selectedItem == null) return null;

    if (_selectedItem is DropdownOption) return _selectedItem;

    // Find option by value
    final allOptions = widget.options ?? [];
    try {
      return allOptions.firstWhere(
        (opt) => _getItemValue(opt) == _getItemValue(_selectedItem),
      );
    } catch (e) {
      return null;
    }
  }

  bool _isSameItem(dynamic a, dynamic b) {
    if (a == null || b == null) return false;
    return _getItemValue(a) == _getItemValue(b);
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
            initialValue: _formValueFor(_selectedItem),
            validator: widget.validator,
            enabled: widget.isEnabled,
            builder: (FormFieldState<dynamic> field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownSearch<dynamic>(
                      items: (filter, infiniteScrollProps) =>
                          _loadData(filter, infiniteScrollProps),
                      selectedItem: _selectedItem,
                      onBeforePopupOpening: _handleBeforePopupOpening,
                      enabled: widget.isEnabled,

                      // Custom dropdown builder
                      dropdownBuilder: (context, item) {
                      if (item == null) {
                        // Let InputDecoration show the hintText
                        return const SizedBox.shrink();
                      }

                      final label = _getItemLabel(item);
                      final selectedOption = _getSelectedOption();

                      return Row(
                        children: [
                          if (selectedOption?.icon != null) ...[
                            Icon(
                              selectedOption!.icon,
                              color: context.onSurface,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              label,
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

                    // Use centralized decoration builder
                    decoratorProps: DropDownDecoratorProps(
                      decoration: _buildDecoration(context, field),
                    ),

                    // Suffix icon
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

                      // Item builder
                      itemBuilder: (context, item, isDisabled, isSelected) {
                        final label = _getItemLabel(item);
                        final selected = _isSameItem(item, _selectedItem);
                        final option = item is DropdownOption ? item : null;

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
                              if (option?.icon != null) ...[
                                Icon(
                                  option!.icon,
                                  size: 20,
                                  color: context.onSurface,
                                ),
                                const SizedBox(width: 12),
                              ],
                              Expanded(
                                child: Text(label, style: context.bodyMedium),
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

                      // Empty state
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
                                setState(() {
                                  _selectedItem = query;
                                });
                                field.didChange(query);
                                if (widget.onChanged != null) {
                                  widget.onChanged!(query);
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

                    // Comparison function
                    compareFn: (item1, item2) => _isSameItem(item1, item2),

                    // On changed
                    onChanged: (value) {
                      setState(() {
                        _selectedItem = value;
                      });

                      final emit = _formValueFor(value);
                      field.didChange(emit);
                      if (widget.onChanged != null) {
                        widget.onChanged!(emit);
                      }

                      // Keep focus like DropdownButtonFormField
                      if (_focusNode.canRequestFocus) {
                        _focusNode.requestFocus();
                        FocusScope.of(context).requestFocus(_focusNode);
                      }
                    },
                  ),

                  // Error text (matches UnifiedInputField)
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

  /// Build label for standard style (appears above field)
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
      // Handled by DropdownSearch
      contentPadding: widget.contentPadding,
      filled: true,
      fillColor: null,
    );
  }

  /// Build floating label with optional required asterisk
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
// Helper: Convert FormFieldConfig options to DropdownOptions
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
// Example Usage
// ==========================

class ExampleDropdownUsage extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  ExampleDropdownUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          // Simple dropdown with static options
          UnifiedDropdownField(
            name: 'country',
            label: 'Country',
            hintText: 'Select a country',
            isRequired: true,
            style: InputFieldStyle.standard,
            prefixIcon: Icons.public,
            options: const [
              DropdownOption(value: 'us', label: 'United States'),
              DropdownOption(value: 'uk', label: 'United Kingdom'),
              DropdownOption(value: 'ca', label: 'Canada'),
              DropdownOption(value: 'au', label: 'Australia'),
            ],
            validator: (value) {
              if (value == null) return 'Country is required';
              return null;
            },
            onChanged: (value) {
              appLogger('Selected country: $value');
            },
          ),

          // Dropdown with async data loading
          UnifiedDropdownField(
            name: 'city',
            label: 'City',
            hintText: 'Search cities',
            style: InputFieldStyle.floating,
            prefixIcon: Icons.location_city,
            showSearchBox: true,
            onFind: (filter, page) async {
              await Future.delayed(const Duration(milliseconds: 500));

              const cities = [
                DropdownOption(value: '1', label: 'New York'),
                DropdownOption(value: '2', label: 'London'),
                DropdownOption(value: '3', label: 'Paris'),
                DropdownOption(value: '4', label: 'Tokyo'),
                DropdownOption(value: '5', label: 'Sydney'),
              ];

              if (filter.isEmpty) return cities;

              return cities.where((city) {
                return city.label.toLowerCase().contains(filter.toLowerCase());
              }).toList();
            },
          ),

          // Dropdown with icons
          UnifiedDropdownField(
            name: 'payment_method',
            label: 'Payment Method',
            style: InputFieldStyle.outlined,
            options: const [
              DropdownOption(
                value: 'card',
                label: 'Credit Card',
                icon: Icons.credit_card,
              ),
              DropdownOption(
                value: 'paypal',
                label: 'PayPal',
                icon: Icons.payment,
              ),
              DropdownOption(
                value: 'bank',
                label: 'Bank Transfer',
                icon: Icons.account_balance,
              ),
            ],
          ),

          // Matching UnifiedInputField
          UnifiedInputField(
            name: 'email',
            label: 'Email Address',
            hintText: 'you@example.com',
            isRequired: true,
            style: InputFieldStyle.floating,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }
}

/// Option model for dropdown items
class DropdownOption {
  final dynamic value;
  final String label;
  final IconData? icon;
  final bool isEnabled;

  const DropdownOption({
    required this.value,
    required this.label,
    this.icon,
    this.isEnabled = true,
  });

  @override
  String toString() => label;
}
