import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:rota/components/bottom_sheet.dart';
import 'package:rota/models/customer.dart';
import 'package:rota/providers/auth_provider.dart';
import 'package:rota/providers/customer_delivered_provider.dart';
import 'package:rota/components/card.dart';
import 'package:rota/components/elevated_button.dart';
import 'package:rota/providers/location_provider.dart';
import 'package:rota/providers/route_provider.dart';
import 'package:rota/providers/state_provider.dart';
import 'package:rota/providers/user_provider.dart';
import 'package:rota/screens/map_screen.dart';
import 'package:rota/screens/signature_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
                                  await _markAsDelivered(context, ref);
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
                                        color: Colors.black,
                                        width:
                                            2), // Black border with 2px width
                                    borderRadius: BorderRadius.circular(
                                        8), // Optional: Rounded corners
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.all(5),
                                  height: 70,
                                  width: 120,
                                  child: Image.network(customer.signatureUrl!)),
                            if (customer.photoUrl != null)
                              const Text('Customer Photo: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            if (customer.photoUrl != null)
                              Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black,
                                        width:
                                            2), // Black border with 2px width
                                    borderRadius: BorderRadius.circular(
                                        8), // Optional: Rounded corners
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.all(5),
                                  height: 70,
                                  width: 120,
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
    // Save the signature URL to Firestore or update Riverpod state
    await ref.read(customerDeliverStatusProvider(customer).future);
    await DeliveryBottomSheet.show(
      context,
      onCameraTap: () async {
        Navigator.pop(context); // Close the bottom sheet
        await _handleCameraTap(context, ref, customer);
      },
      onSignatureTap: () {
        Navigator.pop(context); // Close the bottom sheet
        Future.delayed(Duration.zero, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignatureScreen(
                onSave: (signatureUrl) async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signature saved!')),
                  );
                },
                customer: customer,
              ),
            ),
          );
        });
      },
    );

    await ref.read(userProvider.notifier).incrementDeliveredPackageCount();
    if (!context.mounted) return; // Widget dispose olmuşsa işlemi durdur
    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

 Future<void> _handleCameraTap(BuildContext context, WidgetRef ref, Customer customer) async {
  final PermissionStatus status = await Permission.camera.request();
   if (status.isGranted) {
    print("Camera permission granted");
  } else if (status.isDenied) {
    print("Camera permission denied, requesting...");
    await Permission.camera.request();
  } else if (status.isPermanentlyDenied) {
    print("Camera permission permanently denied. Open settings.");
    openAppSettings();
  }

  final ImagePicker imagePicker = ImagePicker();
  final XFile? image = await imagePicker.pickImage(
    source: ImageSource.camera,
    imageQuality: 80, // Adjust image quality if needed
  );

  if (image != null) {
    final storageRef = FirebaseStorage.instance.ref().child('photos/${customer.id}.png');
    await storageRef.putFile(File(image.path));
    final photoUrl = await storageRef.getDownloadURL();

    final database = FirebaseDatabase.instance.ref(
      'rotaData/${ref.read(firebaseAuthProvider).currentUser!.uid}/customers/${customer.id}',
    );
    await database.update({'photoUrl': photoUrl});

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo saved!')),
      );
    }
  }
}

}