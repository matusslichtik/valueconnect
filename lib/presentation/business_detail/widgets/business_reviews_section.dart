import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BusinessReviewsSection extends StatefulWidget {
  final double rating;
  final int reviewCount;
  final List<Map<String, dynamic>> reviews;

  const BusinessReviewsSection({
    super.key,
    required this.rating,
    required this.reviewCount,
    required this.reviews,
  });

  @override
  State<BusinessReviewsSection> createState() => _BusinessReviewsSectionState();
}

class _BusinessReviewsSectionState extends State<BusinessReviewsSection> {
  bool _showAllReviews = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final displayReviews =
        _showAllReviews ? widget.reviews : widget.reviews.take(3).toList();

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                '${widget.reviewCount} reviews',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Rating Summary
          _buildRatingSummary(theme, colorScheme),

          SizedBox(height: 3.h),

          // Reviews List
          if (widget.reviews.isNotEmpty) ...[
            ...displayReviews.map((review) => _ReviewItem(
                  review: review,
                  theme: theme,
                  colorScheme: colorScheme,
                )),
            if (widget.reviews.length > 3)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showAllReviews = !_showAllReviews;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _showAllReviews
                            ? 'Show less reviews'
                            : 'Show all reviews',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.actionRed,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName:
                            _showAllReviews ? 'expand_less' : 'expand_more',
                        color: AppTheme.actionRed,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
          ] else
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'rate_review',
                    color: colorScheme.onSurfaceVariant,
                    size: 48,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'No reviews yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Be the first to leave a review for this business',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRatingSummary(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Overall Rating
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.rating.toStringAsFixed(1),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  CustomIconWidget(
                    iconName: 'star',
                    color: AppTheme.warningAmber,
                    size: 24,
                  ),
                ],
              ),
              SizedBox(height: 0.5.h),
              Text(
                '${widget.reviewCount} reviews',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          SizedBox(width: 4.w),

          // Rating Distribution
          Expanded(
            child: Column(
              children: List.generate(5, (index) {
                final starCount = 5 - index;
                final percentage = _calculateRatingPercentage(starCount);

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5.h),
                  child: Row(
                    children: [
                      Text(
                        '$starCount',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: 'star',
                        color: AppTheme.warningAmber,
                        size: 12,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor:
                              colorScheme.outline.withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.warningAmber),
                          minHeight: 0.5.h,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '${percentage.toInt()}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateRatingPercentage(int starCount) {
    if (widget.reviews.isEmpty) return 0.0;

    final count = widget.reviews
        .where((review) => (review['rating'] as double).round() == starCount)
        .length;
    return (count / widget.reviews.length) * 100;
  }
}

class _ReviewItem extends StatelessWidget {
  final Map<String, dynamic> review;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _ReviewItem({
    required this.review,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final rating = review['rating'] as double;
    final userName = review['userName'] as String;
    final comment = review['comment'] as String;
    final date = review['date'] as DateTime;
    final userAvatar = review['userAvatar'] as String?;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // User Avatar
              CircleAvatar(
                radius: 5.w,
                backgroundColor: colorScheme.surfaceContainerHighest,
                child: userAvatar != null
                    ? CustomImageWidget(
                        imageUrl: userAvatar,
                        width: 10.w,
                        height: 10.w,
                        fit: BoxFit.cover,
                      )
                    : CustomIconWidget(
                        iconName: 'person',
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
              ),

              SizedBox(width: 3.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        // Star Rating
                        Row(
                          children: List.generate(5, (index) {
                            return CustomIconWidget(
                              iconName: index < rating.round()
                                  ? 'star'
                                  : 'star_border',
                              color: AppTheme.warningAmber,
                              size: 16,
                            );
                          }),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          _formatDate(date),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            comment,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }
  }
}
