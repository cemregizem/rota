import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/models/customer.dart'; // Import the Customer model

final customerListProvider =
    StateNotifierProvider<CustomerListNotifier, List<Customer>>((ref) {
  return CustomerListNotifier();
});

class CustomerListNotifier extends StateNotifier<List<Customer>> {
  CustomerListNotifier() : super([]);

  Future<void> fetchCustomers() async {
    final database = FirebaseDatabase.instance.ref('customers');

    // Listen for changes in the 'customers' node
    database.onValue.listen((event) {
      final customersData = event.snapshot.value;

      if (customersData is Map<dynamic, dynamic>) {
        final List<Customer> customers = [];

        customersData.forEach((key, value) {
          if (value is Map) {
            // Safely cast `value` to Map<String, dynamic>
            final customerMap = Map<String, dynamic>.from(value);
            customers.add(Customer.fromMap(key, customerMap));
          } else {
            print('Skipping invalid customer data: $value');
          }
        });

        state = customers; // Update the state with the fetched customer list
      } else {
        print('Customers data is not a valid map: $customersData');
      }
    }, onError: (error) {
      print('Error fetching customers: $error');
    });
  }
}
