import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fresh/app/providers.dart';
import 'package:fresh/core/database/database_interface.dart';
import 'package:fresh/core/network/network_interface.dart';
import 'package:fresh/core/sync/sync_state.dart';
import 'package:fresh/core/utils/constants.dart' as constants;
import 'package:logger/logger.dart';

class SyncNotifier extends StateNotifier<SyncState> {
  final NetworkInterface _network;
  final DatabaseInterface _database;

  final logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 50,
        colors: true,
        printEmojis: true,
        printTime: false,
      )
  );

  SyncNotifier(this._network, this._database) : super(SyncState());

  Future<void> syncCoordinates() async {
    state = SyncState(isSyncing: true);
    try {
      await _syncCoordinates();
      state = SyncState();
    } catch (e) {
      state = SyncState(error: e.toString());
    }
  }

  Future<void> _syncCoordinates() async {
    logger.d('LOGG _syncCoordinates');
    // Get un-synchronized coordinates from local database
    final unSyncedCoordinates = await _database.query('coordinates', where: 'synced = 0');

    logger.d('LOGG unSyncedCoordinates: $unSyncedCoordinates');
    if (unSyncedCoordinates.isNotEmpty) {
      logger.d('LOGG unSyncedCoordinates isNotEmpty');
      // Send un-synchronized coordinates to server
      // final syncedCoordinates = await _network.syncCoordinates(unSyncedCoordinates);

      // logger.d('LOGG syncedCoordinates $syncedCoordinates');
      // Update local database with synced status
      for (var coord in unSyncedCoordinates) {
        await _database.update('coordinates', {'synced': 1}, 'id = ${coord['id']}');
      }
    }

    // Get all coordinates from server
    final serverCoordinates = await _network.get('coordinates');
    logger.d('LOGG serverCoordinates $serverCoordinates');

    // Update local database with server data
    // for (var coord in serverCoordinates['coordinates']) {
    //   await _database.insert('coordinates', {...coord, 'synced': 1});
    // }

    // final updatedCoordinates =  await _database.query('coordinates', where: 'synced = 0');
    // logger.d('LOGG updatedCoordinates: $updatedCoordinates');

  }
}

final syncServiceProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier(
      ref.watch(networkProvider),
      ref.watch(databaseProvider)
  );
});