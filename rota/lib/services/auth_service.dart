import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/providers/auth_provider.dart';
import 'package:rota/providers/customer_list_provider.dart';
import 'package:rota/providers/customer_provider.dart';
import 'package:rota/providers/package_provider.dart';
import 'package:rota/providers/state_provider.dart';
import 'package:rota/screens/home.dart';
import 'package:rota/screens/login_screen.dart';

class AuthService { 
  
  Future<void> login(
      WidgetRef ref, String email, String password, BuildContext context) async {
    try {
      // Attempt to login using the authControllerProvider
      await ref.read(authControllerProvider).login(email, password);

      // Get the customer list 
      final customers = ref.read(customerListProvider);
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

    Future<void> logout(WidgetRef ref, BuildContext context) async {
    try {
      await ref.read(authControllerProvider).logout();  // Call logout from authControllerProvider

    // Polylines'ı güncellemek için doğru yöntem
    ref.read(polylineStateProvider.notifier).updatePolyline([]); 

    ref.read(customerProvider.notifier).clearCustomerData(); // Müşteri verilerini sıfırlama

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  


}
