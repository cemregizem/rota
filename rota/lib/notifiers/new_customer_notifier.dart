import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';



part 'new_customer_notifier.g.dart'; // Bu satırı ekleyin

@riverpod
class CustomerNotifier extends _$CustomerNotifier {
  @override
  Map<String, dynamic> build() {
    return {};
  }

  Future<int> getCustomerCount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is logged in');
      return 0;
    }

    final database = FirebaseDatabase.instance.ref('rotaData/${user.uid}/customers');
    final snapshot = await database.get();
    final data = snapshot.value as Map? ?? {};

    return data.isEmpty ? 1 : data.length + 1;
  }

  void updateField(String key, dynamic value) {
    state = {...state, key: value};
  }

  Future<void> saveToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is logged in');
      return;
    }

    final database = FirebaseDatabase.instance.ref('rotaData/${user.uid}/customers');
    int customerNumber = await getCustomerCount();

    await database.push().set({
      'packageNumber': state['packageNumber'],
      'name': state['name'],
      'surname': state['surname'],
      'phone': state['phone'],
      'location': {
        'latitude': state['location'].latitude,
        'longitude': state['location'].longitude,
      },
      'address': state['address'],
      'deliverStatus': false,
      'customerNumber': customerNumber,
    });
  }

  void clearCustomerData() {
    state = {};
  }
}