import 'package:flutter_riverpod/flutter_riverpod.dart';

// A simple provider to manage user data
final userEmailProvider = Provider<String>((ref) {
  return 'No email provided'; // Default value
});
