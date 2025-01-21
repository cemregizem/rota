import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rota/models/user.dart';

/// A provider for fetching and storing user data
final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(null);

  /// Fetches user data from Firebase and updates state
  Future<void> fetchUserData(String userId) async {
    try {
      final DatabaseReference dbRef =
          FirebaseDatabase.instance.ref().child('rotaData/$userId/userInfo');
      final DataSnapshot snapshot = await dbRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final user = UserModel.fromMap(data);
        state = user; // Update the state with the fetched user data
      } else {
        throw Exception('User data not found.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      rethrow;
    }
  }

    /// Increment the package count and update Firebase
  Future<void> incrementPackageCount() async {
    // Fetch the userId from the current Firebase user
  final userId = FirebaseAuth.instance.currentUser?.uid;
     
    if (state == null) {
      throw Exception('User data is not available.');
    }

    try {
      final newPackageCount = state!.packageCount + 1;
      final DatabaseReference dbRef =
          FirebaseDatabase.instance.ref().child('rotaData/$userId/userInfo');

      await dbRef.update({'packageCount': newPackageCount});

      // Update the local state with a new instance of UserModel
      state = UserModel(
        name: state!.name,
        surname: state!.surname,
        licensePlate: state!.licensePlate,
        packageCount: newPackageCount,
        deliveredPackageCount: state!.deliveredPackageCount,
      );
    } catch (e) {
      print('Error incrementing package count: $e');
      rethrow;
    }
  }

    /// Increment the  delivered package count and update Firebase
  Future<void> incrementDeliveredPackageCount() async {
    // Fetch the userId from the current Firebase user
  final userId = FirebaseAuth.instance.currentUser?.uid;
     
    if (state == null) {
      throw Exception('User data is not available.');
    }

    try {
      final newDeliveredPackageCount = state!.deliveredPackageCount + 1;
      final DatabaseReference dbRef =
          FirebaseDatabase.instance.ref().child('rotaData/$userId/userInfo');

      await dbRef.update({'deliveredPackageCount': newDeliveredPackageCount});

      // Update the local state with a new instance of UserModel
      state = UserModel(
        name: state!.name,
        surname: state!.surname,
        licensePlate: state!.licensePlate,
        packageCount: state!.packageCount,
        deliveredPackageCount: newDeliveredPackageCount,
      );
    } catch (e) {
      print('Error incrementing package count: $e');
      rethrow;
    }
  }

  /// Clears user data from the state
  void clearUserData() {
    state = null;
  }
}
