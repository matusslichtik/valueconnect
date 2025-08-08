import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QRCodeSection extends StatelessWidget {
  final String businessId;
  final String businessName;
  final bool isBusinessOwner;
  final VoidCallback onShowQRCode;
  final VoidCallback onScanQRCode;

  const QRCodeSection({
    super.key,
    required this.businessId,
    required this.businessName,
    required this.isBusinessOwner,
    required this.onShowQRCode,
    required this.onScanQRCode,
  });

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
            isBusinessOwner ? 'QR Code Actions' : 'Get Your Discount',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          if (!isBusinessOwner) ...[
            // Customer QR Code Button
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  onShowQRCode();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.actionRed,
                  foregroundColor: AppTheme.pureWhite,
                  elevation: 2,
                  shadowColor: colorScheme.shadow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'qr_code',
                      color: AppTheme.pureWhite,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Show QR Code for 10% Discount',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.pureWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Discount Info
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.successGreen.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'local_offer',
                    color: AppTheme.successGreen,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Show this QR code at checkout to receive your 10% ValueConnect discount',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.successGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Business Owner Scan Button
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  onScanQRCode();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.actionRed,
                  foregroundColor: AppTheme.pureWhite,
                  elevation: 2,
                  shadowColor: colorScheme.shadow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'qr_code_scanner',
                      color: AppTheme.pureWhite,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Scan Customer QR Code',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.pureWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Business Owner Info
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryDark.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryDark.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.primaryDark,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Scan customer QR codes to validate their 10% ValueConnect discount',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
