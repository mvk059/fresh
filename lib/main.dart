import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fresh/app/providers.dart';
import 'package:fresh/core/sync/sync_notifier.dart';
import 'package:fresh/core/utils/connectivity_notifier.dart';

import 'features/auth/presentation/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(preferencesProvider).init();

  // Trigger initial sync
  container.read(syncServiceProvider.notifier).syncIfNeeded();

  container.read(connectivityNotifierProvider.notifier);

  // Set up auto-sync
  container.listen<List<ConnectivityResult>>(
    connectivityNotifierProvider,
    (_, nextConnectivity) {
      if (nextConnectivity.isNotEmpty && nextConnectivity.first != ConnectivityResult.none) {
        container.read(syncServiceProvider.notifier).syncIfNeeded();
      }
    },
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fresh",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}
