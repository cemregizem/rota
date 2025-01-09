import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/providers/customer_list_provider.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch customers from Firebase when the screen loads
    ref.read(customerListProvider.notifier).fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customerListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer List'),
        centerTitle: true,
      ),
      body: customers.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: customers.length,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemBuilder: (context, index) {
                final customer = customers[index];

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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
                        // Name and surname displayed side by side
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${customer.name} ${customer.surname}',
                              style: const TextStyle(
                                fontSize: 13,
                               
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Phone number
                        Text(
                          'Phone: ${customer.phone}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Address
                        Text(
                          'Address: ${customer.address}',
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add logic for "Rota oluştur" button
          print('Rota oluştur button pressed');
        },
        label: const Text('Rota oluştur'),
        icon: const Icon(Icons.map),
      ),
    );
  }
}
