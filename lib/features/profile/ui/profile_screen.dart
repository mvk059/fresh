import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fresh/app/providers.dart';
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

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: ListView(
        children: [
          ListTile(
              title: Text(
                  'Phone: ${profileState.phoneNumber ?? 'Not logged in'}')),
          ListTile(title: Text('Settings'), onTap: () {}),
          ListTile(title: Text('History'), onTap: () {}),
          ListTile(
            title: Text('Logout'),
            onTap: () async {
              await ref.read(profileProvider.notifier).logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
