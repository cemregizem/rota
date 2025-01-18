import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/models/customer.dart';
import 'package:rota/providers/customer_list_provider.dart';
import 'package:rota/providers/location_provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rota/providers/route_provider.dart';
import 'package:rota/providers/route_status_provider.dart';
import 'package:rota/providers/state_provider.dart';
import 'package:rota/screens/customer_detail_screen.dart';
import 'package:rota/screens/customer_list_screen.dart';
import 'package:rota/screens/new_customer_screen.dart';
import 'package:rota/services/auth_service.dart';
import 'package:rota/services/route_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key, required this.customers}) : super(key: key);
  //List<Consumer> parametre olarak alırız.Map üzerinde göstereceğimiz için
  final List<Customer> customers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsyncValue = ref.watch(
        locationProvider); //Kullanıcının şuanki lokasyonunu sağlamak için locationProviderı izler
    final customers = ref.watch(customerListProvider); //müşteri listesi
    final AuthService _authService = AuthService();

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
            onPressed: () async {
              // Ensure logout is wrapped in an async function
              await _authService.logout(ref, context);
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: locationAsyncValue.when(
        data: (position) {
          final userLocation = LatLng(
              position.latitude,
              position
                  .longitude); //lokasyon elde edilince latitude ve lonitude olarak çevirir

          // Create markers for each customer
          final customerMarkers = customers
              .map(
                (customer) => Marker(
                  point: customer.location,
                  width: 80.0,
                  height: 80.0,
                  builder: (ctx) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CustomerDetailScreen(customer: customer),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 17.0,
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          customer.customerNumber.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
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
                      //fluttermap kullanılarak haritayı gösteririz
                      options: MapOptions(
                        center: userLocation,
                        zoom: 15.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c'],
                        ),
                        if (ref
                            .watch(polylineStateProvider)
                            .isNotEmpty) //Eğer bir rota belirlenmişse bu layerda gösterilir

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
                        MarkerLayer(
                          //kullanıcı ve müşterilerinin yer pinlerini gösteririz
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),

                // Button section
                Expanded(
                  flex: 1, // Buttons take 1/3 of the screen
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          if (ref.watch(routeStatusProvider)) {
                            cancelRoute(
                                context, ref); // Call cancelRoute if active
                          } else {
                            createRoute(
                                context, ref); // Call createRoute if inactive
                            ref
                                .read(routeStatusProvider.notifier)
                                .activateRoute(); // Activate route
                          }
                        },
                        icon: const Icon(
                          Icons.directions,
                          color: Colors.white,
                        ),
                        label: Text(
                          ref.watch(routeStatusProvider)
                              ? 'Cancel Route'
                              : 'Create Route',
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: ref.watch(routeStatusProvider)
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      ElevatedButton.icon(
                        onPressed: () {
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
        loading: () => const Center(
            child:
                CircularProgressIndicator()), //loading spinner gösterilir lokasyon yüklenirken
        error: (error, stack) {
          debugPrint('Error occurred: $error');
          debugPrint('Stack trace: $stack');

          return Center(child: Text('Error: $error'));
        },
      ),
    );
  }
}
