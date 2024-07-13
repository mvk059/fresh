import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fresh/app/providers.dart';
import 'package:fresh/features/auth/state/login_notifier.dart';
import 'package:fresh/features/auth/state/login_state.dart';

import '../../main/main_screen.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref.watch(preferencesProvider));
});

class LoginScreen extends ConsumerWidget {
  final TextEditingController _phoneController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final loginState = ref.watch(loginProvider);

    ref.listen<LoginState>(loginProvider, (_, state) {
      if (state.error == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => MainScreen()),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  ref.read(loginProvider.notifier).login(_phoneController.text);
                },
                child: const Text('Send OTP')),
          ],
        ),
      ),
    );
  }
}
