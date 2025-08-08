import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';

class BusinessContactSection extends StatelessWidget {
  final String phone;
  final String email;
  final String website;
  final String address;

  const BusinessContactSection({
    super.key,
    required this.phone,
    required this.email,
    required this.website,
    required this.address,
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
            'Contact Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 2.h),

          // Phone
          if (phone.isNotEmpty)
            _ContactItem(
              icon: 'phone',
              title: 'Phone',
              value: phone,
              onTap: () => _makePhoneCall(phone),
              onLongPress: () =>
                  _copyToClipboard(context, phone, 'Phone number'),
            ),

          // Email
          if (email.isNotEmpty)
            _ContactItem(
              icon: 'email',
              title: 'Email',
              value: email,
              onTap: () => _sendEmail(email),
              onLongPress: () =>
                  _copyToClipboard(context, email, 'Email address'),
            ),

          // Website
          if (website.isNotEmpty)
            _ContactItem(
              icon: 'language',
              title: 'Website',
              value: website,
              onTap: () => _openWebsite(website),
              onLongPress: () =>
                  _copyToClipboard(context, website, 'Website URL'),
            ),

          // Address
          if (address.isNotEmpty)
            _ContactItem(
              icon: 'location_on',
              title: 'Address',
              value: address,
              onTap: () => _openMaps(address),
              onLongPress: () => _copyToClipboard(context, address, 'Address'),
              isMultiline: true,
            ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _sendEmail(String emailAddress) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: emailAddress);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
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

  Future<void> _openMaps(String address) async {
    final Uri mapsUri = Uri.parse(
        'https://maps.google.com/search?api=1&query=${Uri.encodeComponent(address)}');
    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
    }
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isMultiline;

  const _ContactItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
    required this.onLongPress,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: isMultiline
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.actionRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.actionRed,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: isMultiline ? 3 : 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
