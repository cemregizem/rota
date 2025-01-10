import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/models/customer.dart';
import 'package:rota/providers/auth_provider.dart';
import 'package:rota/providers/customer_list_provider.dart';

final customerDeliverStatusProvider = FutureProvider.family<void, Customer>((ref, customer) async {
  // Toggle the deliverStatus before updating
  print('hello');
  final newStatus = !customer.deliverStatus;
print('burada');
   final user = ref.read(firebaseAuthProvider).currentUser;
    if (user == null) {
      throw 'User not logged in';
    }
    print ('hellooo');

  // Update the deliverStatus in Firebase
  final database = FirebaseDatabase.instance.ref('customers/${user.uid}/${customer.id}');
  print('User UID: ${user.uid}');
  print('Customer ID: ${customer.id}');

  await database.update({
    'deliverStatus': newStatus,
  });

  // Optionally, you could trigger a re-fetch or update locally here.
  // This will fetch the customer list again and update the UI.
  await ref.read(customerListProvider.notifier).fetchCustomers();
});
