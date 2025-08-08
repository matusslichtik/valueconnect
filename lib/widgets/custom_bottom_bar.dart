import 'package:flutter/material.dart';

enum CustomBottomBarVariant {
  primary,
  floating,
  minimal,
}

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final CustomBottomBarVariant variant;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.variant = CustomBottomBarVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CustomBottomBarVariant.primary:
        return _buildPrimaryBottomBar(context, colorScheme);
      case CustomBottomBarVariant.floating:
        return _buildFloatingBottomBar(context, colorScheme);
      case CustomBottomBarVariant.minimal:
        return _buildMinimalBottomBar(context, colorScheme);
    }
  }

  Widget _buildPrimaryBottomBar(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _handleTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: colorScheme.secondary,
          unselectedItemColor: colorScheme.onSurfaceVariant,
          selectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
          unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
          ),
          items: _getBottomNavigationBarItems(),
        ),
      ),
    );
  }

  Widget _buildFloatingBottomBar(
      BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: _handleTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: colorScheme.secondary,
            unselectedItemColor: colorScheme.onSurfaceVariant,
            selectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
            ),
            unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w400,
              letterSpacing: 0.4,
            ),
            items: _getBottomNavigationBarItems(),
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalBottomBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildMinimalItems(context, colorScheme),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _getBottomNavigationBarItems() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Home',
        tooltip: 'Home Dashboard',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.search_outlined),
        activeIcon: Icon(Icons.search),
        label: 'Search',
        tooltip: 'Search Businesses',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.qr_code_scanner_outlined),
        activeIcon: Icon(Icons.qr_code_scanner),
        label: 'Scan',
        tooltip: 'QR Code Scanner',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.favorite_outline),
        activeIcon: Icon(Icons.favorite),
        label: 'Favorites',
        tooltip: 'Favorite Businesses',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profile',
        tooltip: 'User Profile',
      ),
    ];
  }

  List<Widget> _buildMinimalItems(
      BuildContext context, ColorScheme colorScheme) {
    final items = [
      _MinimalNavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Home',
        isActive: currentIndex == 0,
        onTap: () => _handleTap(0),
        colorScheme: colorScheme,
      ),
      _MinimalNavItem(
        icon: Icons.search_outlined,
        activeIcon: Icons.search,
        label: 'Search',
        isActive: currentIndex == 1,
        onTap: () => _handleTap(1),
        colorScheme: colorScheme,
      ),
      _MinimalNavItem(
        icon: Icons.qr_code_scanner_outlined,
        activeIcon: Icons.qr_code_scanner,
        label: 'Scan',
        isActive: currentIndex == 2,
        onTap: () => _handleTap(2),
        colorScheme: colorScheme,
      ),
      _MinimalNavItem(
        icon: Icons.favorite_outline,
        activeIcon: Icons.favorite,
        label: 'Favorites',
        isActive: currentIndex == 3,
        onTap: () => _handleTap(3),
        colorScheme: colorScheme,
      ),
      _MinimalNavItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profile',
        isActive: currentIndex == 4,
        onTap: () => _handleTap(4),
        colorScheme: colorScheme,
      ),
    ];

    return items;
  }

  void _handleTap(int index) {
    onTap(index);
    _navigateToRoute(index);
  }

  void _navigateToRoute(int index) {
    // Note: This should be called from the parent widget that manages navigation
    // The actual navigation logic should be handled by the parent
    switch (index) {
      case 0:
        // Home - handled by parent
        break;
      case 1:
        // Search - handled by parent
        break;
      case 2:
        // QR Scanner - handled by parent
        break;
      case 3:
        // Favorites - handled by parent
        break;
      case 4:
        // Profile - handled by parent
        break;
    }
  }
}

class _MinimalNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _MinimalNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isActive
                      ? colorScheme.secondary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isActive ? activeIcon : icon,
                  color: isActive
                      ? colorScheme.secondary
                      : colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isActive
                      ? colorScheme.secondary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}