import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/providers/auth_provider.dart';
import 'package:rota/providers/customer_list_provider.dart';
import 'package:rota/providers/package_provider.dart';
import 'package:rota/screens/home.dart';
import 'package:rota/screens/login_screen.dart';

class AuthService {


  Future<void> login(
      WidgetRef ref, String email, String password, BuildContext context) async {
    try {
      // Attempt to login using the authControllerProvider
      await ref.read(authControllerProvider).login(email, password);

      // Get the customer list (replace with actual logic if needed)
      final customers = ref.read(customerListProvider);

      // Navigate to the home screen with the customer list
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProviderScope(
            overrides: [
              userEmailProvider.overrideWithValue(email),
            ],
            child: HomeScreen(customers: customers),
          ),
        ),
      );
    } catch (e) {
      // Show error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

    Future<void> logout(WidgetRef ref, BuildContext context) async {
    try {
      await ref.read(authControllerProvider).logout();  // Call logout from authControllerProvider

      // After successful logout, navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }
   Future<void> register(
      WidgetRef ref, String email, String password, BuildContext context) async {
    try {
      // Call the registration method from the authControllerProvider
      await ref.read(authControllerProvider).signUp(email, password);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful!')),
      );

      // Navigate to the login screen after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      // Show error message if registration fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  


}
