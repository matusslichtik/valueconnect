import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_logo_widget.dart';
import './widgets/biometric_login_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _isBiometricAvailable = false;
  String _biometricType = 'fingerprint';
  String? _errorMessage;

  final List<Map<String, dynamic>> _mockUsers = [
    {
      "id": 1,
      "email": "user@valueconnect.sk",
      "phone": "+421901234567",
      "password": "password123",
      "role": "user",
      "name": "Ján Novák",
      "isVerified": true,
      "lastLogin": DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      "id": 2,
      "email": "business@valueconnect.sk",
      "phone": "+421907654321",
      "password": "business123",
      "role": "business_owner",
      "name": "Mária Svobodová",
      "businessName": "Café Central",
      "isVerified": true,
      "lastLogin": DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      "id": 3,
      "email": "admin@valueconnect.sk",
      "phone": "+421905555555",
      "password": "admin123",
      "role": "admin",
      "name": "Admin User",
      "isVerified": true,
      "lastLogin": DateTime.now().subtract(const Duration(minutes: 30)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _loadSavedCredentials();
  }

  Future<void> _checkBiometricAvailability() async {
    // Simulate checking biometric availability
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _isBiometricAvailable = true;
        _biometricType = 'fingerprint'; // Could be 'face' for Face ID
      });
    }
  }

  Future<void> _loadSavedCredentials() async {
    // Simulate loading saved email/username from secure storage
    await Future.delayed(const Duration(milliseconds: 300));
    // Implementation would load from SharedPreferences or secure storage
  }

  Future<void> _handleLogin(String emailOrPhone, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Find matching user
      final user = (_mockUsers as List).firstWhere(
        (dynamic userData) {
          final userMap = userData as Map<String, dynamic>;
          final email = userMap["email"] as String;
          final phone = userMap["phone"] as String;
          final userPassword = userMap["password"] as String;

          return (email == emailOrPhone || phone == emailOrPhone) &&
              userPassword == password;
        },
        orElse: () => null,
      );

      if (user == null) {
        throw Exception('Invalid credentials');
      }

      final userMap = user as Map<String, dynamic>;
      final isVerified = userMap["isVerified"] as bool;

      if (!isVerified) {
        throw Exception('Account not verified');
      }

      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      // Navigate based on user role and onboarding status
      final role = userMap["role"] as String;
      await _navigateBasedOnRole(role);
    } catch (e) {
      HapticFeedback.heavyImpact();
      setState(() {
        _errorMessage = _getErrorMessage(e.toString());
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('Invalid credentials')) {
      return 'Invalid email/phone or password. Please try again.';
    } else if (error.contains('Account not verified')) {
      return 'Please verify your account before logging in.';
    } else if (error.contains('Account locked')) {
      return 'Your account has been temporarily locked. Please try again later.';
    } else if (error.contains('network') || error.contains('connection')) {
      return 'Network connection error. Please check your internet connection.';
    } else {
      return 'Login failed. Please try again.';
    }
  }

  Future<void> _navigateBasedOnRole(String role) async {
    switch (role) {
      case 'user':
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home-dashboard',
          (route) => false,
        );
        break;
      case 'business_owner':
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/business-dashboard',
          (route) => false,
        );
        break;
      case 'admin':
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/admin-dashboard',
          (route) => false,
        );
        break;
      default:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home-dashboard',
          (route) => false,
        );
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate social login process
      await Future.delayed(const Duration(milliseconds: 2000));

      // Simulate successful social login
      HapticFeedback.lightImpact();

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home-dashboard',
        (route) => false,
      );
    } catch (e) {
      HapticFeedback.heavyImpact();
      setState(() {
        _errorMessage = 'Social login failed. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleBiometricLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate biometric authentication
      await Future.delayed(const Duration(milliseconds: 1000));

      HapticFeedback.lightImpact();

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home-dashboard',
        (route) => false,
      );
    } catch (e) {
      HapticFeedback.heavyImpact();
      setState(() {
        _errorMessage = 'Biometric authentication failed. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 8.h),

                  // App Logo and Title
                  const AppLogoWidget(
                    showTitle: true,
                    animated: true,
                  ),

                  SizedBox(height: 6.h),

                  // Error Message
                  if (_errorMessage != null) ...[
                    Container(
                      width: 90.w,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.errorLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.actionRed.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'error',
                            color: AppTheme.actionRed,
                            size: 20,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.actionRed,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                  ],

                  // Login Form
                  LoginFormWidget(
                    onLogin: _handleLogin,
                    isLoading: _isLoading,
                  ),

                  SizedBox(height: 4.h),

                  // Social Login Options
                  SocialLoginWidget(
                    onGoogleLogin: () => _handleSocialLogin('google'),
                    onAppleLogin: () => _handleSocialLogin('apple'),
                    isLoading: _isLoading,
                  ),

                  // Biometric Login
                  BiometricLoginWidget(
                    onBiometricLogin: _handleBiometricLogin,
                    isAvailable: _isBiometricAvailable,
                    biometricType: _biometricType,
                  ),

                  SizedBox(height: 4.h),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New user? ',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                Navigator.pushNamed(
                                    context, '/registration-screen');
                              },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                        ),
                        child: Text(
                          'Sign Up',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.actionRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}