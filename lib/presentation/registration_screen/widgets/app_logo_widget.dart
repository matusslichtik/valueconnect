import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Logo Container
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'VC',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSecondary,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // App Name
        Text(
          'ValueConnect',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.25,
          ),
        ),

        SizedBox(height: 1.h),

        // Tagline
        Text(
          'Connect with value-aligned businesses',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: 0.25,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
