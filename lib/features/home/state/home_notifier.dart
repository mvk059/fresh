import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fresh/core/database/database_interface.dart';
import 'package:fresh/core/sync/sync_notifier.dart';
import 'package:fresh/core/utils/connectivity.dart';
import 'package:fresh/features/home/state/home_state.dart';
import 'package:fresh/core/utils/constants.dart' as constants;

class HomeNotifier extends StateNotifier<HomeState> {
  final DatabaseInterface _database;
  final SyncNotifier _syncNotifier;

  HomeNotifier(this._database, this._syncNotifier) : super(HomeState()) {
    loadCoordinates();
  }

  Future<void> loadCoordinates() async {
    state = HomeState(isLoading: true);
    try {
      final coordinates = await _database.query(constants.coordinates);
      state = HomeState(coordinates: coordinates);
    } catch (e) {
      state = HomeState(error: e.toString());
    }
  }

  Future<void> addCoordinate(double latitude, double longitude) async {
    try {
      await _database.insert('coordinates', {
        'latitude': latitude,
        'longitude': longitude,
        'synced': 0,
      });
      await loadCoordinates();
      if (await isConnected()) {
        await _syncNotifier.syncCoordinates();
        await loadCoordinates();
      }
    } catch (e) {
      state = HomeState(error: e.toString(), coordinates: state.coordinates);
    }
  }

  Future<void> syncCoordinates() async {
    if (await isConnected()) {
      try {
        await _syncNotifier.syncCoordinates();
        await loadCoordinates();
      } catch (e) {
        state = HomeState(error: e.toString(), coordinates: state.coordinates);
      }
    } else {
      state = HomeState(error: 'No internet connection', coordinates: state.coordinates);
    }
  }
}