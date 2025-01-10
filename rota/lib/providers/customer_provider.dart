import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';

final customerProvider =
    StateNotifierProvider<CustomerNotifier, Map<String, dynamic>>((ref) {
  return CustomerNotifier();
});

class CustomerNotifier extends StateNotifier<Map<String, dynamic>> {
  CustomerNotifier() : super({});

  // Update customer details in state
 void updateField(String key, dynamic value) {
  state = {...state, key: value};  // Update the state map with the new key-value pair
}

  // Save to Firebase Realtime Database
  Future<void> saveToFirebase() async {
     final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('No user is logged in');
    return;
  }
    final database = FirebaseDatabase.instance.ref('customers/${user.uid}');

    // Push a new customer record to the 'customers' node
    await database.push().set({
      'packageNumber':state['packageNumber'],
      'name': state['name'],
      'surname': state['surname'],
      'phone': state['phone'],
      'location': {
        'latitude': state['location'].latitude,
        'longitude': state['location'].longitude,
      }, // Store LatLng as a string
      'address': state['address'],
      'deliverStatus':false,
    });
  }
  
}
