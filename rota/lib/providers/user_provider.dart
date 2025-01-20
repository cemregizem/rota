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

  /// Clears user data from the state
  void clearUserData() {
    state = null;
  }
}
