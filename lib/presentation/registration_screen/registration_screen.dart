import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/app_logo_widget.dart';
import './widgets/login_redirect_widget.dart';
import './widgets/registration_form_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _selectedRole = 'User';
  bool _isTermsAccepted = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  void _onRoleChanged(String role) {
    setState(() {
      _selectedRole = role;
    });
  }

  void _onTermsChanged(bool accepted) {
    setState(() {
      _isTermsAccepted = accepted;
    });
  }

  bool _isFormValid() {
    return _formKey.currentState?.validate() == true &&
        _isTermsAccepted &&
        _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;
  }

  Future<void> _createAccount() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (!_isFormValid()) {
      _showErrorMessage(
          'Please fill in all required fields and accept the terms.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock registration data
      final registrationData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'role': _selectedRole,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Simulate successful registration
      final isSuccess = _simulateRegistration(registrationData);

      if (isSuccess) {
        // Haptic feedback for success
        HapticFeedback.lightImpact();

        _showSuccessMessage(
            'Account created successfully! Please check your email for verification.');

        // Navigate to verification or login screen
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login-screen');
        }
      } else {
        _showErrorMessage('Registration failed. Please try again.');
      }
    } catch (e) {
      _showErrorMessage(
          'Network error. Please check your connection and try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _simulateRegistration(Map<String, dynamic> data) {
    // Mock validation - simulate duplicate email check
    final email = data['email'] as String;
    final mockExistingEmails = [
      'test@example.com',
      'admin@valueconnect.sk',
      'demo@test.com'
    ];

    if (mockExistingEmails.contains(email.toLowerCase())) {
      _showErrorMessage('An account with this email already exists.');
      return false;
    }

    // Mock phone validation
    final phone = data['phone'] as String;
    if (phone.length < 10) {
      _showErrorMessage('Please enter a valid phone number.');
      return false;
    }

    return true;
  }

  void _showSuccessMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.successGreen,
      textColor: AppTheme.pureWhite,
      fontSize: 14,
    );
  }

  void _showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.actionRed,
      textColor: AppTheme.pureWhite,
      fontSize: 14,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 4.h),

                    // App Logo
                    const AppLogoWidget(),

                    SizedBox(height: 4.h),

                    // Welcome Text
                    Text(
                      'Create Your Account',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 1.h),

                    Text(
                      'Join the ValueConnect community and discover local businesses that share your values.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 4.h),

                    // Registration Form
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow
                                .withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: RegistrationFormWidget(
                        formKey: _formKey,
                        firstNameController: _firstNameController,
                        lastNameController: _lastNameController,
                        emailController: _emailController,
                        phoneController: _phoneController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        selectedRole: _selectedRole,
                        isTermsAccepted: _isTermsAccepted,
                        isPasswordVisible: _isPasswordVisible,
                        isConfirmPasswordVisible: _isConfirmPasswordVisible,
                        onRoleChanged: _onRoleChanged,
                        onTermsChanged: _onTermsChanged,
                        onPasswordVisibilityToggle: _togglePasswordVisibility,
                        onConfirmPasswordVisibilityToggle:
                            _toggleConfirmPasswordVisibility,
                        onCreateAccount: _createAccount,
                        isLoading: _isLoading,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Login Redirect
                    const LoginRedirectWidget(),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
