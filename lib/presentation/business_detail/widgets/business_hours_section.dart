import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BusinessHoursSection extends StatefulWidget {
  final Map<String, Map<String, String>> openingHours;
  final bool isOpen;

  const BusinessHoursSection({
    super.key,
    required this.openingHours,
    required this.isOpen,
  });

  @override
  State<BusinessHoursSection> createState() => _BusinessHoursSectionState();
}

class _BusinessHoursSectionState extends State<BusinessHoursSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final today = _getCurrentDay();

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Opening Hours',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),

              // Current Status
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
                      widget.isOpen ? 'Open now' : 'Closed now',
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

          SizedBox(height: 2.h),

          // Today's Hours (Always Visible)
          _buildHourRow(
            context,
            today,
            widget.openingHours[today] ?? {'open': 'Closed', 'close': ''},
            isToday: true,
            theme: theme,
            colorScheme: colorScheme,
          ),

          // Expandable Hours List
          AnimatedCrossFade(
            firstChild: GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = true;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Show all hours',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.actionRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: 'expand_more',
                      color: AppTheme.actionRed,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            secondChild: Column(
              children: [
                SizedBox(height: 1.h),
                ...widget.openingHours.entries
                    .where((entry) => entry.key != today)
                    .map((entry) => _buildHourRow(
                          context,
                          entry.key,
                          entry.value,
                          isToday: false,
                          theme: theme,
                          colorScheme: colorScheme,
                        )),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Show less',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.actionRed,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        CustomIconWidget(
                          iconName: 'expand_less',
                          color: AppTheme.actionRed,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildHourRow(
    BuildContext context,
    String day,
    Map<String, String> hours, {
    required bool isToday,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    final openTime = hours['open'] ?? 'Closed';
    final closeTime = hours['close'] ?? '';
    final isClosed = openTime == 'Closed';

    String hoursText;
    if (isClosed) {
      hoursText = 'Closed';
    } else {
      hoursText = '$openTime - $closeTime';
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isToday
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant,
              fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            hoursText,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isClosed
                  ? AppTheme.actionRed
                  : (isToday
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant),
              fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentDay() {
    final now = DateTime.now();
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[now.weekday - 1];
  }
}
