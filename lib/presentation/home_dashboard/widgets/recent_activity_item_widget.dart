import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentActivityItemWidget extends StatelessWidget {
  final Map<String, dynamic> activity;
  final VoidCallback? onTap;

  const RecentActivityItemWidget({
    super.key,
    required this.activity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String type = (activity["type"] as String?) ?? "";
    final String businessName = (activity["businessName"] as String?) ?? "";
    final String amount = (activity["amount"] as String?) ?? "";
    final DateTime timestamp =
        activity["timestamp"] as DateTime? ?? DateTime.now();
    final String description = (activity["description"] as String?) ?? "";

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(3.w),
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color:
                    _getActivityColor(type, colorScheme).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: _getActivityIcon(type),
                  color: _getActivityColor(type, colorScheme),
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getActivityTitle(type, businessName),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (amount.isNotEmpty)
                        Text(
                          amount,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: type == "discount_used"
                                ? AppTheme.successGreen
                                : colorScheme.onSurface,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  if (description.isNotEmpty)
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _formatTimestamp(timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }

  String _getActivityIcon(String type) {
    switch (type) {
      case "discount_used":
        return "local_offer";
      case "business_discovered":
        return "explore";
      case "favorite_added":
        return "favorite";
      case "review_posted":
        return "rate_review";
      default:
        return "history";
    }
  }

  Color _getActivityColor(String type, ColorScheme colorScheme) {
    switch (type) {
      case "discount_used":
        return AppTheme.successGreen;
      case "business_discovered":
        return colorScheme.secondary;
      case "favorite_added":
        return Colors.pink;
      case "review_posted":
        return Colors.orange;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  String _getActivityTitle(String type, String businessName) {
    switch (type) {
      case "discount_used":
        return "Discount Used";
      case "business_discovered":
        return "New Business Found";
      case "favorite_added":
        return "Added to Favorites";
      case "review_posted":
        return "Review Posted";
      default:
        return "Activity";
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d ago";
    } else {
      return "${timestamp.day}/${timestamp.month}/${timestamp.year}";
    }
  }
}
