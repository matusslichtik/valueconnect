import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/location_header_widget.dart';
import './widgets/nearby_business_card_widget.dart';
import './widgets/qr_code_card_widget.dart';
import './widgets/quick_action_button_widget.dart';
import './widgets/recent_activity_item_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;
  String _currentCity = "Bratislava";
  int _notificationCount = 3;

  // Mock data for nearby businesses
  final List<Map<String, dynamic>> _nearbyBusinesses = [
    {
      "id": 1,
      "name": "Café Central",
      "category": "Restaurant & Café",
      "image":
          "https://images.pexels.com/photos/302899/pexels-photo-302899.jpeg?auto=compress&cs=tinysrgb&w=800",
      "distance": 0.3,
      "rating": 4.8,
      "isOpen": true,
      "isFavorite": false,
    },
    {
      "id": 2,
      "name": "Tech Store Slovakia",
      "category": "Electronics",
      "image":
          "https://images.pexels.com/photos/356056/pexels-photo-356056.jpeg?auto=compress&cs=tinysrgb&w=800",
      "distance": 0.7,
      "rating": 4.5,
      "isOpen": true,
      "isFavorite": true,
    },
    {
      "id": 3,
      "name": "Wellness Spa Bratislava",
      "category": "Health & Beauty",
      "image":
          "https://images.pexels.com/photos/3757942/pexels-photo-3757942.jpeg?auto=compress&cs=tinysrgb&w=800",
      "distance": 1.2,
      "rating": 4.9,
      "isOpen": false,
      "isFavorite": false,
    },
    {
      "id": 4,
      "name": "Local Bookstore",
      "category": "Shopping",
      "image":
          "https://images.pexels.com/photos/1370295/pexels-photo-1370295.jpeg?auto=compress&cs=tinysrgb&w=800",
      "distance": 0.5,
      "rating": 4.6,
      "isOpen": true,
      "isFavorite": false,
    },
  ];

  // Mock data for recent activities
  final List<Map<String, dynamic>> _recentActivities = [
    {
      "id": 1,
      "type": "discount_used",
      "businessName": "Café Central",
      "amount": "-€2.50",
      "description": "10% discount applied on coffee and pastry",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      "id": 2,
      "type": "business_discovered",
      "businessName": "Tech Store Slovakia",
      "amount": "",
      "description": "New electronics store added to your area",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      "id": 3,
      "type": "favorite_added",
      "businessName": "Wellness Spa Bratislava",
      "amount": "",
      "description": "Added to your favorites list",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    // Simulate loading user location and nearby businesses
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        // Data is already loaded in mock arrays
      });
    }
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh with haptic feedback
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        // Update notification count or other dynamic data
        _notificationCount = (_notificationCount + 1) % 10;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: colorScheme.secondary,
        backgroundColor: colorScheme.surface,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Sticky Header
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeaderDelegate(
                child: LocationHeaderWidget(
                  currentCity: _currentCity,
                  onLocationTap: _showLocationSelector,
                  onNotificationTap: _showNotifications,
                  notificationCount: _notificationCount,
                ),
              ),
            ),

            // Main Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // QR Code Card
                  QrCodeCardWidget(
                    onShowQrCode: _showQrCode,
                  ),

                  // Nearby Businesses Section
                  _buildNearbyBusinessesSection(),

                  // Quick Actions Section
                  _buildQuickActionsSection(),

                  // Recent Activity Section
                  _buildRecentActivitySection(),

                  // Bottom padding for navigation
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyBusinessesSection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Nearby Businesses',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/business-search'),
                child: Text(
                  'View All',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 35.h,
          child: _nearbyBusinesses.isEmpty
              ? _buildEmptyBusinessesState()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: _nearbyBusinesses.length,
                  itemBuilder: (context, index) {
                    final business = _nearbyBusinesses[index];
                    return NearbyBusinessCardWidget(
                      business: business,
                      onTap: () => _navigateToBusinessDetail(business),
                      onFavorite: () => _toggleFavorite(business),
                      onShare: () => _shareBusiness(business),
                      onDirections: () => _getDirections(business),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              QuickActionButtonWidget(
                iconName: 'search',
                title: 'Find Businesses',
                subtitle: 'Discover nearby',
                onTap: () => Navigator.pushNamed(context, '/business-search'),
              ),
              SizedBox(width: 3.w),
              QuickActionButtonWidget(
                iconName: 'qr_code_scanner',
                title: 'Scan QR',
                subtitle: 'Validate discount',
                onTap: _scanQrCode,
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Row(
            children: [
              QuickActionButtonWidget(
                iconName: 'favorite',
                title: 'My Favorites',
                subtitle: 'Saved businesses',
                onTap: _showFavorites,
                iconColor: Colors.pink,
              ),
              SizedBox(width: 3.w),
              QuickActionButtonWidget(
                iconName: 'history',
                title: 'Transaction History',
                subtitle: 'View purchases',
                onTap: _showTransactionHistory,
                iconColor: colorScheme.tertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          _recentActivities.isEmpty
              ? _buildEmptyActivityState()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recentActivities.length,
                  itemBuilder: (context, index) {
                    final activity = _recentActivities[index];
                    return RecentActivityItemWidget(
                      activity: activity,
                      onTap: () => _viewActivityDetail(activity),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyBusinessesState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'store',
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 15.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'No businesses nearby',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try expanding your search area or check back later',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/business-search'),
              child: const Text('Search Businesses'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyActivityState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'history',
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 12.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'No recent activity',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Start using discounts to see your activity here',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Action Methods
  void _showQrCode() {
    // Navigate to QR code display screen or show modal
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'qr_code',
                  color: Colors.black,
                  size: 40.w,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            const Text(
              'Show this code to the business owner to get your 10% discount',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLocationSelector() {
    final cities = [
      'Bratislava',
      'Košice',
      'Prešov',
      'Žilina',
      'Banská Bystrica',
      'Nitra',
      'Trnava',
      'Trenčín'
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 3.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select City',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            ...cities.map((city) => ListTile(
                  title: Text(city),
                  trailing:
                      _currentCity == city ? const Icon(Icons.check) : null,
                  onTap: () {
                    setState(() {
                      _currentCity = city;
                    });
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showNotifications() {
    // Navigate to notifications screen or show modal
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text('You have 3 new notifications'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _navigateToBusinessDetail(Map<String, dynamic> business) {
    Navigator.pushNamed(
      context,
      '/business-detail',
      arguments: business,
    );
  }

  void _toggleFavorite(Map<String, dynamic> business) {
    setState(() {
      business["isFavorite"] = !(business["isFavorite"] as bool? ?? false);
    });
  }

  void _shareBusiness(Map<String, dynamic> business) {
    // Implement share functionality
  }

  void _getDirections(Map<String, dynamic> business) {
    // Implement directions functionality
  }

  void _scanQrCode() {
    // Navigate to QR scanner screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Scanner'),
        content: const Text(
            'QR code scanner functionality would be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFavorites() {
    // Navigate to favorites screen
  }

  void _showTransactionHistory() {
    // Navigate to transaction history screen
  }

  void _viewActivityDetail(Map<String, dynamic> activity) {
    // Navigate to activity detail or show more info
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 80.0;

  @override
  double get maxExtent => 80.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
