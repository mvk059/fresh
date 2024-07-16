import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fresh/core/database/database_interface.dart';
import 'package:fresh/core/sync/sync_notifier.dart';
import 'package:fresh/core/sync/sync_state.dart';
import 'package:fresh/core/utils/connectivity.dart';
import 'package:fresh/core/utils/connectivity_notifier.dart';
import 'package:fresh/features/home/state/home_state.dart';
import 'package:fresh/core/utils/constants.dart' as constants;

class HomeNotifier extends StateNotifier<HomeState> {
  final DatabaseInterface _database;
  final SyncNotifier _syncNotifier;
  final Ref _ref;

  HomeNotifier(this._database, this._syncNotifier, this._ref) : super(HomeState()) {
    loadCoordinates();
    // _listenToSyncChanges();
    _ref.listen(syncServiceProvider, (_, next) {
      if (next.isSyncComplete) {
        loadCoordinates();
      }
    });
  }

  void _listenToSyncChanges() {
    _ref.listen<SyncState>(syncServiceProvider, (previous, next) {
      if (next.isSyncComplete) {
        loadCoordinates();
      }
    });
  }

  Future<void> loadCoordinates() async {
    state = HomeState(isLoading: true);
    try {
      final coordinates = await _database.query(constants.coordinates);
      final reversedCoordinates = coordinates.reversed.toList();
      state = HomeState(coordinates: reversedCoordinates);
    } catch (e) {
      state = HomeState(error: e.toString());
    }
  }

  Future<void> addCoordinate(double latitude, double longitude) async {
    try {
      final newCoordinate = {
        'latitude': latitude,
        'longitude': longitude,
        'synced': 0,
      };
      await _database.insert('coordinates', newCoordinate);

      // Update the state by adding the new coordinate to the beginning of the list
      state = HomeState(
        coordinates: [newCoordinate, ...state.coordinates],
        error: state.error,
      );

      if (await isConnected()) {
        await _syncNotifier.syncCoordinates();
        await loadCoordinates();
      }
    } catch (e) {
      state = HomeState(error: e.toString(), coordinates: state.coordinates);
    }
  }

  // Future<void> syncCoordinates() async {
  //   if (await isConnected()) {
  //     try {
  //       await _syncNotifier.syncCoordinates();
  //       await loadCoordinates();
  //     } catch (e) {
  //       state = HomeState(error: e.toString(), coordinates: state.coordinates);
  //     }
  //   }
  //   // else {
  //   //   state = HomeState(error: 'No internet connection', coordinates: state.coordinates);
  //   // }
  // }

  Future<void> syncCoordinates() async {
    if (await isConnected()) {
      await _syncNotifier.syncCoordinates();
      await loadCoordinates();
    } else {
      state = HomeState(error: 'No internet connection', coordinates: state.coordinates);
    }
  }
}