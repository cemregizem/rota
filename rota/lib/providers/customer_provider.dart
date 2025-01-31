import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:latlong2/latlong.dart';
import 'package:rota/models/customer.dart';
//StateProvider basit değişken dataları tutmak için kullanılır
final customerProvider =
    StateNotifierProvider<CustomerNotifier, Customer>((ref) {
  return CustomerNotifier();
});

class CustomerNotifier extends StateNotifier<Customer> {//Müşteri bilgilerini bir map gibi sakladıgımız StateNotifier sınıfı

   CustomerNotifier() : super(Customer.initial());

   // Fetch the current customer count for the logged-in user
  Future<int> getCustomerCount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is logged in');
      return 0;  // Return 0 if the user is not logged in
    }

    final database = FirebaseDatabase.instance.ref('rotaData/${user.uid}/customers');
    final snapshot = await database.get();
    final data = snapshot.value as Map? ?? {};

    
    return data.isEmpty ? 1 : data.length + 1;
  }



   void updateCustomer({String? packageNumber, String? name, String? surname, String? phone, LatLng? location, String? address}) {
    state = state.copyWith(
      packageNumber: packageNumber ?? state.packageNumber,
      name: name ?? state.name,
      surname: surname ?? state.surname,
      phone: phone ?? state.phone,
      location: location ?? state.location,
      address: address ?? state.address,
    );
  }

  // Save to Firebase Realtime Database
  Future<void> saveToFirebase() async {
     final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('No user is logged in');
    return;
  }
    final database = FirebaseDatabase.instance.ref('rotaData/${user.uid}/customers');
    //giriş yapmış kullanıcıya yeni customer ekler.
    
    
    // Get the current customer count to assign a customer number
    int customerNumber = await getCustomerCount() ;
    // Save customer data using Freezed `toJson()`
    await database.push().set(state.copyWith(customerNumber: customerNumber).toJson());


  }

    // Müşteri verilerini sıfırlamak için kullanılan metot
  void clearCustomerData() {
     state = Customer.initial();  // Reset to initial state
  }
  
}
