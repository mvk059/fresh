import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fresh/app/providers.dart';
import 'package:fresh/core/utils/connectivity.dart';
import 'package:fresh/core/utils/connectivity_notifier.dart';
import 'package:fresh/features/auth/presentation/login_screen.dart';
import 'package:fresh/features/profile/state/profile_notifier.dart';
import 'package:fresh/features/profile/state/profile_state.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(ref.watch(preferencesProvider));
});

class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final connectivity = ref.watch(connectivityNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(title: Text('Phone: ${profileState.phoneNumber ?? 'Not logged in'}')),
                ListTile(title: Text('Settings'), onTap: () {}),
                ListTile(title: Text('History'), onTap: () {}),
                ListTile(
                  title: Text('Logout'),
                  onTap: () async {
                    final success = await ref.read(profileProvider.notifier).logout();
                    if (success) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No internet connection. Please try again when online.')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final connectivityNotifier = ref.watch(connectivityNotifierProvider.notifier);
              final isConnected = connectivityNotifier.isConnected;

              return Container(
                color: isConnected ? Colors.green : Colors.red,
                padding: EdgeInsets.all(8),
                child: Text(
                  isConnected ? 'Online' : 'Offline',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}