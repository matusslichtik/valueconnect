import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptySearchWidget extends StatelessWidget {
  final String searchQuery;
  final VoidCallback? onClearSearch;
  final ValueChanged<String>? onCategoryTap;

  const EmptySearchWidget({
    super.key,
    required this.searchQuery,
    this.onClearSearch,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: colorScheme.onSurfaceVariant,
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              searchQuery.isEmpty
                  ? 'Start searching for businesses'
                  : 'No businesses found',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              searchQuery.isEmpty
                  ? 'Use the search bar above to find businesses near you'
                  : 'Try adjusting your search or filters to find what you\'re looking for',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            if (searchQuery.isNotEmpty) ...[
              ElevatedButton(
                onPressed: onClearSearch,
                child: Text('Clear Search'),
              ),
              SizedBox(height: 2.h),
            ],
            Text(
              'Popular Categories',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              alignment: WrapAlignment.center,
              children: _buildPopularCategories(context, theme, colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPopularCategories(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    final categories = ['Restaurants', 'Shopping', 'Services', 'Entertainment'];

    return categories.map((category) {
      return GestureDetector(
        onTap: () => onCategoryTap?.call(category),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            category,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }).toList();
  }
}
