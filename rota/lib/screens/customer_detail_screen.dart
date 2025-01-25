import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:rota/components/bottom_sheet.dart';
import 'package:rota/models/customer.dart';
import 'package:rota/providers/customer_delivered_provider.dart';
import 'package:rota/components/card.dart';
import 'package:rota/components/elevated_button.dart';
import 'package:rota/providers/location_provider.dart';
import 'package:rota/providers/route_provider.dart';
import 'package:rota/providers/state_provider.dart';
import 'package:rota/providers/user_provider.dart';
import 'package:rota/screens/map_screen.dart';
import 'package:rota/screens/signature_screen.dart';

class CustomerDetailScreen extends ConsumerWidget {
  final Customer customer;

  const CustomerDetailScreen({super.key, required this.customer});

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
                  customer.deliverStatus == false
                      ? Align(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CommonElevatedButton(
                                onPressed: () async {
                                  _markAsDelivered(context, ref);
                                },
                                label: customer.deliverStatus
                                    ? 'Delivered'
                                    : 'Mark as Delivered',
                                isDelivered: customer.deliverStatus,
                              ),
                              const SizedBox(width: 16),
                              CommonElevatedButton(
                                onPressed: () async {
                                  _createRoute(context, ref);
                                },
                                label: 'Create Route',
                                isDelivered: false,
                              ),
                            ],
                          ),
                        )
                      : const Center(
                          child: Text('Delivered',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createRoute(BuildContext context, WidgetRef ref) async {
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

  Future<void> _markAsDelivered(BuildContext context, WidgetRef ref) async {
    await DeliveryBottomSheet.show(
      context,
      onCameraTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera option selected')),
        );
        // Add actual camera functionality here
      },
      onSignatureTap: () {
        Navigator.pop(context); // Close the bottom sheet
        Future.delayed(Duration.zero, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignatureScreen(
                onSave: (signatureUrl) async {
                  // Save the signature URL to Firestore or update Riverpod state
                  await ref
                      .read(customerDeliverStatusProvider(customer).future);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Signature saved! URL: $signatureUrl')),
                  );
                },
              ),
            ),
          );
        });
      },
    );

    // provider kullanarak deliverystatusu güncellemek için işlem yapılır
    await ref.read(customerDeliverStatusProvider(customer).future);

    await ref.read(userProvider.notifier).incrementDeliveredPackageCount();
    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
