import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rota/models/customer.dart';
import 'package:rota/providers/auth_provider.dart';
import 'package:rota/notifiers/customer_list_notifier.dart';

part 'customer_delivered_notifier.g.dart'; // Bu satırı ekleyin

@riverpod
Future<void> customerDeliverStatus(
  CustomerDeliverStatusRef ref, {
  required Customer customer,
}) async {
  // Toggle the deliverStatus before updating
  final newStatus = !customer.deliverStatus;

  final user = ref.read(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw 'User not logged in';
  }

  // Update the deliverStatus in Firebase Realtime Database
  final database = FirebaseDatabase.instance
      .ref('rotaData/${user.uid}/customers/${customer.id}');

  await database.update({
    'deliverStatus': newStatus,
  });

  // Fetch the customer list and update the screen
  await ref.read(customerListNotifierProvider.notifier).fetchCustomers();
}