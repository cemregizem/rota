import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/models/customer.dart';
import 'package:rota/providers/auth_provider.dart';
import 'package:rota/providers/customer_list_provider.dart';

final customerDeliverStatusProvider =
    FutureProvider.family<void, Customer>((ref, customer) async {
  // Toggle the deliverStatus before updating

  final newStatus = !customer.deliverStatus;

  final user = ref.read(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw 'User not logged in';
  }

  // Update the deliverStatus in firebase real time database
  final database = FirebaseDatabase.instance
      .ref('rotaData/${user.uid}/customers/${customer.id}');

  await database.update({
    'deliverStatus': newStatus,
  });

  // fetch the customer list and update screen
  await ref.read(customerListProvider.notifier).fetchCustomers();
});
