import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/providers/user_provider.dart';
import 'package:rota/services/auth_service.dart';
import 'package:rota/components/bottom_navigation_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    Key? key,
    
  }) : super(key: key);
 
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthService _authService = AuthService();
    final user = ref.watch(userProvider); // Fetch user from the provider

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
          SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
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
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome ${user?.name ?? 'User'} ${user?.surname ?? ''}!',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF244D3E),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'License Plate: ${user?.licensePlate ?? ''}',
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF244D3E),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                 Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Package Count: ${user?.packageCount ?? ''}',
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF244D3E),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Delivered Package Count: ${user?.deliveredPackageCount ?? ''}',
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF244D3E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Add more widgets or content below
         
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
