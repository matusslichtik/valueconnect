import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BusinessHeaderInfo extends StatefulWidget {
  final String businessName;
  final double rating;
  final int reviewCount;
  final String category;
  final bool isOpen;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const BusinessHeaderInfo({
    super.key,
    required this.businessName,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.isOpen,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  State<BusinessHeaderInfo> createState() => _BusinessHeaderInfoState();
}

class _BusinessHeaderInfoState extends State<BusinessHeaderInfo> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Business Name and Favorite Button
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.businessName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 2.w),
              GestureDetector(
                onTap: widget.onFavoriteToggle,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: widget.isFavorite
                        ? AppTheme.actionRed.withValues(alpha: 0.1)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName:
                        widget.isFavorite ? 'favorite' : 'favorite_border',
                    color: widget.isFavorite
                        ? AppTheme.actionRed
                        : colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Rating and Category Row
          Row(
            children: [
              // Rating
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      color: AppTheme.successGreen,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      widget.rating.toStringAsFixed(1),
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.successGreen,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 2.w),

              // Review Count
              Text(
                '(${widget.reviewCount} reviews)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const Spacer(),

              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: widget.isOpen
                      ? AppTheme.successGreen.withValues(alpha: 0.1)
                      : AppTheme.actionRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        color: widget.isOpen
                            ? AppTheme.successGreen
                            : AppTheme.actionRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      widget.isOpen ? 'Open' : 'Closed',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: widget.isOpen
                            ? AppTheme.successGreen
                            : AppTheme.actionRed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Category
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              widget.category,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
