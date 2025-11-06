import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';

import '../../Config/themes/app_colors.dart';
import 'app_search_bar.dart';

/// A widget that combines a search bar with an optional filter button.
///
/// This widget is typically used in screens that require both search and filtering
/// functionality, such as product listings or order lists.
class SearchFilter extends StatelessWidget {
  final bool showFilterButton;
  final String? placeholderText;
  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final Color? searchBarBackgroundColor;
  final Color? filterButtonColor;
  final double filterButtonBorderRadius;
  final double horizontalPadding;
  final double verticalPadding;
  final double bottomPadding;
  final double topPadding;
  final double spaceBetween;
  final IconData filterIcon;
  final Color filterIconColor;
  final bool onScreenSearch;

  const SearchFilter({
    super.key,
    this.showFilterButton = true,
    this.placeholderText,
    required this.onSearchTap,
    required this.onFilterTap,
    this.searchController,
    this.onSearchChanged,
    this.searchBarBackgroundColor,
    this.filterButtonColor,
    this.filterButtonBorderRadius = 5.0,
    this.horizontalPadding = 20.0,
    this.spaceBetween = 10.0,
    this.filterIcon = FeatherIcons.filter,
    this.filterIconColor = AppColors.whiteColor,
    this.onScreenSearch = false,
    this.verticalPadding = 0,
    this.bottomPadding = 0,
    this.topPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        topPadding,
        horizontalPadding,
        bottomPadding,
      ),
      child: Row(
        children: [
          AppSearchBar(
            onSearchTap: onSearchTap,
            placeholderText: placeholderText,
            enableOnScreenSearch: onScreenSearch,
            controller: searchController,
            onChanged: onSearchChanged,
            backgroundColor: searchBarBackgroundColor,
          ),
          showFilterButton
              ? Row(
                  children: [
                    spaceBetween.width,
                    Container(
                      decoration: BoxDecoration(
                        color: filterButtonColor ?? context.primary,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(
                          filterButtonBorderRadius,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(filterIcon, color: filterIconColor),
                        onPressed: onFilterTap,
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
