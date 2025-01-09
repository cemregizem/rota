import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Future<void> signUp(String email, String password) async {
    try {
      await _ref.read(firebaseAuthProvider).createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
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
    } catch (e) {
      rethrow;
    }
  }

  // Logout function
  Future<void> logout() async {
    await _ref.read(firebaseAuthProvider).signOut();
  }
}
