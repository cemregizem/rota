import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rota/models/customer.dart';

part 'customer_list_notifier.g.dart'; // This line remains unchanged

@riverpod
class CustomerListNotifier extends _$CustomerListNotifier {
  @override
  List<Customer> build() {
    return [];
  }

 Future<void> fetchCustomers() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return;
  }

  final database = FirebaseDatabase.instance.ref('rotaData/${user.uid}/customers');

  database.onValue.listen((event) {
    final customersData = event.snapshot.value;

    if (customersData is Map<dynamic, dynamic>) {
      final List<Customer> customers = [];

      customersData.forEach((key, value) {
        if (value is  Map<dynamic, dynamic>) {
          try {
            // Convert the map to Map<String, dynamic>
            final customerMap = value.map<String, dynamic>((k, v) => MapEntry(k.toString(), v));
            // Custom deserialization with the updated Customer model
            final customer = Customer.fromJson(customerMap);
            customers.add(customer);
          } catch (e) {
            print('Error parsing customer data: $e');
            print('Skipping invalid customer data: $value');
          }
        } else {
          print('Skipping invalid customer data: $value');
        }
      });

      customers.sort((a, b) => a.customerNumber.compareTo(b.customerNumber));
      state = customers;
    } else {
      print('Customers data is not a valid map: $customersData');
    }
  }, onError: (error) {
    print('Error fetching customers: $error');
  });
}

  void clearCustomers() {
    state = [];
  }
}
