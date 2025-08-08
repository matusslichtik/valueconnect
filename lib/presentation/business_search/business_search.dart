import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './widgets/business_card_widget.dart';
import './widgets/category_chips_widget.dart';
import './widgets/empty_search_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_searches_widget.dart';
import './widgets/search_header_widget.dart';

class BusinessSearch extends StatefulWidget {
  const BusinessSearch({super.key});

  @override
  State<BusinessSearch> createState() => _BusinessSearchState();
}

class _BusinessSearchState extends State<BusinessSearch> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  String? _selectedCategory;
  Map<String, dynamic> _activeFilters = {
    'distance': 10.0,
    'minRating': 1,
    'openNow': false,
    'categories': <String>[],
  };

  List<String> _recentSearches = [
    'Pizza restaurants',
    'Hair salon',
    'Auto repair',
    'Coffee shops',
    'Grocery stores',
  ];

  List<Map<String, dynamic>> _businesses = [];
  List<Map<String, dynamic>> _filteredBusinesses = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  final List<String> _categories = [
    'All',
    'Restaurants',
    'Shopping',
    'Services',
    'Entertainment',
    'Health',
    'Beauty',
    'Automotive',
  ];

  @override
  void initState() {
    super.initState();
    _initializeBusinesses();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeBusinesses() {
    _businesses = [
      {
        "id": 1,
        "name": "Bistro Slovenka",
        "description":
            "Traditional Slovak cuisine with modern twist. Fresh ingredients and authentic flavors in the heart of Bratislava.",
        "image":
            "https://images.pexels.com/photos/262978/pexels-photo-262978.jpeg",
        "rating": 4.8,
        "distance": 0.5,
        "isOpen": true,
        "categories": ["Restaurants", "Slovak Cuisine"],
        "phone": "+421 2 5555 1234",
        "address": "Hlavné námestie 1, Bratislava",
        "isFavorite": false,
      },
      {
        "id": 2,
        "name": "Fashion Gallery",
        "description":
            "Premium fashion boutique featuring local and international designers. Unique pieces for every occasion.",
        "image":
            "https://images.pexels.com/photos/1884581/pexels-photo-1884581.jpeg",
        "rating": 4.5,
        "distance": 1.2,
        "isOpen": true,
        "categories": ["Shopping", "Fashion"],
        "phone": "+421 2 5555 5678",
        "address": "Obchodná 15, Bratislava",
        "isFavorite": true,
      },
      {
        "id": 3,
        "name": "Auto Servis Plus",
        "description":
            "Professional automotive services with certified mechanics. Quick and reliable repairs for all car brands.",
        "image":
            "https://images.pexels.com/photos/3806288/pexels-photo-3806288.jpeg",
        "rating": 4.3,
        "distance": 2.1,
        "isOpen": false,
        "categories": ["Automotive", "Services"],
        "phone": "+421 2 5555 9012",
        "address": "Priemyselná 8, Bratislava",
        "isFavorite": false,
      },
      {
        "id": 4,
        "name": "Wellness Spa Relax",
        "description":
            "Luxury spa and wellness center offering massage, beauty treatments, and relaxation therapies.",
        "image":
            "https://images.pexels.com/photos/3757942/pexels-photo-3757942.jpeg",
        "rating": 4.9,
        "distance": 0.8,
        "isOpen": true,
        "categories": ["Health", "Beauty"],
        "phone": "+421 2 5555 3456",
        "address": "Kúpeľná 22, Bratislava",
        "isFavorite": false,
      },
      {
        "id": 5,
        "name": "Cinema Deluxe",
        "description":
            "Modern cinema complex with latest movies, comfortable seating, and premium sound system.",
        "image":
            "https://images.pexels.com/photos/7991579/pexels-photo-7991579.jpeg",
        "rating": 4.6,
        "distance": 1.5,
        "isOpen": true,
        "categories": ["Entertainment", "Cinema"],
        "phone": "+421 2 5555 7890",
        "address": "Nákupné centrum, Bratislava",
        "isFavorite": true,
      },
      {
        "id": 6,
        "name": "Café Central",
        "description":
            "Cozy coffee shop with artisan coffee, fresh pastries, and friendly atmosphere. Perfect for meetings.",
        "image":
            "https://images.pexels.com/photos/302899/pexels-photo-302899.jpeg",
        "rating": 4.4,
        "distance": 0.3,
        "isOpen": true,
        "categories": ["Restaurants", "Coffee"],
        "phone": "+421 2 5555 2468",
        "address": "Ventúrska 9, Bratislava",
        "isFavorite": false,
      },
      {
        "id": 7,
        "name": "Tech Repair Center",
        "description":
            "Expert repair services for smartphones, tablets, and computers. Fast turnaround and warranty included.",
        "image":
            "https://images.pexels.com/photos/3184292/pexels-photo-3184292.jpeg",
        "rating": 4.2,
        "distance": 1.8,
        "isOpen": false,
        "categories": ["Services", "Technology"],
        "phone": "+421 2 5555 1357",
        "address": "Technická 12, Bratislava",
        "isFavorite": false,
      },
      {
        "id": 8,
        "name": "Fresh Market",
        "description":
            "Local farmers market with fresh produce, organic foods, and artisanal products from Slovak producers.",
        "image":
            "https://images.pexels.com/photos/1435904/pexels-photo-1435904.jpeg",
        "rating": 4.7,
        "distance": 2.5,
        "isOpen": true,
        "categories": ["Shopping", "Food"],
        "phone": "+421 2 5555 9753",
        "address": "Tržnica, Bratislava",
        "isFavorite": true,
      },
    ];

    _applyFilters();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    _applyFilters();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreBusinesses();
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredBusinesses = _businesses.where((business) {
        // Text search filter
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          final name = (business['name'] as String).toLowerCase();
          final description = (business['description'] as String).toLowerCase();
          final categories = (business['categories'] as List)
              .map((c) => c.toString().toLowerCase())
              .join(' ');

          if (!name.contains(query) &&
              !description.contains(query) &&
              !categories.contains(query)) {
            return false;
          }
        }

        // Category filter
        if (_selectedCategory != null && _selectedCategory != 'All') {
          final businessCategories = business['categories'] as List;
          if (!businessCategories.contains(_selectedCategory)) {
            return false;
          }
        }

        // Distance filter
        final distance = business['distance'] as double;
        if (distance > (_activeFilters['distance'] as double)) {
          return false;
        }

        // Rating filter
        final rating = business['rating'] as double;
        if (rating < (_activeFilters['minRating'] as int)) {
          return false;
        }

        // Open now filter
        if (_activeFilters['openNow'] as bool) {
          if (!(business['isOpen'] as bool)) {
            return false;
          }
        }

        // Selected categories filter
        final selectedCategories = _activeFilters['categories'] as List<String>;
        if (selectedCategories.isNotEmpty) {
          final businessCategories = business['categories'] as List;
          bool hasMatchingCategory = false;
          for (String category in selectedCategories) {
            if (businessCategories.contains(category)) {
              hasMatchingCategory = true;
              break;
            }
          }
          if (!hasMatchingCategory) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  void _loadMoreBusinesses() {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate loading more data
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
          _currentPage++;
        });
      }
    });
  }

  void _onVoiceSearch() {
    // Voice search implementation would go here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice search feature coming soon')),
    );
  }

  void _onFilterTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        currentFilters: _activeFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _activeFilters = filters;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category == 'All' ? null : category;
    });
    _applyFilters();
  }

  void _onBusinessTap(Map<String, dynamic> business) {
    Navigator.pushNamed(
      context,
      '/business-detail',
      arguments: business,
    );
  }

  void _onBusinessLongPress(Map<String, dynamic> business) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickActionsWidget(
        business: business,
        onCall: () {
          Navigator.pop(context);
          _callBusiness(business);
        },
        onDirections: () {
          Navigator.pop(context);
          _getDirections(business);
        },
        onShare: () {
          Navigator.pop(context);
          _shareBusiness(business);
        },
        onFavorite: () {
          Navigator.pop(context);
          _toggleFavorite(business);
        },
      ),
    );
  }

  void _callBusiness(Map<String, dynamic> business) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling ${business['name']}...')),
    );
  }

  void _getDirections(Map<String, dynamic> business) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Getting directions to ${business['name']}...')),
    );
  }

  void _shareBusiness(Map<String, dynamic> business) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${business['name']}...')),
    );
  }

  void _toggleFavorite(Map<String, dynamic> business) {
    setState(() {
      final index = _businesses.indexWhere((b) => b['id'] == business['id']);
      if (index != -1) {
        _businesses[index]['isFavorite'] = !(business['isFavorite'] as bool);
      }
    });
    _applyFilters();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          business['isFavorite'] as bool
              ? 'Removed from favorites'
              : 'Added to favorites',
        ),
      ),
    );
  }

  void _onRecentSearchTap(String search) {
    _searchController.text = search;
    setState(() {
      _searchQuery = search;
    });
    _applyFilters();
  }

  void _onRecentSearchRemove(String search) {
    setState(() {
      _recentSearches.remove(search);
    });
  }

  void _onClearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedCategory = null;
    });
    _applyFilters();
  }

  void _onCategoryTapFromEmpty(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _applyFilters();
  }

  int get _activeFilterCount {
    int count = 0;

    if ((_activeFilters['distance'] as double) < 10.0) count++;
    if ((_activeFilters['minRating'] as int) > 1) count++;
    if (_activeFilters['openNow'] as bool) count++;
    if ((_activeFilters['categories'] as List<String>).isNotEmpty) count++;

    return count;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          SearchHeaderWidget(
            searchController: _searchController,
            onSearchChanged: (query) {
              if (query.isNotEmpty && !_recentSearches.contains(query)) {
                setState(() {
                  _recentSearches.insert(0, query);
                  if (_recentSearches.length > 10) {
                    _recentSearches.removeLast();
                  }
                });
              }
            },
            onVoiceSearch: _onVoiceSearch,
            onFilterTap: _onFilterTap,
            activeFilterCount: _activeFilterCount,
          ),
          CategoryChipsWidget(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: _onCategorySelected,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _isLoading = true;
                });

                await Future.delayed(const Duration(seconds: 1));

                if (mounted) {
                  setState(() {
                    _isLoading = false;
                    _currentPage = 1;
                  });
                  _applyFilters();
                }
              },
              child: _buildContent(context, theme, colorScheme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchQuery.isEmpty && _selectedCategory == null) {
      return SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            RecentSearchesWidget(
              recentSearches: _recentSearches,
              onSearchTap: _onRecentSearchTap,
              onSearchRemove: _onRecentSearchRemove,
            ),
            EmptySearchWidget(
              searchQuery: _searchQuery,
              onClearSearch: _onClearSearch,
              onCategoryTap: _onCategoryTapFromEmpty,
            ),
          ],
        ),
      );
    }

    if (_filteredBusinesses.isEmpty) {
      return EmptySearchWidget(
        searchQuery: _searchQuery,
        onClearSearch: _onClearSearch,
        onCategoryTap: _onCategoryTapFromEmpty,
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(bottom: 2.h),
      itemCount: _filteredBusinesses.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _filteredBusinesses.length) {
          return Container(
            padding: EdgeInsets.all(4.w),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final business = _filteredBusinesses[index];
        return BusinessCardWidget(
          business: business,
          onTap: () => _onBusinessTap(business),
          onLongPress: () => _onBusinessLongPress(business),
        );
      },
    );
  }
}
