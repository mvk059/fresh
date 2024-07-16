import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityNotifier extends StateNotifier<List<ConnectivityResult>> {
  ConnectivityNotifier() : super([ConnectivityResult.none]) {
    _init();
  }

  void _init() async {
    // Get the initial connectivity status
    state = await Connectivity().checkConnectivity();

    // Listen for future changes
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      state = results;
    });
  }

  bool get isConnected {
    return state.isNotEmpty && !state.contains(ConnectivityResult.none);
  }
}

final connectivityNotifierProvider = StateNotifierProvider<ConnectivityNotifier, List<ConnectivityResult>>((ref) {
  return ConnectivityNotifier();
});

Future<bool> isConnected() async {
  final connectivityResults = await Connectivity().checkConnectivity();
  return connectivityResults.isNotEmpty && !connectivityResults.contains(ConnectivityResult.none);
}