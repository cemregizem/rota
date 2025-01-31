import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/notifiers/user_notifier.dart';
import 'package:rota/services/auth_service.dart';
import 'package:rota/components/bottom_navigation_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthService authService = AuthService();
    final user = ref.watch(userNotifierProvider); // Fetch user from the provider

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
              await authService.logout(ref, context);
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
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
                const SizedBox(height: 5),
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
                const SizedBox(height: 5),
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
                const SizedBox(height: 5),
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
