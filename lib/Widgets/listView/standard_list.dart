import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import 'package:get/get.dart';

import '../../../../Widgets/app_loaders.dart';
import '../../Controller/locale/localization_service_controller.dart';
import '../empty_state_widget.dart';

//For Nested scrollview in TopTab like Product and Orders
class StandardListViewGeneric<T> extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final RxList<T> itemsData;
  final bool isLoading;
  final bool? isRefreshing;
  final bool isPaginationLoading;
  final Widget Function(BuildContext, T) itemBuilder;
  final ScrollController? scrollController;
  final String emptyText;
  final bool? hasError;
  final String? errorText;
  final Widget? shimmerWidget;
  final Widget? emptyWidget;
  final bool? pinSearchBar;
  final bool? isSearchContext;
  final String? searchQuery;

  const StandardListViewGeneric({
    super.key,
    required this.onRefresh,
    required this.itemsData,
    required this.isLoading,
    this.isRefreshing,
    required this.isPaginationLoading,
    required this.itemBuilder,
    this.hasError,
    this.errorText,
    this.scrollController,
    this.emptyText = 'Data',
    this.shimmerWidget,
    this.emptyWidget,
    this.pinSearchBar,
    this.isSearchContext,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 0,
      color: context.primary,
      backgroundColor: Colors.white,
      onRefresh: onRefresh,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    final bool showShimmer = isLoading || (isRefreshing ?? false);
    final bool isEmpty = itemsData.isEmpty;

    /// Loading Shimmer
    if (showShimmer) shimmerWidget ?? AppLoader();

    /// Empty State
    if (!showShimmer && !(hasError ?? false) && isEmpty) {
      return Center(
        child: _emptyWidget(),
      );
    }

    /// Error State
    if ((hasError ?? false) && errorText != null) {
      return Center(
        child: Text(errorText!),
      );
    }

    /// Main ListView
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        itemCount: itemsData.length + 1,
        itemBuilder: (context, index) {
          if (index < itemsData.length) {
            final item = itemsData[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: itemBuilder(context, item),
            );
          }

          // Footer loader
          return Center(
            child: (itemsData.isNotEmpty && isPaginationLoading)
                ? const AppLoader(size: 0.6)
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _emptyWidget() {
    return isSearchContext == true
        ? EmptyStateWidget(
            icon: FeatherIcons.search,
            title: '${tr.searchResultFor} "${searchQuery ?? ""}"',
            subtitle: tr.emptyData('results'),
            showButton: false,
          )
        : emptyWidget ??
            Center(
              child: Text(tr.emptyData(emptyText)),
            );
  }
}
