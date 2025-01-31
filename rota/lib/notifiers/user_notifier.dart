import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rota/models/user.dart';


part 'user_notifier.g.dart'; // Bu satırı ekleyin

@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  UserModel? build() {
    return null;
  }

  /// Fetches user data from Firebase and updates state
  Future<void> fetchUserData(String userId) async {
    try {
      final DatabaseReference dbRef =
          FirebaseDatabase.instance.ref().child('rotaData/$userId/userInfo');
      final DataSnapshot snapshot = await dbRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final UserModel user = UserModel.fromJson(Map<String, dynamic>.from(data));


        state = user;
 // Update the state with the fetched user data
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
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (state == null) {
      throw Exception('User data is not available.');
    }

    try {
      final newPackageCount = state!.packageCount + 1;
      final DatabaseReference dbRef =
          FirebaseDatabase.instance.ref().child('rotaData/$userId/userInfo');

      await dbRef.update({'packageCount': newPackageCount});

      // Update the local state with a new instance of User
      state = state!.copyWith(packageCount: newPackageCount);
    } catch (e) {
      print('Error incrementing package count: $e');
      rethrow;
    }
  }

  /// Increment the delivered package count and update Firebase
  Future<void> incrementDeliveredPackageCount() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (state == null) {
      throw Exception('User data is not available.');
    }

    try {
      final newDeliveredPackageCount = state!.deliveredPackageCount + 1;
      final DatabaseReference dbRef =
          FirebaseDatabase.instance.ref().child('rotaData/$userId/userInfo');

      await dbRef.update({'deliveredPackageCount': newDeliveredPackageCount});

      // Update the local state with a new instance of User
      state = state!.copyWith(deliveredPackageCount: newDeliveredPackageCount);
    } catch (e) {
      print('Error incrementing delivered package count: $e');
      rethrow;
    }
  }

  /// Clears user data from the state
  void clearUserData() {
    state = null;
  }
}