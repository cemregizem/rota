import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rota/providers/customer_list_provider.dart';

// The FirebaseAuth provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// The AuthController provider
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

class AuthController {
  final Ref _ref;

  AuthController(this._ref);

  // Sign up function
  Future<void> signUp(String email, String password, String name,
      String surname, String licensePlate) async {
    try {
      UserCredential userCredential =
          await _ref.read(firebaseAuthProvider).createUserWithEmailAndPassword(
                email: email,
                password: password,
              );

      // for storing user info
      final user = userCredential.user;

      if (user != null) {
        final DatabaseReference dbRef =
            FirebaseDatabase.instance.ref().child('rotaData/${user.uid}/userInfo');
        await dbRef.set({
          'name': name,
          'surname': surname,
          'licensePlate': licensePlate,
          'email': email,
        });
      }
    } catch (e) {
      print('Error during sign up: $e');
      rethrow;
    }
  }

  // Login function
  Future<void> login(String email, String password) async {
    try {
      await _ref.read(firebaseAuthProvider).signInWithEmailAndPassword(
            email: email,
            password: password,
          );
      // Fetch customer list for the user
      await _ref.read(customerListProvider.notifier).fetchCustomers();
    } catch (e) {
      rethrow;
    }
  }

  // Logout function
  Future<void> logout() async {
    _ref.read(customerListProvider.notifier).clearCustomers();
    await _ref.read(firebaseAuthProvider).signOut();
  }
}
