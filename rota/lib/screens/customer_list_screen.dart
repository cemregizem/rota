import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/providers/customer_list_provider.dart';

import 'package:rota/screens/customer_detail_screen.dart';
import 'package:rota/components/card.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  @override
  void initState() {
    super.initState();
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
          ? Center(child:Text('There isnt any customer!'))
          : ListView.builder(
              itemCount: customers.length,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemBuilder: (context, index) {
                final customer = customers[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerDetailScreen(customer: customer),
                      ),
                    );
                  },
                  child: CommonCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Package Number: ${customer.packageNumber}',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${customer.name} ${customer.surname}',
                              style: const TextStyle(fontSize: 13),
                            ),
                            Text(
                              customer.deliverStatus ? 'Delivered ✅' : 'Not Delivered ❌',
                              style: TextStyle(
                                fontSize: 13,
                                color: customer.deliverStatus ? Colors.green : Colors.red,
                              ),
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
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
