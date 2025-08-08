import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/business_action_buttons.dart';
import './widgets/business_contact_section.dart';
import './widgets/business_description_section.dart';
import './widgets/business_header_info.dart';
import './widgets/business_hero_carousel.dart';
import './widgets/business_hours_section.dart';
import './widgets/business_reviews_section.dart';
import './widgets/qr_code_section.dart';

class BusinessDetail extends StatefulWidget {
  const BusinessDetail({super.key});

  @override
  State<BusinessDetail> createState() => _BusinessDetailState();
}

class _BusinessDetailState extends State<BusinessDetail> {
  final ScrollController _scrollController = ScrollController();
  bool _isFavorite = false;
  bool _isBusinessOwner = false;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  // Mock business data
  final Map<String, dynamic> _businessData = {
    "id": "business_001",
    "name": "Café Bratislava",
    "description":
        "Welcome to Café Bratislava, your cozy neighborhood coffee shop in the heart of Slovakia's capital. We serve freshly roasted coffee beans sourced from sustainable farms around the world, paired with homemade pastries and light meals. Our warm atmosphere makes it the perfect place for meetings, studying, or simply enjoying a quiet moment with friends. We pride ourselves on supporting local community values and providing exceptional service to every customer.",
    "images": [
      "https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1559925393-8be0ec4767c8?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1521017432531-fbd92d768814?w=800&h=600&fit=crop",
    ],
    "rating": 4.7,
    "reviewCount": 142,
    "category": "Restaurant • Coffee Shop",
    "isOpen": true,
    "phone": "+421 2 1234 5678",
    "email": "info@cafebratislava.sk",
    "website": "www.cafebratislava.sk",
    "address": "Hlavné námestie 1, 811 01 Bratislava, Slovakia",
    "openingHours": {
      "Monday": {"open": "07:00", "close": "19:00"},
      "Tuesday": {"open": "07:00", "close": "19:00"},
      "Wednesday": {"open": "07:00", "close": "19:00"},
      "Thursday": {"open": "07:00", "close": "19:00"},
      "Friday": {"open": "07:00", "close": "20:00"},
      "Saturday": {"open": "08:00", "close": "20:00"},
      "Sunday": {"open": "09:00", "close": "18:00"},
    },
    "reviews": [
      {
        "userName": "Mária Novák",
        "rating": 5.0,
        "comment":
            "Excellent coffee and friendly staff! The atmosphere is perfect for working or meeting friends. Highly recommend their homemade cakes.",
        "date": DateTime.now().subtract(const Duration(days: 3)),
        "userAvatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      },
      {
        "userName": "Peter Kováč",
        "rating": 4.0,
        "comment":
            "Great location in the city center. Coffee quality is consistently good, though it can get quite busy during lunch hours.",
        "date": DateTime.now().subtract(const Duration(days: 7)),
        "userAvatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      },
      {
        "userName": "Anna Svoboda",
        "rating": 5.0,
        "comment":
            "Love this place! Perfect for studying with good WiFi and comfortable seating. The ValueConnect discount is a nice bonus too.",
        "date": DateTime.now().subtract(const Duration(days: 12)),
        "userAvatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      },
      {
        "userName": "Tomáš Horváth",
        "rating": 4.0,
        "comment":
            "Solid coffee shop with good service. The pastries are fresh and the staff is always welcoming.",
        "date": DateTime.now().subtract(const Duration(days: 18)),
        "userAvatar": null,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      // Handle camera initialization error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero Image Carousel
          SliverToBoxAdapter(
            child: BusinessHeroCarousel(
              images: (_businessData['images'] as List).cast<String>(),
              businessName: _businessData['name'] as String,
            ),
          ),

          // Business Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Header Info (Sticky-like behavior with business name, rating, favorite)
                BusinessHeaderInfo(
                  businessName: _businessData['name'] as String,
                  rating: _businessData['rating'] as double,
                  reviewCount: _businessData['reviewCount'] as int,
                  category: _businessData['category'] as String,
                  isOpen: _businessData['isOpen'] as bool,
                  isFavorite: _isFavorite,
                  onFavoriteToggle: _toggleFavorite,
                ),

                // Description Section
                BusinessDescriptionSection(
                  description: _businessData['description'] as String,
                ),

                // QR Code Section (Primary Action)
                QRCodeSection(
                  businessId: _businessData['id'] as String,
                  businessName: _businessData['name'] as String,
                  isBusinessOwner: _isBusinessOwner,
                  onShowQRCode: _showQRCode,
                  onScanQRCode: _scanQRCode,
                ),

                // Contact Information
                BusinessContactSection(
                  phone: _businessData['phone'] as String,
                  email: _businessData['email'] as String,
                  website: _businessData['website'] as String,
                  address: _businessData['address'] as String,
                ),

                // Opening Hours
                BusinessHoursSection(
                  openingHours:
                      (_businessData['openingHours'] as Map<String, dynamic>)
                          .map((key, value) => MapEntry(
                              key,
                              (value as Map<String, dynamic>)
                                  .cast<String, String>())),
                  isOpen: _businessData['isOpen'] as bool,
                ),

                // Action Buttons (Secondary Actions)
                BusinessActionButtons(
                  phone: _businessData['phone'] as String,
                  website: _businessData['website'] as String,
                  address: _businessData['address'] as String,
                  businessName: _businessData['name'] as String,
                ),

                // Reviews Section
                BusinessReviewsSection(
                  rating: _businessData['rating'] as double,
                  reviewCount: _businessData['reviewCount'] as int,
                  reviews: (_businessData['reviews'] as List)
                      .cast<Map<String, dynamic>>(),
                ),

                // Bottom Padding
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite ? 'Added to favorites' : 'Removed from favorites',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showQRCode() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _QRCodeBottomSheet(
        businessId: _businessData['id'] as String,
        businessName: _businessData['name'] as String,
      ),
    );
  }

  Future<void> _scanQRCode() async {
    // Request camera permission
    final permission = await Permission.camera.request();
    if (!permission.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera permission is required to scan QR codes'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (_cameras == null || _cameras!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No camera available on this device'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Navigate to QR scanner screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _QRScannerScreen(
          cameras: _cameras!,
          businessName: _businessData['name'] as String,
        ),
      ),
    );
  }
}

class _QRCodeBottomSheet extends StatelessWidget {
  final String businessId;
  final String businessName;

  const _QRCodeBottomSheet({
    required this.businessId,
    required this.businessName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          SizedBox(height: 3.h),

          Text(
            'Your Discount QR Code',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 1.h),

          Text(
            'Show this code at $businessName to get 10% off',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // QR Code Placeholder
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: AppTheme.pureWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'qr_code',
                  color: AppTheme.primaryDark,
                  size: 120,
                ),
                SizedBox(height: 2.h),
                Text(
                  'QR Code',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

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
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '10% ValueConnect Discount',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.successGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Valid for one-time use at this business',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.successGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Close Button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}

class _QRScannerScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String businessName;

  const _QRScannerScreen({
    required this.cameras,
    required this.businessName,
  });

  @override
  State<_QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<_QRScannerScreen> {
  CameraController? _cameraController;
  bool _isInitialized = false;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final camera = widget.cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => widget.cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      // Handle camera initialization error
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to initialize camera'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.pureWhite,
            size: 24,
          ),
        ),
        title: Text(
          'Scan Customer QR Code',
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppTheme.pureWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isInitialized
          ? Stack(
              children: [
                // Camera Preview
                Positioned.fill(
                  child: CameraPreview(_cameraController!),
                ),

                // Scanning Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Scanning Frame
                        Container(
                          width: 60.w,
                          height: 60.w,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.pureWhite,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            margin: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme.actionRed,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),

                        SizedBox(height: 4.h),

                        Text(
                          'Position QR code within the frame',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.pureWhite,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 2.h),

                        Text(
                          'Scanning for ValueConnect discount codes...',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.pureWhite.withValues(alpha: 0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // Mock scan success after 3 seconds
                if (_isScanning)
                  FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 3)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _showScanResult();
                        });
                      }
                      return const SizedBox.shrink();
                    },
                  ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(
                color: AppTheme.actionRed,
              ),
            ),
    );
  }

  void _showScanResult() {
    if (!_isScanning) return;

    setState(() {
      _isScanning = false;
    });

    HapticFeedback.heavyImpact();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.successGreen,
              size: 24,
            ),
            SizedBox(width: 2.w),
            const Text('QR Code Scanned'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Customer: Mária Novák'),
            SizedBox(height: 1.h),
            const Text('Discount: 10% ValueConnect'),
            SizedBox(height: 1.h),
            Text(
              'Valid until: ${DateTime.now().add(const Duration(minutes: 15)).toString().substring(11, 16)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close scanner
            },
            child: const Text('Apply Discount'),
          ),
        ],
      ),
    );
  }
}
