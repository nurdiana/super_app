import 'package:flutter/material.dart';

abstract class MapWidget extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double zoom;
  final bool useCurrentLocation;

  const MapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.zoom,
    this.useCurrentLocation = false,
  });
}
