import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/business_info_card_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/map_controls_widget.dart';
import './widgets/map_search_header_widget.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen>
    with TickerProviderStateMixin {
  final Completer<GoogleMapController> _mapController = Completer();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _businessCardsController = ScrollController();

  int _currentBottomBarIndex = 1; // Map view is at index 1
  Position? _currentPosition;
  bool _isLocationEnabled = false;
  MapType _currentMapType = MapType.normal;
  double _currentZoom = 12.0;
  String _selectedCategory = 'All';
  double _selectedRadius = 5.0;
  double _selectedMinRating = 0.0;
  int _activeFilters = 0;

  Set<Marker> _markers = {};
  String? _selectedBusinessId;
  PageController _pageController = PageController();
  AnimationController? _infoCardAnimationController;
  Animation<Offset>? _infoCardSlideAnimation;

  // Mock business data for Slovakia
  final List<Map<String, dynamic>> _businessLocations = [
    {
      "id": "business_001",
      "name": "Café Bratislava",
      "description": "Cozy coffee shop in the heart of Slovakia's capital",
      "latitude": 48.1486,
      "longitude": 17.1077,
      "rating": 4.7,
      "reviewCount": 142,
      "category": "Coffee Shop",
      "categories": ["Coffee", "Restaurant", "WiFi"],
      "isOpen": true,
      "image":
          "https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=400&h=300&fit=crop",
      "distance": "0.5 km",
      "address": "Hlavné námestie 1, Bratislava",
      "phone": "+421 2 1234 5678",
    },
    {
      "id": "business_002",
      "name": "Slovak Traditional Restaurant",
      "description": "Authentic Slovak cuisine and hospitality",
      "latitude": 48.1516,
      "longitude": 17.1093,
      "rating": 4.5,
      "reviewCount": 89,
      "category": "Restaurant",
      "categories": ["Slovak Food", "Traditional", "Family"],
      "isOpen": true,
      "image":
          "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400&h=300&fit=crop",
      "distance": "0.8 km",
      "address": "Michalská 2, Bratislava",
      "phone": "+421 2 2345 6789",
    },
    {
      "id": "business_003",
      "name": "Kosice Wellness Spa",
      "description": "Relaxation and wellness in eastern Slovakia",
      "latitude": 48.7164,
      "longitude": 21.2611,
      "rating": 4.9,
      "reviewCount": 76,
      "category": "Wellness",
      "categories": ["Spa", "Wellness", "Massage"],
      "isOpen": false,
      "image":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop",
      "distance": "215 km",
      "address": "Hlavná 32, Košice",
      "phone": "+421 55 1234 567",
    },
    {
      "id": "business_004",
      "name": "High Tatras Hotel",
      "description": "Mountain resort with stunning views",
      "latitude": 49.1192,
      "longitude": 20.2151,
      "rating": 4.3,
      "reviewCount": 156,
      "category": "Hotel",
      "categories": ["Hotel", "Mountain", "Resort"],
      "isOpen": true,
      "image":
          "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop",
      "distance": "95 km",
      "address": "Vysoké Tatry 123, Slovakia",
      "phone": "+421 52 7890 123",
    },
    {
      "id": "business_005",
      "name": "Nitra Shopping Center",
      "description": "Modern shopping center with local brands",
      "latitude": 48.3081,
      "longitude": 18.0711,
      "rating": 4.2,
      "reviewCount": 234,
      "category": "Shopping",
      "categories": ["Shopping", "Retail", "Food Court"],
      "isOpen": true,
      "image":
          "https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&h=300&fit=crop",
      "distance": "78 km",
      "address": "Podzámska 32, Nitra",
      "phone": "+421 37 4567 890",
    }
  ];

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(48.1486, 17.1077), // Bratislava, Slovakia
    zoom: 12.0,
  );

  @override
  void initState() {
    super.initState();
    _infoCardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _infoCardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _infoCardAnimationController!,
      curve: Curves.easeInOut,
    ));

    _getCurrentLocation();
    _createMarkersFromBusinesses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _businessCardsController.dispose();
    _pageController.dispose();
    _infoCardAnimationController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _currentPosition = position;
        _isLocationEnabled = true;
      });
    } catch (e) {
      // Handle location errors silently
    }
  }

  Future<void> _createMarkersFromBusinesses() async {
    Set<Marker> markers = {};

    for (final business in _businessLocations) {
      final BitmapDescriptor markerIcon = await _getCustomMarkerIcon(
        business['category'] as String,
        business['isOpen'] as bool,
      );

      markers.add(
        Marker(
          markerId: MarkerId(business['id'] as String),
          position: LatLng(
            business['latitude'] as double,
            business['longitude'] as double,
          ),
          icon: markerIcon,
          infoWindow: InfoWindow(
            title: business['name'] as String,
            snippet: '★ ${business['rating']} • ${business['category']}',
          ),
          onTap: () => _onMarkerTapped(business['id'] as String),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  Future<BitmapDescriptor> _getCustomMarkerIcon(
      String category, bool isOpen) async {
    try {
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);
      final Paint paint = Paint()..isAntiAlias = true;

      const double size = 100.0;
      const double iconSize = 60.0;

      // Background circle
      paint.color = isOpen ? AppTheme.actionRed : AppTheme.mediumGray;
      canvas.drawCircle(
        const Offset(size / 2, size / 2),
        size / 2,
        paint,
      );

      // Inner circle
      paint.color = Colors.white;
      canvas.drawCircle(
        const Offset(size / 2, size / 2),
        iconSize / 2,
        paint,
      );

      // Convert to image and then to BitmapDescriptor
      final ui.Picture picture = recorder.endRecording();
      final ui.Image image = await picture.toImage(size.toInt(), size.toInt());
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List uint8List = byteData!.buffer.asUint8List();

      return BitmapDescriptor.fromBytes(uint8List);
    } catch (e) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }

  void _onMarkerTapped(String businessId) {
    setState(() {
      _selectedBusinessId = businessId;
    });

    final business = _businessLocations.firstWhere(
      (b) => b['id'] == businessId,
    );

    _animateToLocation(
      business['latitude'] as double,
      business['longitude'] as double,
    );

    _infoCardAnimationController?.forward();

    // Auto-hide info card after 10 seconds
    Timer(const Duration(seconds: 10), () {
      if (mounted && _selectedBusinessId == businessId) {
        _hideBusinessInfo();
      }
    });
  }

  Future<void> _animateToLocation(double latitude, double longitude) async {
    final GoogleMapController controller = await _mapController.future;
    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(latitude, longitude),
        15.0,
      ),
    );
  }

  void _hideBusinessInfo() {
    _infoCardAnimationController?.reverse();
    setState(() {
      _selectedBusinessId = null;
    });
  }

  void _onMapTypeChanged(MapType mapType) {
    setState(() {
      _currentMapType = mapType;
    });
  }

  Future<void> _moveToCurrentLocation() async {
    if (_currentPosition == null) return;

    final GoogleMapController controller = await _mapController.future;
    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        15.0,
      ),
    );
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) return;

    // Mock search functionality - in real app, this would query a backend
    final matchingBusiness = _businessLocations.firstWhere(
      (business) => business['name']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase()),
      orElse: () => _businessLocations.first,
    );

    _animateToLocation(
      matchingBusiness['latitude'] as double,
      matchingBusiness['longitude'] as double,
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        selectedCategory: _selectedCategory,
        selectedRadius: _selectedRadius,
        selectedMinRating: _selectedMinRating,
        onFiltersApplied: (category, radius, minRating) {
          setState(() {
            _selectedCategory = category;
            _selectedRadius = radius;
            _selectedMinRating = minRating;
            _activeFilters = _calculateActiveFilters();
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  int _calculateActiveFilters() {
    int count = 0;
    if (_selectedCategory != 'All') count++;
    if (_selectedRadius < 20.0) count++; // Default is 20km
    if (_selectedMinRating > 0.0) count++;
    return count;
  }

  void _onBottomBarTapped(int index) {
    setState(() {
      _currentBottomBarIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.homeDashboard);
        break;
      case 1:
        // Stay on map view
        break;
      case 2:
        // QR Scanner functionality
        break;
      case 3:
        // Favorites functionality
        break;
      case 4:
        // Profile functionality
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            mapType: _currentMapType,
            initialCameraPosition: _initialCameraPosition,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
            onCameraMove: (CameraPosition position) {
              _currentZoom = position.zoom;
            },
            myLocationEnabled: _isLocationEnabled,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            onTap: (LatLng position) {
              _hideBusinessInfo();
            },
          ),

          // Search Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MapSearchHeaderWidget(
              controller: _searchController,
              activeFilters: _activeFilters,
              onSearchChanged: _onSearchChanged,
              onFilterTapped: _showFilterModal,
            ),
          ),

          // Map Controls
          Positioned(
            right: 4.w,
            top: 25.h,
            child: MapControlsWidget(
              currentMapType: _currentMapType,
              onMapTypeChanged: _onMapTypeChanged,
              onCurrentLocationTapped: _moveToCurrentLocation,
              isLocationEnabled: _isLocationEnabled,
            ),
          ),

          // Business Info Card
          if (_selectedBusinessId != null)
            Positioned(
              bottom: 12.h,
              left: 4.w,
              right: 4.w,
              child: SlideTransition(
                position: _infoCardSlideAnimation!,
                child: BusinessInfoCardWidget(
                  business: _businessLocations.firstWhere(
                    (b) => b['id'] == _selectedBusinessId,
                  ),
                  onClose: _hideBusinessInfo,
                  onViewProfile: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.businessDetail,
                      arguments: _selectedBusinessId,
                    );
                  },
                  onGetDirections: () {
                    // Implement directions functionality
                  },
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomBarIndex,
        onTap: _onBottomBarTapped,
        variant: CustomBottomBarVariant.primary,
      ),
    );
  }
}
