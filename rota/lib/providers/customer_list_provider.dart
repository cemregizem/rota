import 'package:firebase_auth/firebase_auth.dart';
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    //firebase te giriş yapmış user ın customer verilerine ulaşırız
    final database =
        FirebaseDatabase.instance.ref('rotaData/${user.uid}/customers');

    // databaseteki customer verileri dinlenir ve bi değişiklikte tetiklenir.
    database.onValue.listen((event) {
      final customersData = event.snapshot.value;

      if (customersData is Map<dynamic, dynamic>) {
        //alınan veriler map tipinde mi
        final List<Customer> customers = [];

        customersData.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
         
            try {
              // Safely cast `value` to Map<String, dynamic>
              final customerMap = _convertMap(value);
              final customer = Customer.fromJson(
                  customerMap); // Use `fromJson` to create customer instance
              customers.add(customer);
            } catch (e) {
              print('Error parsing customer data: $e');
            }
          } else {
            print('Skipping invalid customer data: $value');
          }
        });
        // Sort customers ascending order
        customers.sort(
            (a, b) => (a.customerNumber ?? 0).compareTo(b.customerNumber ?? 0));
        state = customers; // statein değiştiğini garantileriz
      } else {
        print('Customers data is not a valid map: $customersData');
      }
    }, onError: (error) {
      print('Error fetching customers: $error');
    });
  }

  // Clear the customer list
  void clearCustomers() {
    state = [];
  }
  /// Helper function to convert Map<Object?, Object?> to Map<String, dynamic>
Map<String, dynamic> _convertMap(Map<dynamic, dynamic> originalMap) {
  final Map<String, dynamic> convertedMap = {};

  originalMap.forEach((key, value) {
    if (value is Map<dynamic, dynamic>) {
      // Recursively convert nested maps
      convertedMap[key.toString()] = _convertMap(value);
    } else {
      // Convert key to String and assign value
      convertedMap[key.toString()] = value;
    }
  });

  return convertedMap;
}
}
