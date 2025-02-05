import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:rota/models/customer.dart';
import 'package:rota/providers/customer_list_provider.dart';
import 'package:rota/providers/location_provider.dart';
import 'package:rota/providers/route_provider.dart';
import 'package:rota/providers/route_status_provider.dart';
import 'package:rota/providers/state_provider.dart';
import 'package:rota/screens/map_screen.dart';

class RouteService {
  Future<void> createRoute(BuildContext context, WidgetRef ref) async {
    final userLocation = ref.watch(locationProvider).value; // Get user location
    if (userLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to fetch user location.')),
      );
      return;
    }

    final customerLocations = ref.watch(customerListProvider);
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

  Future<void> createIndividualRoute(BuildContext context, WidgetRef ref, Customer customer) async {
    final position = await ref.read(locationProvider.future);
    final userLocation =
        LatLng(position.latitude, position.longitude); //kullanıcı lokasyonu
    final customerLocation = customer.location; //müşteri lokasyonu

    try {
      // Rota oluşturulur
      final polyline = await ref.read(routeProvider({
        'userLocation': userLocation,
        'customerLocation': customerLocation
      }).future);

      // Update the polyline state
      ref.read(polylineStateProvider.notifier).updatePolyline(polyline);
      if (context.mounted) {
        // Navigate back to Home Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MapScreen(
              customers: [],
            ),
          ),
        );
      }
    } catch (e) {
      // Handle error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating route: $e')),
        );
      }
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
}
