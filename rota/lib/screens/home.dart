import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/providers/user_provider.dart';
import 'package:rota/services/auth_service.dart';
import 'package:rota/components/bottom_navigation_bar.dart';
import 'package:rota/components/custom_container.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthService authService = AuthService();
    final user = ref.watch(userProvider); // Fetch user from the provider

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // remove the back button
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
              await authService.logout(ref, context);
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          CustomContainer(
            child: Column(
              children: [
                Text(
                  'Welcome ${user?.name ?? 'User'} ${user?.surname ?? ''}!',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF244D3E),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'License Plate: ${user?.licensePlate ?? ''}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF244D3E),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Package Count: ${user?.packageCount ?? ''}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF244D3E),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Delivered Package Count: ${user?.deliveredPackageCount ?? ''}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF244D3E),
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
