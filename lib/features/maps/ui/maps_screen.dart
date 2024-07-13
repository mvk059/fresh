import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fresh/app/providers.dart';
import 'package:fresh/core/utils/connectivity.dart';
import 'package:fresh/features/maps/state/maps_notifier.dart';
import 'package:fresh/features/maps/state/maps_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final mapsProvider = StateNotifierProvider<MapsNotifier, MapsState>((ref) {
  return MapsNotifier(ref.watch(databaseProvider));
});

class MapsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapsState = ref.watch(mapsProvider);
    final connectivity = ref.watch(connectivityProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Maps')),
      body: Column(
        children: [
          Expanded(
            child: mapsState.isLoading
                ? Center(child: CircularProgressIndicator())
                : mapsState.error != null
                    ? Center(child: Text(mapsState.error!))
                    : GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: mapsState.markers.isNotEmpty
                              ? mapsState.markers.first.position
                              : LatLng(0, 0),
                          zoom: 2,
                        ),
                        markers: mapsState.markers,
                      ),
          ),
          connectivity.when(
            data: (status) => Container(
              color:
                  status == ConnectivityResult.none ? Colors.red : Colors.green,
              padding: EdgeInsets.all(8),
              child: Text(
                status == ConnectivityResult.none ? 'Offline' : 'Online',
                style: TextStyle(color: Colors.white),
              ),
            ),
            loading: () => SizedBox(),
            error: (_, __) => SizedBox(),
          ),
        ],
      ),
    );
  }
}
