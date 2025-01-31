import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/models/customer.dart';
import 'package:rota/providers/auth_provider.dart';
import 'package:rota/providers/customer_list_provider.dart';

final customerDeliverStatusProvider =
    FutureProvider.family<void, Customer>((ref, customer) async {
  //  .family modifier has one purpose.Gettting a unique provider based on external parameters
  //Her Customer objesi için teslimat durumu güncelleme işlemi yapmamız gerekiyor.
  
  final newStatus = !customer.deliverStatus; //mevcut teslimat durumu tersine çevriliyor
 //Kullanıcı oturum açmış mı kontrol
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
