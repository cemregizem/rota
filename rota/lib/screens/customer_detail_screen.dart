import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:rota/models/customer.dart';
import 'package:rota/providers/customer_delivered_provider.dart';
import 'package:rota/components/card.dart';
import 'package:rota/components/elevatedButton.dart';
import 'package:rota/providers/location_provider.dart';
import 'package:rota/providers/route_provider.dart';
import 'package:rota/providers/state_provider.dart';
import 'package:rota/screens/home.dart';

class CustomerDetailScreen extends ConsumerWidget {
  final Customer customer;

  const CustomerDetailScreen({Key? key, required this.customer})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Package Number: ${customer.packageNumber}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${customer.name} ${customer.surname}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Phone: ${customer.phone}',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Address: ${customer.address}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // "Mark as Delivered" button
                        CommonElevatedButton(
                          onPressed: () async {
                            // Call the provider to update the deliverStatus
                            await ref.read(
                                customerDeliverStatusProvider(customer).future);

                            // Optionally, delay for smooth UX
                            await Future.delayed(const Duration(seconds: 2));

                            // Close the detail screen
                            Navigator.pop(context);
                          },
                          label: customer.deliverStatus
                              ? 'Delivered'
                              : 'Mark as Delivered',
                          isDelivered: customer.deliverStatus,
                        ),
                        const SizedBox(width: 16), // Space between buttons
                        // "Create Route" button
                        CommonElevatedButton(
                          onPressed: () async {
                            final position =
                                await ref.read(locationProvider.future);
                            final userLocation =
                                LatLng(position.latitude, position.longitude);
                            final customerLocation = customer.location;

                            try {
                              // Fetch the route
                              final polyline = await ref.read(routeProvider({
                                'userLocation': userLocation,
                                'customerLocation': customerLocation
                              }).future);

                              // Update the polyline state

                              ref.read(polylineStateProvider.notifier).state =
                                  polyline;

                              // Navigate back to Home Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(
                                    customers: [],
                                  ),
                                ),
                              );
                            } catch (e) {
                              // Handle error
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Error creating route: $e')),
                              );
                            }
                          },
                          label: 'Create Route',
                          isDelivered: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
