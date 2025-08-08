import 'package:flutter/material.dart';

enum CustomTabBarVariant {
  primary,
  secondary,
  pills,
  underline,
}

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final TabController? controller;
  final ValueChanged<int>? onTap;
  final CustomTabBarVariant variant;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
    this.variant = CustomTabBarVariant.primary,
    this.isScrollable = false,
    this.padding,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CustomTabBarVariant.primary:
        return _buildPrimaryTabBar(context, theme, colorScheme);
      case CustomTabBarVariant.secondary:
        return _buildSecondaryTabBar(context, theme, colorScheme);
      case CustomTabBarVariant.pills:
        return _buildPillsTabBar(context, theme, colorScheme);
      case CustomTabBarVariant.underline:
        return _buildUnderlineTabBar(context, theme, colorScheme);
    }
  }

  Widget _buildPrimaryTabBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        onTap: onTap,
        isScrollable: isScrollable,
        labelColor: labelColor ?? colorScheme.secondary,
        unselectedLabelColor:
            unselectedLabelColor ?? colorScheme.onSurfaceVariant,
        indicatorColor: indicatorColor ?? colorScheme.secondary,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  Widget _buildSecondaryTabBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TabBar(
          controller: controller,
          onTap: onTap,
          isScrollable: isScrollable,
          labelColor: labelColor ?? colorScheme.onPrimary,
          unselectedLabelColor:
              unselectedLabelColor ?? colorScheme.onSurfaceVariant,
          indicator: BoxDecoration(
            color: indicatorColor ?? colorScheme.secondary,
            borderRadius: BorderRadius.circular(6),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w400,
            letterSpacing: 0.1,
          ),
          tabs: tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
    );
  }

  Widget _buildPillsTabBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = controller?.index == index;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _PillTab(
                text: tab,
                isSelected: isSelected,
                onTap: () => onTap?.call(index),
                colorScheme: colorScheme,
                theme: theme,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildUnderlineTabBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: controller,
        onTap: onTap,
        isScrollable: isScrollable,
        labelColor: labelColor ?? colorScheme.primary,
        unselectedLabelColor:
            unselectedLabelColor ?? colorScheme.onSurfaceVariant,
        indicatorColor: indicatorColor ?? colorScheme.secondary,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: colorScheme.outline.withValues(alpha: 0.2),
        labelStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}

class _PillTab extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _PillTab({
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.secondary : colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? colorScheme.secondary
                  : colorScheme.outline.withValues(alpha: 0.5),
              width: 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            text,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isSelected
                  ? colorScheme.onSecondary
                  : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}

// Custom TabBar with business category filtering
class BusinessCategoryTabBar extends StatelessWidget
    implements PreferredSizeWidget {
  final TabController? controller;
  final ValueChanged<int>? onTap;
  final CustomTabBarVariant variant;

  const BusinessCategoryTabBar({
    super.key,
    this.controller,
    this.onTap,
    this.variant = CustomTabBarVariant.pills,
  });

  static const List<String> businessCategories = [
    'All',
    'Restaurants',
    'Shopping',
    'Services',
    'Entertainment',
    'Health',
    'Beauty',
    'Automotive',
  ];

  @override
  Widget build(BuildContext context) {
    return CustomTabBar(
      tabs: businessCategories,
      controller: controller,
      onTap: (index) {
        onTap?.call(index);
        _handleCategorySelection(context, index);
      },
      variant: variant,
      isScrollable: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  void _handleCategorySelection(BuildContext context, int index) {
    final category = businessCategories[index];

    // Navigate to business search with category filter
    Navigator.pushNamed(
      context,
      '/business-search',
      arguments: {'category': category},
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
