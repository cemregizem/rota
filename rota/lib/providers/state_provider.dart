import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

final polylineStateProvider = StateNotifierProvider<PolylineNotifier, List<LatLng>>((ref) {
  return PolylineNotifier();
});

class PolylineNotifier extends StateNotifier<List<LatLng>> {
  PolylineNotifier() : super([]);

  void updatePolyline(List<LatLng> newPolyline) {
    state = newPolyline;  // Polylineleri güncelle
  }
}
