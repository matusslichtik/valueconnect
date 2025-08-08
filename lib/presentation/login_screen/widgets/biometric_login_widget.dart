import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricLoginWidget extends StatefulWidget {
  final VoidCallback? onBiometricLogin;
  final bool isAvailable;
  final String biometricType;

  const BiometricLoginWidget({
    super.key,
    this.onBiometricLogin,
    this.isAvailable = false,
    this.biometricType = 'fingerprint',
  });

  @override
  State<BiometricLoginWidget> createState() => _BiometricLoginWidgetState();
}

class _BiometricLoginWidgetState extends State<BiometricLoginWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleBiometricLogin() async {
    if (!widget.isAvailable || _isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    _animationController.repeat(reverse: true);
    HapticFeedback.lightImpact();

    try {
      // Simulate biometric authentication delay
      await Future.delayed(const Duration(milliseconds: 500));
      widget.onBiometricLogin?.call();
    } finally {
      _animationController.stop();
      _animationController.reset();
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  IconData _getBiometricIcon() {
    switch (widget.biometricType.toLowerCase()) {
      case 'face':
      case 'faceid':
        return Icons.face;
      case 'fingerprint':
      case 'touchid':
        return Icons.fingerprint;
      default:
        return Icons.security;
    }
  }

  String _getBiometricLabel() {
    switch (widget.biometricType.toLowerCase()) {
      case 'face':
      case 'faceid':
        return 'Use Face ID';
      case 'fingerprint':
      case 'touchid':
        return 'Use Touch ID';
      default:
        return 'Use Biometric';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!widget.isAvailable) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(height: 3.h),

        // Biometric Login Button
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isAuthenticating ? _scaleAnimation.value : 1.0,
              child: Container(
                width: 16.w,
                height: 16.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isAuthenticating
                      ? AppTheme.actionRed.withValues(alpha: 0.1)
                      : colorScheme.surface,
                  border: Border.all(
                    color: _isAuthenticating
                        ? AppTheme.actionRed
                        : colorScheme.outline,
                    width: 2,
                  ),
                  boxShadow: _isAuthenticating
                      ? [
                          BoxShadow(
                            color: AppTheme.actionRed.withValues(alpha: 0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _handleBiometricLogin,
                    borderRadius: BorderRadius.circular(8.w),
                    child: Center(
                      child: _isAuthenticating
                          ? SizedBox(
                              width: 6.w,
                              height: 6.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.actionRed,
                                ),
                              ),
                            )
                          : CustomIconWidget(
                              iconName:
                                  _getBiometricIcon().codePoint.toString(),
                              color: _isAuthenticating
                                  ? AppTheme.actionRed
                                  : colorScheme.onSurface,
                              size: 8.w,
                            ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        SizedBox(height: 2.h),

        // Biometric Label
        Text(
          _getBiometricLabel(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
