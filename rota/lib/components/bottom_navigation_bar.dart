import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/providers/user_provider.dart';
import 'package:rota/screens/customer_list_screen.dart';
import 'package:rota/screens/map_screen.dart';
import 'package:rota/screens/new_customer_screen.dart';
import 'package:rota/screens/home.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);
   
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        ref.read(currentIndexProvider.notifier).state = index;
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MapScreen(customers: []),
              ),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CustomerListScreen(),
              ),
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CustomerScreen(),
              ),
            );
            break;
          
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: currentIndex == 0
              ? const Icon(Icons.house, color: Colors.white)
              : const Icon(Icons.house_outlined, color: Colors.white),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: currentIndex == 1
              ? const Icon(Icons.map, color: Colors.white)
              : const Icon(Icons.map_outlined, color: Colors.white),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: currentIndex == 2
              ? const Icon(Icons.list, color: Colors.white)
              : const Icon(Icons.list_outlined, color: Colors.white),
          label: 'Customer List',
        ),
        
        BottomNavigationBarItem(
          icon: currentIndex == 3
              ? const Icon(Icons.person_add_alt_1, color: Colors.white)
              : const Icon(Icons.person_add_alt_outlined, color: Colors.white),
          label: 'Add Customer',
        ),
      ],
      backgroundColor: const Color(0xFF244D3E), // Background color
      selectedItemColor: Colors.white, // Selected icon and text color
      unselectedItemColor: Colors.white70, // Unselected icon and text color
      showUnselectedLabels: true, // Show labels for unselected items
      type: BottomNavigationBarType.fixed, // Ensure equal spacing for all items
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
      elevation: 8.0, // Add elevation for shadow effect
    );
  }
}
