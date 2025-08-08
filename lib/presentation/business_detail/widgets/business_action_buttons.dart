import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class BusinessActionButtons extends StatelessWidget {
  final String phone;
  final String website;
  final String address;
  final String businessName;

  const BusinessActionButtons({
    super.key,
    required this.phone,
    required this.website,
    required this.address,
    required this.businessName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Row(
            children: [
              // Get Directions
              Expanded(
                child: _ActionButton(
                  icon: 'directions',
                  label: 'Directions',
                  onPressed: () => _openDirections(address),
                  theme: theme,
                  colorScheme: colorScheme,
                ),
              ),

              SizedBox(width: 2.w),

              // Call
              if (phone.isNotEmpty)
                Expanded(
                  child: _ActionButton(
                    icon: 'phone',
                    label: 'Call',
                    onPressed: () => _makePhoneCall(phone),
                    theme: theme,
                    colorScheme: colorScheme,
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              // Visit Website
              if (website.isNotEmpty)
                Expanded(
                  child: _ActionButton(
                    icon: 'language',
                    label: 'Website',
                    onPressed: () => _openWebsite(website),
                    theme: theme,
                    colorScheme: colorScheme,
                  ),
                ),

              if (website.isNotEmpty) SizedBox(width: 2.w),

              // Share Business
              Expanded(
                child: _ActionButton(
                  icon: 'share',
                  label: 'Share',
                  onPressed: () => _shareBusiness(context, businessName),
                  theme: theme,
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openDirections(String address) async {
    final Uri mapsUri = Uri.parse(
        'https://maps.google.com/search?api=1&query=${Uri.encodeComponent(address)}');
    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _openWebsite(String websiteUrl) async {
    String url = websiteUrl;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    final Uri websiteUri = Uri.parse(url);
    if (await canLaunchUrl(websiteUri)) {
      await launchUrl(websiteUri, mode: LaunchMode.externalApplication);
    }
  }

  void _shareBusiness(BuildContext context, String businessName) {
    HapticFeedback.lightImpact();

    // Show share options
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Share $businessName',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'content_copy',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: const Text('Copy Link'),
              onTap: () {
                Clipboard.setData(ClipboardData(
                    text: 'Check out $businessName on ValueConnect!'));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Link copied to clipboard'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              title: const Text('Share via Message'),
              onTap: () {
                Navigator.pop(context);
                _shareViaMessage(businessName);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Future<void> _shareViaMessage(String businessName) async {
    final Uri messageUri = Uri(
      scheme: 'sms',
      queryParameters: {
        'body':
            'Check out $businessName on ValueConnect! Get 10% discount with our community platform.',
      },
    );

    if (await canLaunchUrl(messageUri)) {
      await launchUrl(messageUri);
    }
  }
}

class _ActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onPressed;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.5),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: colorScheme.onSurface,
            size: 24,
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
