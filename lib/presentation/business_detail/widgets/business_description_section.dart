import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BusinessDescriptionSection extends StatefulWidget {
  final String description;

  const BusinessDescriptionSection({
    super.key,
    required this.description,
  });

  @override
  State<BusinessDescriptionSection> createState() =>
      _BusinessDescriptionSectionState();
}

class _BusinessDescriptionSectionState
    extends State<BusinessDescriptionSection> {
  bool _isExpanded = false;
  static const int _maxLines = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          AnimatedCrossFade(
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    height: 1.5,
                  ),
                  maxLines: _maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
                if (_shouldShowReadMore())
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = true;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 1.h),
                      child: Text(
                        'Read more',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.actionRed,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    height: 1.5,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = false;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Text(
                      'Show less',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.actionRed,
                        fontWeight: FontWeight.w500,
                      ),
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

  bool _shouldShowReadMore() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.description,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      maxLines: _maxLines,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: 92.w - 8.w); // Account for padding
    return textPainter.didExceedMaxLines;
  }
}
