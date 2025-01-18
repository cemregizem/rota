import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
//StateProvider basit değişken dataları tutmak için kullanılır
final customerProvider =
    StateNotifierProvider<CustomerNotifier, Map<String, dynamic>>((ref) {
  return CustomerNotifier();
});

class CustomerNotifier extends StateNotifier<Map<String, dynamic>> {//Müşteri bilgilerini bir map gibi sakladıgımız StateNotifier sınıfı

  CustomerNotifier() : super({});  


 void updateField(String key, dynamic value) {
  state = {...state, key: value};  // Müşteri bilgilerinde bir alanı günceller.
}                                  //Yeni müşteri yaratma alanında key value değerleriyle state değiştirilir. 


  // Save to Firebase Realtime Database
  Future<void> saveToFirebase() async {
     final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('No user is logged in');
    return;
  }
    final database = FirebaseDatabase.instance.ref('customers/${user.uid}');
    //giriş yapmış kullanıcıya yeni customer ekler.

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

    // Müşteri verilerini sıfırlamak için kullanılan metot
  void clearCustomerData() {
    state = {};  // Müşteri verilerini sıfırla
  }
  
}
