import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main_screen.dart';

class LoginNotifier extends StateNotifier<AsyncValue<bool>> {

  LoginNotifier(super.state);

  Future<void> login() async {
    state = const AsyncValue.loading();
    try {
      // Simulate verification
      await Future.delayed(const Duration(seconds: 2));
      state = const AsyncValue.data(true);
    } catch(e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

class LoginScreen extends ConsumerWidget {
  final TextEditingController _phoneController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const MainScreen())
                  );
                },
                child: const Text('Send OTP')
            ),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }

}