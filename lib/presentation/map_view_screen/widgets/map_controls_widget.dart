import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class MapControlsWidget extends StatelessWidget {
  final MapType currentMapType;
  final ValueChanged<MapType> onMapTypeChanged;
  final VoidCallback onCurrentLocationTapped;
  final bool isLocationEnabled;

  const MapControlsWidget({
    super.key,
    required this.currentMapType,
    required this.onMapTypeChanged,
    required this.onCurrentLocationTapped,
    required this.isLocationEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Map Type Toggle
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildMapTypeButton(
                context,
                colorScheme,
                MapType.normal,
                'map',
                'Normal',
              ),
              Container(
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
              _buildMapTypeButton(
                context,
                colorScheme,
                MapType.satellite,
                'satellite',
                'Satellite',
              ),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Current Location Button
        if (isLocationEnabled)
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap: onCurrentLocationTapped,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'my_location',
                  color: colorScheme.secondary,
                  size: 24,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMapTypeButton(
    BuildContext context,
    ColorScheme colorScheme,
    MapType mapType,
    String iconName,
    String tooltip,
  ) {
    final theme = Theme.of(context);
    final isSelected = currentMapType == mapType;

    return InkWell(
      onTap: () => onMapTypeChanged(mapType),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.secondary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isSelected
                  ? colorScheme.secondary
                  : colorScheme.onSurfaceVariant,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              tooltip,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? colorScheme.secondary
                    : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
