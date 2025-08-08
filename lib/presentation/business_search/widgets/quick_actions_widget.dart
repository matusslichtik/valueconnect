import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class QuickActionsWidget extends StatelessWidget {
  final Map<String, dynamic> business;
  final VoidCallback? onCall;
  final VoidCallback? onDirections;
  final VoidCallback? onShare;
  final VoidCallback? onFavorite;

  const QuickActionsWidget({
    super.key,
    required this.business,
    this.onCall,
    this.onDirections,
    this.onShare,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                context,
                theme,
                colorScheme,
                icon: 'phone',
                label: 'Call',
                onTap: onCall,
              ),
              _buildActionButton(
                context,
                theme,
                colorScheme,
                icon: 'directions',
                label: 'Directions',
                onTap: onDirections,
              ),
              _buildActionButton(
                context,
                theme,
                colorScheme,
                icon: 'share',
                label: 'Share',
                onTap: onShare,
              ),
              _buildActionButton(
                context,
                theme,
                colorScheme,
                icon: (business['isFavorite'] as bool? ?? false)
                    ? 'favorite'
                    : 'favorite_border',
                label: 'Favorite',
                onTap: onFavorite,
                isActive: business['isFavorite'] as bool? ?? false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme, {
    required String icon,
    required String label,
    required VoidCallback? onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: isActive
                  ? colorScheme.secondary.withValues(alpha: 0.1)
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: isActive
                  ? colorScheme.secondary
                  : colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isActive
                  ? colorScheme.secondary
                  : colorScheme.onSurfaceVariant,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
