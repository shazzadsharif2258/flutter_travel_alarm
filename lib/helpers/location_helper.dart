import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<String> getReadable() async {
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );

    try {
      final list = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (list.isNotEmpty) {
        final p = list.first;
        final parts = [
          p.locality,
          p.administrativeArea,
          p.country,
        ].whereType<String>().where((e) => e.isNotEmpty).toList();
        if (parts.isNotEmpty) return parts.join(', ');
      }
    } catch (_) {}
    return '${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}';
  }
}
