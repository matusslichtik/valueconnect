import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum CustomAppBarVariant {
  primary,
  secondary,
  transparent,
  search,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final CustomAppBarVariant variant;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final VoidCallback? onBackPressed;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  final String? searchHint;

  const CustomAppBar({
    super.key,
    this.title,
    this.variant = CustomAppBarVariant.primary,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.onBackPressed,
    this.searchController,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.searchHint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: _buildTitle(context),
      backgroundColor: _getBackgroundColor(colorScheme),
      foregroundColor: _getForegroundColor(colorScheme),
      elevation: _getElevation(),
      shadowColor: _getShadowColor(colorScheme),
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading ?? _buildLeading(context),
      actions: actions ?? _buildDefaultActions(context),
      systemOverlayStyle: _getSystemOverlayStyle(),
      titleTextStyle: _getTitleTextStyle(context),
      iconTheme: IconThemeData(
        color: _getForegroundColor(colorScheme),
        size: 24,
      ),
    );
  }

  Widget? _buildTitle(BuildContext context) {
    switch (variant) {
      case CustomAppBarVariant.search:
        return _buildSearchField(context);
      case CustomAppBarVariant.primary:
      case CustomAppBarVariant.secondary:
      case CustomAppBarVariant.transparent:
        return title != null ? Text(title!) : null;
    }
  }

  Widget _buildSearchField(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline,
          width: 1,
        ),
      ),
      child: TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        onSubmitted: (_) => onSearchSubmitted?.call(),
        decoration: InputDecoration(
          hintText: searchHint ?? 'Search businesses...',
          prefixIcon: Icon(
            Icons.search,
            color: colorScheme.onSurfaceVariant,
            size: 20,
          ),
          suffixIcon: searchController?.text.isNotEmpty == true
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: () {
                    searchController?.clear();
                    onSearchChanged?.call('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          hintStyle: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (!automaticallyImplyLeading) return null;

    final canPop = Navigator.of(context).canPop();
    if (!canPop) return null;

    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      tooltip: 'Back',
    );
  }

  List<Widget>? _buildDefaultActions(BuildContext context) {
    switch (variant) {
      case CustomAppBarVariant.primary:
        return [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigate to notifications or show notifications
            },
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              // Navigate to profile or show profile menu
            },
            tooltip: 'Profile',
          ),
        ];
      case CustomAppBarVariant.secondary:
        return [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showMoreMenu(context);
            },
            tooltip: 'More options',
          ),
        ];
      case CustomAppBarVariant.search:
        return [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Navigator.pushNamed(context, '/business-search');
            },
            tooltip: 'Filter',
          ),
        ];
      case CustomAppBarVariant.transparent:
        return null;
    }
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home-dashboard',
                  (route) => false,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search Businesses'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/business-search');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help & Support'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to help
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case CustomAppBarVariant.primary:
      case CustomAppBarVariant.secondary:
      case CustomAppBarVariant.search:
        return colorScheme.surface;
      case CustomAppBarVariant.transparent:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case CustomAppBarVariant.primary:
      case CustomAppBarVariant.secondary:
      case CustomAppBarVariant.search:
        return colorScheme.onSurface;
      case CustomAppBarVariant.transparent:
        return colorScheme.onSurface;
    }
  }

  double _getElevation() {
    switch (variant) {
      case CustomAppBarVariant.primary:
      case CustomAppBarVariant.secondary:
      case CustomAppBarVariant.search:
        return 0;
      case CustomAppBarVariant.transparent:
        return 0;
    }
  }

  Color _getShadowColor(ColorScheme colorScheme) {
    return colorScheme.shadow;
  }

  SystemUiOverlayStyle _getSystemOverlayStyle() {
    switch (variant) {
      case CustomAppBarVariant.primary:
      case CustomAppBarVariant.secondary:
      case CustomAppBarVariant.search:
        return SystemUiOverlayStyle.dark;
      case CustomAppBarVariant.transparent:
        return SystemUiOverlayStyle.dark;
    }
  }

  TextStyle _getTitleTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.titleLarge!.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
