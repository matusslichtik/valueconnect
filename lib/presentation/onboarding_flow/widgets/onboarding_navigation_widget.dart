import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingNavigationWidget extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final bool isLastStep;
  final bool canGoBack;
  final VoidCallback? onBack;

  const OnboardingNavigationWidget({
    super.key,
    required this.onNext,
    required this.onSkip,
    this.isLastStep = false,
    this.canGoBack = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main action button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.actionRed,
                foregroundColor: AppTheme.pureWhite,
                elevation: 2,
                shadowColor: AppTheme.shadowLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isLastStep ? 'Get Started' : 'Next',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.pureWhite,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          // Secondary actions row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button (if applicable)
              canGoBack
                  ? TextButton.icon(
                      onPressed: onBack,
                      icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.mediumGray,
                        size: 18,
                      ),
                      label: Text(
                        'Back',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.mediumGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                      ),
                    )
                  : const SizedBox.shrink(),
              // Skip button
              TextButton(
                onPressed: onSkip,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                ),
                child: Text(
                  'Skip',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.mediumGray,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
