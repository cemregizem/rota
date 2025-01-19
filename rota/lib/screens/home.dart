import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/models/customer.dart';
import 'package:rota/providers/auth_provider.dart';
import 'package:rota/providers/customer_list_provider.dart';
import 'package:rota/providers/location_provider.dart';
import 'package:rota/services/auth_service.dart';
import 'package:rota/components/bottom_navigation_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key, required this.customers}) : super(key: key);
  //List<Consumer> parametre olarak alırız.Map üzerinde göstereceğimiz için
  final List<Customer> customers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
     final AuthService _authService = AuthService();

    // Retrieve the current user
    final currentUser = ref.read(firebaseAuthProvider).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'The Route',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFFDC2A34),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Ensure logout is wrapped in an async function
              await _authService.logout(ref, context);
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            alignment:Alignment.centerLeft,
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  
                ),
              ],
            ),
            child: Text(
              'Welcome ${currentUser?.email ?? 'User !'}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF244D3E),
              ),
            ),
          ),
          // Add more widgets or content below
          Expanded(
            child: Column(
              children: [
                 Container(
                  child: const Text(
                    'Packages count:',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Container(
                  child: const Text(
                    'Delivered package count:',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
