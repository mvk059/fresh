import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fresh/core/database/database_impl.dart';
import 'package:fresh/core/database/database_interface.dart';
import 'package:fresh/core/network/network_impl.dart';
import 'package:fresh/core/network/network_interface.dart';
import 'package:fresh/core/prefs/preferences_impl.dart';
import 'package:fresh/core/prefs/preferences_interface.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final networkProvider = Provider<NetworkInterface>((ref) => NetworkImpl());

final databaseProvider = Provider<DatabaseInterface>((ref) => DatabaseImpl());

final preferencesProvider = Provider<PreferencesInterface>((ref) {
  final preferences = PreferencesImpl();
  preferences.init();
  return preferences;
});
