import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/models/customer.dart';
import 'package:rota/providers/auth_provider.dart';

import 'package:rota/providers/customer_list_provider.dart';
import 'package:rota/providers/location_provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rota/providers/route_provider.dart';
import 'package:rota/providers/selected_customer_provider.dart';
import 'package:rota/providers/state_provider.dart';
import 'package:rota/screens/customer_list_screen.dart';
import 'package:rota/screens/new_customer_screen.dart';
import 'package:rota/screens/login_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key, required this.customers}) : super(key: key);
  final List<Customer> customers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsyncValue = ref.watch(locationProvider);
    final customers = ref.watch(customerListProvider);
   // final selectedCustomer = ref.watch(selectedCustomerProvider);
    // Logout function call
    void _logout() async {
      try {
        await ref.read(authControllerProvider).logout();
        // After logout, navigate back to the login screen or other logic
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const LoginScreen()), // Replace with your login screen
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'The Route',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFFDC2A34),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: locationAsyncValue.when(
        data: (position) {
          final userLocation = LatLng(position.latitude, position.longitude);
          // Create markers for each customer
          final customerMarkers = customers
              .map(
                (customer) => Marker(
                  point: customer.location,
                  width: 80.0,
                  height: 80.0,
                  builder: (ctx) => const Icon(
                    Icons.location_pin,
                    size: 40.0,
                    color: Colors.green,
                  ),
                ),
              )
              .toList();
        
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Map section
                Expanded(
                  flex: 3, // Map takes 2/3 of the screen
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: FlutterMap(
                      options: MapOptions(
                        center: userLocation,
                        zoom: 16.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: userLocation,
                              width: 80.0,
                              height: 80.0,
                              builder: (ctx) => const Icon(
                                Icons.location_pin,
                                size: 40.0,
                                color: Colors.red,
                              ),
                            ),

                            ...customerMarkers // Add all customer markers
                          ],
                        ),
                        if (ref.watch(polylineStateProvider).isNotEmpty)
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: ref.watch(
                                    polylineStateProvider), // Use the state directly
                                strokeWidth: 4.0,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30.0), // Space between map and buttons
                // Button section
                Expanded(
                  flex: 1, // Buttons take 1/3 of the screen
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to Customer List Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CustomerListScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.list),
                        label: const Text('Customer List'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to Add New Customer Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CustomerScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.person_add),
                        label: const Text('Add New Customer'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          debugPrint('Error occurred: $error');
          debugPrint('Stack trace: $stack');

          return Center(child: Text('Error: $error'));
        },
      ),
    );
  }
}
