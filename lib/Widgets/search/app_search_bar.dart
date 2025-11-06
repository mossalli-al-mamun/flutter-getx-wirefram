import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';

import '../../Config/themes/text_styles.dart';

/// A customizable search bar widget for the Dokan Admin App.
///
/// This widget provides a search bar that can be used either as a clickable
/// element that opens a search screen or as an actual input field.
class AppSearchBar extends StatefulWidget {
  final bool? searchOn;
  final String? placeholderText;
  final bool? enableOnScreenSearch;
  final VoidCallback? onSearchTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final Color? backgroundColor;
  final double borderRadius;
  final Widget? suffixIcon;
  final FocusNode? focusNode;

  const AppSearchBar({
    super.key,
    this.searchOn,
    this.placeholderText,
    this.enableOnScreenSearch,
    this.onSearchTap,
    this.controller,
    this.onChanged,
    this.backgroundColor,
    this.borderRadius = 5.0,
    this.suffixIcon,
    this.focusNode,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  bool _hasText = false;
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Check if controller already has text
    if (widget.controller != null && widget.controller!.text.isNotEmpty) {
      _hasText = true;
    }

    // Initialize focus node
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);

    // Add listener to controller to update _hasText
    widget.controller?.addListener(_updateHasText);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_updateHasText);

    // Clean up focus node if we created it
    if (widget.focusNode == null) {
      _focusNode.removeListener(_onFocusChange);
      _focusNode.dispose();
    }

    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _updateHasText() {
    final hasText = widget.controller?.text.isNotEmpty ?? false;
    if (_hasText != hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _clearText() {
    widget.controller?.clear();
    if (widget.onChanged != null) {
      widget.onChanged!('');
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchBarWidget = Container(
      alignment: Alignment.center,
      height: 50,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? context.cardColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: _isFocused
            ? Border.all(color: context.primary, width: 1.0)
            : null,
      ),
      child: InkWell(
        onTap: widget.enableOnScreenSearch != true ? widget.onSearchTap : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            15.width,
            Icon(
              FeatherIcons.search,
            ),
            12.width,
            Expanded(
              child: TextField(
                enabled: widget.enableOnScreenSearch ?? false,
                controller: widget.controller,
                focusNode: _focusNode,
                onChanged: (value) {
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                },
                cursorColor: context.primary,
                decoration: InputDecoration(
                  hintText: widget.placeholderText,
                  hintStyle: AppTextStyle.labelLarge,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            if (_hasText)
              IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 20,
                ),
                onPressed: _clearText,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            if (_hasText) 8.width,
          ],
        ),
      ),
    );

    return Expanded(child: searchBarWidget);
  }
}
