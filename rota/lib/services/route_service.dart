import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:rota/notifiers/customer_list_notifier.dart';
import 'package:rota/providers/location_provider.dart';
import 'package:rota/providers/route_provider.dart';
import 'package:rota/providers/route_status_provider.dart';
import 'package:rota/providers/state_provider.dart';

Future<void> createRoute(BuildContext context, WidgetRef ref) async {
  final userLocation = ref.watch(locationProvider).value; // Get user location
  if (userLocation == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unable to fetch user location.')),
    );
    return;
  }

  final customerLocations = ref.watch(customerListNotifierProvider);
  if (customerLocations.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No customers to create a route for.')),
    );
    return;
  }

  final allCoordinates = <LatLng>[]; // Store all route points in order

  for (int i = 0; i < customerLocations.length; i++) {
    final startLocation = i == 0
        ? LatLng(userLocation.latitude, userLocation.longitude)
        : customerLocations[i - 1].location;
    final endLocation = customerLocations[i].location;

    try {
      final segment = await ref.read(routeProvider({
        'userLocation': startLocation,
        'customerLocation': endLocation,
      }).future);

      allCoordinates.addAll(segment); // Add segment points
    } catch (e) {
      debugPrint('Error fetching route: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch route for segment $i')),
        );
      }
    }
  }

  // Update the polyline state
  ref.read(polylineStateProvider.notifier).updatePolyline(allCoordinates);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Route created successfully.')),
    );
  }
}

void cancelRoute(BuildContext context, WidgetRef ref) {
  // clear polylinee
  ref.read(polylineStateProvider.notifier).updatePolyline([]);

  //update route status
  ref.read(routeStatusProvider.notifier).cancelRoute();


  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Route canceled.')),
  );
}
