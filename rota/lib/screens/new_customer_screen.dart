import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart'; // For reverse geocoding
import 'package:rota/providers/customer_provider.dart';
import 'package:rota/screens/location_selection_screen.dart';

class CustomerScreen extends ConsumerStatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends ConsumerState<CustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  LatLng? selectedLocation;
  String? address;

  @override
  Widget build(BuildContext context) {
    final customerData = ref.watch(customerProvider);
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Customer'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Customer Details',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Package Number field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Package Number',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => ref
                      .read(customerProvider.notifier)
                      .updateField('packageNumber', value),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a package number'
                      : null,
                ),
                const SizedBox(height: 16),

                // Name field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => ref
                      .read(customerProvider.notifier)
                      .updateField('name', value),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a name'
                      : null,
                ),
                const SizedBox(height: 16),

                // Surname field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Surname',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => ref
                      .read(customerProvider.notifier)
                      .updateField('surname', value),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a surname'
                      : null,
                ),
                const SizedBox(height: 16),

                // Phone number field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => ref
                      .read(customerProvider.notifier)
                      .updateField('phone', value),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a phone number'
                      : null,
                ),
                const SizedBox(height: 16),

                // Address field (auto-filled)
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: address),
                  readOnly: true, // Make the field read-only
                ),
                const SizedBox(height: 16),

                // Location Selector Button
                ElevatedButton.icon(
                  onPressed: () async {
                    final location = await Navigator.push<LatLng>(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LocationSelectorScreen()),
                    );
                    if (location != null) {
                      ref
                          .read(customerProvider.notifier)
                          .updateField('location', location);
                      setState(() {
                        selectedLocation = location;
                      });

                      try {
                        // Reverse geocoding to get address
                        final placemarks = await placemarkFromCoordinates(
                          location.latitude,
                          location.longitude,
                        );
                        if (placemarks.isNotEmpty) {
                          final place = placemarks.first;
                          final formattedAddress =
                              '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
                          setState(() {
                            address = formattedAddress;
                          });
                          ref
                              .read(customerProvider.notifier)
                              .updateField('address', formattedAddress);
                        } else {
                          throw Exception('No placemarks found.');
                        }
                      } catch (e) {
                        // Handle failure in reverse geocoding
                        setState(() {
                          address = 'Failed to get address';
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to get address: $e')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.location_on),
                  label: const Text('Select Location'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Submit button
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        customerData['location'] != null) {
                      await ref
                          .read(customerProvider.notifier)
                          .saveToFirebase();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Customer added successfully!')),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please complete all fields')),
                      );
                    }
                  },
                  child: const Text('Add Customer'),
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
        ),
      ),
    );
  }
}