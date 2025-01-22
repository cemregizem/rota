import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:rota/components/bottom_navigation_bar.dart';
import 'package:rota/providers/customer_provider.dart';
import 'package:rota/providers/user_provider.dart';
import 'package:rota/screens/location_selection_screen.dart';
import 'package:rota/screens/map_screen.dart';

class CustomerScreen extends ConsumerStatefulWidget {
  const CustomerScreen({super.key});
//const CustomerScreen({Key? key}) : super(key: key); yerine super kullanabiliriz.
//key'i constructor içinde ayrı olarak initialize etmeye gerek kalmaz.
  @override
  ConsumerState<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends ConsumerState<CustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  LatLng? selectedLocation; //kullanıcı tarafından seçilen lokasyonu tutar
  late TextEditingController _addressController; // Controller for address field

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(); // Initialize controller
  }

  @override
  Widget build(BuildContext context) {
    final customerData = ref.watch(customerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Customer',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                      .read(customerProvider
                          .notifier) //müşteri verisini güncellenir.
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
                    labelText: 'Select Location for address',
                    border: OutlineInputBorder(),
                  ),
                  controller: _addressController,
                  readOnly: true, // Make the field read-only
                ),
                const SizedBox(height: 16),

                // Location Select Button
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

                      try {
                        // koordinatları kullanarak ters geocoding işlemi yapan bir fonksiyon
                        final placemarks = await placemarkFromCoordinates(
                          location.latitude,
                          location.longitude,
                        );
                        if (placemarks.isNotEmpty) {
                          final place = placemarks.first;
                          final formattedAddress =
                              '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
                          //Alnınan yer bilgileri bu formatta birleştirilir.
                          ref
                              .read(customerProvider.notifier)
                              .updateField('address', formattedAddress);
                          //Alınan yer bilgileri customerProvider a kaydedilir
                          _addressController.text = formattedAddress;
                        } else {
                          throw Exception('No placemarks found.');
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to get address: $e')),
                          );
                        }
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

                      await ref
                          .read(userProvider.notifier)
                          .incrementPackageCount();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Customer added successfully!')),
                        );
                      }

                      _addressController.clear(); // Clear address field
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const MapScreen(customers: []),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please complete all fields')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Add Customer'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
