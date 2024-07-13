import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fresh/core/database/database_interface.dart';
import 'package:fresh/features/maps/state/maps_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsNotifier extends StateNotifier<MapsState> {
  final DatabaseInterface _database;

  MapsNotifier(this._database) : super(MapsState()) {
    loadMarkers();
  }

  Future<void> loadMarkers() async {
    state = MapsState(isLoading: true);
    try {
      final coordinates = await _database.query('coordinates');
      final markers = coordinates.map((coord) {
        return Marker(
          markerId: MarkerId(coord['id'].toString()),
          position: LatLng(coord['latitude'], coord['longitude']),
        );
      }).toSet();
      state = MapsState(markers: markers);
    } catch (e) {
      state = MapsState(error: e.toString());
    }
  }
}