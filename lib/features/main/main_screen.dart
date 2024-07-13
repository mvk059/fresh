import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fresh/app/providers.dart';
import 'package:fresh/features/auth/presentation/login_screen.dart';
import 'package:fresh/features/home/ui/home_screen.dart';
import 'package:fresh/features/maps/ui/maps_screen.dart';
import 'package:fresh/features/profile/ui/profile_screen.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final preferences = ref.watch(preferencesProvider);

    return FutureBuilder<String?>(
      future: preferences.getString('phone_number'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return LoginScreen();
        }

        final List<Widget> _screens = [
          HomeScreen(),
          MapsScreen(),
          ProfileScreen(),
        ];

        return Scaffold(
          body: _screens[selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) => ref.read(selectedIndexProvider.notifier).state = index,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Maps'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}