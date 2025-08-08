import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/onboarding_navigation_widget.dart';
import './widgets/onboarding_step_widget.dart';
import './widgets/progress_indicator_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Mock data for onboarding steps
  final List<Map<String, dynamic>> _onboardingSteps = [
    {
      "title": "Welcome to ValueConnect",
      "description":
          "Join a community of value-aligned businesses and customers. Discover local entrepreneurs who share your values and support meaningful commerce in Slovakia.",
      "imageUrl":
          "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "title": "Instant 10% Discounts",
      "description":
          "Enjoy standardized 10% discounts at participating businesses. Simply scan QR codes to validate your purchases and unlock exclusive savings instantly.",
      "imageUrl":
          "https://images.unsplash.com/photo-1556742111-a301076d9d18?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "title": "Discover Local Businesses",
      "description":
          "Find amazing businesses near you with our interactive Slovakia map. Search by category, filter by ratings, and explore what your community has to offer.",
      "imageUrl":
          "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "title": "Build Your Profile",
      "description":
          "Create your personalized profile, track your favorite businesses, and build a history of meaningful purchases that support your local community.",
      "imageUrl":
          "https://images.unsplash.com/photo-1556742111-a301076d9d18?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadOnboardingProgress();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _loadOnboardingProgress() {
    // In a real app, this would load from SharedPreferences
    // For now, we'll start from the beginning
    setState(() {
      _currentStep = 0;
    });
  }

  void _saveOnboardingProgress() {
    // In a real app, this would save to SharedPreferences
    // SharedPreferences.getInstance().then((prefs) {
    //   prefs.setInt('onboarding_step', _currentStep);
    // });
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _saveOnboardingProgress();
      _triggerHapticFeedback();
    } else {
      _completeOnboarding();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _saveOnboardingProgress();
      _triggerHapticFeedback();
    }
  }

  void _skipOnboarding() {
    _showSkipConfirmation();
  }

  void _completeOnboarding() {
    // Clear onboarding progress
    // SharedPreferences.getInstance().then((prefs) {
    //   prefs.remove('onboarding_step');
    //   prefs.setBool('onboarding_completed', true);
    // });

    Navigator.pushReplacementNamed(context, '/registration-screen');
  }

  void _triggerHapticFeedback() {
    HapticFeedback.lightImpact();
  }

  void _showSkipConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.pureWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Skip Onboarding?',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'You can always view this introduction later in your profile settings.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.mediumGray,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Continue Tour',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.mediumGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _completeOnboarding();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.actionRed,
                foregroundColor: AppTheme.pureWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Skip',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.pureWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handlePageChanged(int index) {
    setState(() {
      _currentStep = index;
    });
    _saveOnboardingProgress();
    _triggerHapticFeedback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                onPressed: _previousStep,
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.primaryDark,
                  size: 24,
                ),
                tooltip: 'Previous step',
              )
            : null,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/login-screen'),
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.mediumGray,
              size: 24,
            ),
            tooltip: 'Close onboarding',
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: [
          // Progress indicator
          ProgressIndicatorWidget(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
          ),
          // Main content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _handlePageChanged,
              itemCount: _totalSteps,
              itemBuilder: (context, index) {
                final step = _onboardingSteps[index];
                return OnboardingStepWidget(
                  title: step["title"] as String,
                  description: step["description"] as String,
                  imageUrl: step["imageUrl"] as String,
                  isLastStep: index == _totalSteps - 1,
                );
              },
            ),
          ),
          // Navigation controls
          SafeArea(
            child: OnboardingNavigationWidget(
              onNext: _nextStep,
              onSkip: _skipOnboarding,
              isLastStep: _currentStep == _totalSteps - 1,
              canGoBack: _currentStep > 0,
              onBack: _currentStep > 0 ? _previousStep : null,
            ),
          ),
        ],
      ),
    );
  }
}
