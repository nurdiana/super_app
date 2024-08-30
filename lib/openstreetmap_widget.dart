import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'map_widget.dart';
import 'package:location/location.dart';

class OpenStreetMapWidget extends MapWidget {
  const OpenStreetMapWidget({
    super.key,
    required super.latitude,
    required super.longitude,
    required super.zoom,
    super.useCurrentLocation,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationData>(
      future: _getLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final LocationData? locationData = snapshot.data;
        final LatLng location = useCurrentLocation && locationData != null
            ? LatLng(locationData.latitude!, locationData.longitude!)
            : LatLng(latitude, longitude);

        return FlutterMap(
          options: MapOptions(
            initialCenter: location,
            initialZoom: zoom,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: location,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<LocationData> _getLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw 'Location permissions are denied';
      }
    }

    locationData = await location.getLocation();
    return locationData;
  }
}
