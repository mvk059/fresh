import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
//   return Connectivity().onConnectivityChanged;
// });
//
// Future<bool> isConnected() async {
//   final connectivityResult = await (Connectivity().checkConnectivity());
//   return !connectivityResult.contains(ConnectivityResult.none);
// }