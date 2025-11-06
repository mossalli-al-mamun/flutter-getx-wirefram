import 'package:flutter/material.dart';
import '../../Config/themes/text_styles.dart';
import '../../Config/themes/extensions/colors_ext.dart';


class CustomHeader extends StatelessWidget {
  final String title;
  final String? subTitle;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final Color? titleColor;
  final Color? subTitleColor;
  final CrossAxisAlignment alignment;
  final double spacing;
  final int? maxLines;
  final TextOverflow? overflow;

  const CustomHeader({
    super.key,
    required this.title,
    this.subTitle,
    this.titleStyle,
    this.subTitleStyle,
    this.titleColor,
    this.subTitleColor,
    this.alignment = CrossAxisAlignment.start,
    this.spacing = 4,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: (titleStyle ?? AppTextStyle.titleLarge).copyWith(
            color: titleColor ?? context.textPrimaryColor,
          ),
          maxLines: maxLines,
          overflow: overflow,
        ),
        if (subTitle != null && subTitle!.isNotEmpty) ...[
          SizedBox(height: spacing),
          Text(
            subTitle!,
            style: (subTitleStyle ?? AppTextStyle.bodyMedium).copyWith(
              color: subTitleColor ?? context.textSecondaryColor,
            ),
            maxLines: maxLines,
            overflow: overflow,
          ),
        ],
      ],
    );
  }
}

// ==================== NAVIGATION HEADER ====================

class NavigationHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subTitle;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final Color? titleColor;
  final Color? subTitleColor;
  final Color? backgroundColor;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final double? elevation;
  final double? leadingWidth;
  final double titleSpacing;
  final IconData backIcon;
  final Color? backIconColor;
  final double? backIconSize;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? toolbarHeight;

  const NavigationHeader({
    super.key,
    this.title,
    this.subTitle,
    this.titleStyle,
    this.subTitleStyle,
    this.titleColor,
    this.subTitleColor,
    this.backgroundColor,
    this.showBackButton = true,
    this.onBackPressed,
    this.leading,
    this.actions,
    this.centerTitle = false,
    this.elevation,
    this.leadingWidth,
    this.titleSpacing = 0,
    this.backIcon = Icons.arrow_back,
    this.backIconColor,
    this.backIconSize,
    this.flexibleSpace,
    this.bottom,
    this.toolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? context.scaffoldBackgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leadingWidth: leadingWidth,
      titleSpacing: titleSpacing,
      toolbarHeight: toolbarHeight ?? kToolbarHeight,
      leading: leading ?? (showBackButton ? _buildBackButton(context) : null),
      title: (title != null || subTitle != null)
          ? CustomHeader(
        title: title ?? '',
        subTitle: subTitle,
        titleStyle: titleStyle,
        subTitleStyle: subTitleStyle,
        titleColor: titleColor,
        subTitleColor: subTitleColor,
        alignment: centerTitle
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
      )
          : null,
      actions: actions,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.only(left: 4),
      icon: Icon(
        backIcon,
        color: backIconColor ?? context.iconColor,
        size: backIconSize,
      ),
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
    );
  }

  @override
  Size get preferredSize {
    final height = toolbarHeight ?? kToolbarHeight;
    final bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(height + bottomHeight);
  }
}

// ==================== USAGE EXAMPLES ====================

/// Example 1: Basic Navigation Header
/// ```dart
/// NavigationHeader(
///   title: 'Profile',
///   subTitle: 'Manage your account',
/// )
/// ```

/// Example 2: Custom Styled Header
/// ```dart
/// NavigationHeader(
///   title: 'Settings',
///   subTitle: 'Configure your preferences',
///   titleStyle: AppTextStyle.headlineMedium,
///   titleColor: Colors.blue,
///   subTitleColor: Colors.grey,
///   backgroundColor: Colors.white,
/// )
/// ```

/// Example 3: Header with Custom Back Button
/// ```dart
/// NavigationHeader(
///   title: 'Details',
///   backIcon: Icons.close,
///   backIconColor: Colors.red,
///   onBackPressed: () {
///     // Custom back logic
///     showDialog(...);
///   },
/// )
/// ```

/// Example 4: Header with Actions
/// ```dart
/// NavigationHeader(
///   title: 'Messages',
///   showBackButton: false,
///   actions: [
///     IconButton(
///       icon: Icon(Icons.search),
///       onPressed: () {},
///     ),
///     IconButton(
///       icon: Icon(Icons.more_vert),
///       onPressed: () {},
///     ),
///   ],
/// )
/// ```

/// Example 5: Header with Custom Leading Widget
/// ```dart
/// NavigationHeader(
///   title: 'Chat',
///   leading: CircleAvatar(
///     backgroundImage: NetworkImage('...'),
///   ),
/// )
/// ```

/// Example 6: Centered Title Header
/// ```dart
/// NavigationHeader(
///   title: 'About',
///   centerTitle: true,
///   elevation: 0,
/// )
/// ```

/// Example 7: Header with TabBar Bottom
/// ```dart
/// NavigationHeader(
///   title: 'Categories',
///   bottom: TabBar(
///     tabs: [
///       Tab(text: 'All'),
///       Tab(text: 'Active'),
///       Tab(text: 'Completed'),
///     ],
///   ),
/// )
/// ```

/// Example 8: Standalone Custom Header (Not AppBar)
/// ```dart
/// Padding(
///   padding: EdgeInsets.all(16),
///   child: CustomHeader(
///     title: 'Welcome Back',
///     subTitle: 'Here's what's happening today',
///     titleStyle: AppTextStyle.headlineLarge,
///     spacing: 8,
///   ),
/// )
/// ```

/// Example 9: Custom Header with Alignment
/// ```dart
/// CustomHeader(
///   title: 'Total Balance',
///   subTitle: '\$12,345.67',
///   alignment: CrossAxisAlignment.end,
///   titleColor: Colors.grey,
///   subTitleColor: Colors.green,
///   subTitleStyle: AppTextStyle.headlineMedium.copyWith(
///     fontWeight: FontWeight.bold,
///   ),
/// )
/// ```

/// Example 10: Complete Page with Navigation Header
/// ```dart
/// class ProfilePage extends StatelessWidget {
///   const ProfilePage({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: NavigationHeader(
///         title: 'Profile',
///         subTitle: 'Manage your information',
///         actions: [
///           IconButton(
///             icon: Icon(Icons.edit),
///             onPressed: () {
///               // Navigate to edit profile
///             },
///           ),
///         ],
///       ),
///       body: SingleChildScrollView(
///         padding: EdgeInsets.all(16),
///         child: Column(
///           children: [
///             // Profile content
///           ],
///         ),
///       ),
///     );
///   }
/// }
/// ```

/// Example 11: Header with Flexible Space (Gradient Background)
/// ```dart
/// NavigationHeader(
///   title: 'Dashboard',
///   subTitle: 'Overview',
///   titleColor: Colors.white,
///   subTitleColor: Colors.white70,
///   backgroundColor: Colors.transparent,
///   flexibleSpace: Container(
///     decoration: BoxDecoration(
///       gradient: LinearGradient(
///         colors: [Colors.blue, Colors.purple],
///         begin: Alignment.topLeft,
///         end: Alignment.bottomRight,
///       ),
///     ),
///   ),
/// )
/// ```

/// Example 12: Theme-Aware Header (Automatic Dark/Light Mode)
/// ```dart
/// NavigationHeader(
///   title: 'Settings',
///   subTitle: 'App preferences',
///   // Colors automatically adapt to theme
///   // backgroundColor uses context.scaffoldBackgroundColor
///   // titleColor uses context.textPrimaryColor
///   // subTitleColor uses context.textSecondaryColor
///   // backIconColor uses context.iconColor
/// )
/// ```

/// Example 13: Header with Custom Height
/// ```dart
/// NavigationHeader(
///   title: 'Large Header',
///   subTitle: 'With more space',
///   toolbarHeight: 80,
/// )
/// ```

/// Example 14: No Back Button Header (Root Page)
/// ```dart
/// NavigationHeader(
///   title: 'Home',
///   showBackButton: false,
///   actions: [
///     IconButton(
///       icon: Icon(Icons.notifications),
///       onPressed: () {},
///     ),
///   ],
/// )
/// ```

/// Example 15: Header with Text Overflow Handling
/// ```dart
/// CustomHeader(
///   title: 'This is a very long title that might overflow',
///   subTitle: 'And this is also a long subtitle',
///   maxLines: 1,
///   overflow: TextOverflow.ellipsis,
/// )
/// ```