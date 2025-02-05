import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/models/customer.dart';
import 'package:rota/components/card.dart';
import 'package:rota/components/elevated_button.dart';
import 'package:rota/services/delivery_service.dart';
import 'package:rota/services/route_service.dart';

class CustomerDetailScreen extends ConsumerWidget {
  final Customer customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryService = DeliveryService();
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
                    style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Address: ${customer.address}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 20),
                  customer.deliverStatus == false
                      ? Align(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CommonElevatedButton(
                                onPressed: () async {
                                  await deliveryService.markAsDelivered(
                                      context, ref, customer);
                                },
                                label: customer.deliverStatus
                                    ? 'Delivered'
                                    : 'Mark as Delivered',
                                isDelivered: customer.deliverStatus,
                              ),
                              const SizedBox(width: 16),
                              CommonElevatedButton(
                                onPressed: () async {
                                  createRoute(context, ref);
                                },
                                label: 'Create Route',
                                isDelivered: false,
                              ),
                            ],
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (customer.signatureUrl != null)
                              const Text('Customer Signature: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            if (customer.signatureUrl != null)
                              Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey,
                                        width:
                                            2), // Black border with 2px width
                                    borderRadius: BorderRadius.circular(
                                        8), // Optional: Rounded corners
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.all(5),
                                  height: 100,
                                  width: 150,
                                  child: Image.network(customer.signatureUrl!)),
                            if (customer.photoUrl != null)
                              Text('Package Photo: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800])),
                            if (customer.photoUrl != null)
                              Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey,
                                        width:
                                            2), // Black border with 2px width
                                    borderRadius: BorderRadius.circular(
                                        8), // Optional: Rounded corners
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.all(5),
                                  height: 100,
                                  width: 150,
                                  child: Image.network(customer.photoUrl!)),
                            const Center(
                                child: Text('Delivered',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold))),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*Future<void> _createRoute(BuildContext context, WidgetRef ref) async {
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
  } */
}
