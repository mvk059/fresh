import 'package:fresh/core/database/database_impl.dart';
import 'package:fresh/core/database/database_interface.dart';
import 'package:fresh/core/network/network_impl.dart';
import 'package:fresh/core/network/network_interface.dart';
import 'package:fresh/core/prefs/preferences_impl.dart';
import 'package:fresh/core/prefs/preferences_interface.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
NetworkInterface network(NetworkRef ref) => NetworkImpl();

@riverpod
DatabaseInterface database(DatabaseRef ref) => DatabaseImpl();

final preferencesProvider = Provider<PreferencesInterface>((ref) {
  final preferences = PreferencesImpl();
  preferences.init();
  return preferences;
});
