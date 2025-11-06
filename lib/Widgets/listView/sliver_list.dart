import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import 'package:get/get.dart';

import '../../../../Widgets/app_loaders.dart';
import '../../Controller/locale/localization_service_controller.dart';
import '../empty_state_widget.dart';

/// For NestedScrollView + SliverAppBar tabs like Product and Orders
class SliverListViewGeneric<T> extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final RxList<T> itemsData;
  final bool isLoading;
  final bool? isRefreshing;
  final bool isPaginationLoading;
  final Widget Function(BuildContext, T) itemBuilder;
  final ScrollController? scrollController;
  final String emptyText;
  final bool? hasError;
  final dynamic errorText;
  final Widget? shimmerWidget;
  final Widget? emptyWidget;
  final bool? pinSearchBar;
  final bool? isSearchContext;
  final String? searchQuery;

  const SliverListViewGeneric({
    super.key,
    required this.onRefresh,
    required this.itemsData,
    required this.isLoading,
    this.isRefreshing,
    this.isPaginationLoading = false,
    required this.itemBuilder,
    this.scrollController,
    this.hasError,
    this.errorText,
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
      displacement: pinSearchBar == true ? 75 : 175,
      color: context.primary,
      backgroundColor: Colors.white,
      onRefresh: onRefresh,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final bool showShimmer = isLoading || (isRefreshing ?? false);
    final bool isEmpty = itemsData.isEmpty;

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),

        /// Loading Shimmer
        if (showShimmer)
          SliverFillRemaining(
            hasScrollBody: true,
            child: shimmerWidget ?? AppLoader(),
          ),

        /// Error State
        if ((hasError ?? false) && errorText != null)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: _errorWidget(),
            ),
          ),

        /// Empty State
        if (!showShimmer && !hasError!)
          if (isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _emptyWidget(),
            ),

        /// Item List
        if (!showShimmer && !isEmpty)
          SliverPadding(
            padding: const EdgeInsets.only(top: 10),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < itemsData.length) {
                    final item = itemsData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: itemBuilder(context, item),
                    );
                  }

                  /// Pagination Loader
                  return Center(
                    child: isPaginationLoading
                        ? const AppLoader(size: 0.6)
                        : const SizedBox.shrink(),
                  );
                },
                childCount: itemsData.length + 1,
              ),
            ),
          ),
      ],
    );
  }

  Widget _emptyWidget() {
    return isSearchContext == true
        ? EmptyStateWidget(
            icon: FeatherIcons.search,
            title: '${tr.searchResultFor} "${searchQuery ?? ""}"',
            subtitle: tr.emptyData('value'),
            showButton: false,
          )
        : emptyWidget ??
            Center(
              child: Text(tr.emptyData(emptyText)),
            );
  }
  Widget _errorWidget() {
    final et = errorText;
    if (et == null) return const SizedBox.shrink();
    if (et is Widget) return et;
    return Text(et.toString(), textAlign: TextAlign.center);
  }
}
