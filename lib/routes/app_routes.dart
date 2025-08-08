import 'package:flutter/material.dart';
import '../presentation/business_detail/business_detail.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/business_search/business_search.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/map_view_screen/map_view_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String businessDetail = '/business-detail';
  static const String homeDashboard = '/home-dashboard';
  static const String login = '/login-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String businessSearch = '/business-search';
  static const String registration = '/registration-screen';
  static const String mapViewScreen = '/map-view-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    businessDetail: (context) => const BusinessDetail(),
    homeDashboard: (context) => const HomeDashboard(),
    login: (context) => const LoginScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    businessSearch: (context) => const BusinessSearch(),
    registration: (context) => const RegistrationScreen(),
    mapViewScreen: (context) => const MapViewScreen(),
    // TODO: Add your other routes here
  };
}
