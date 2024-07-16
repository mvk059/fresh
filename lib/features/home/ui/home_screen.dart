import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fresh/app/providers.dart';
import 'package:fresh/core/sync/sync_notifier.dart';
import 'package:fresh/core/utils/connectivity.dart';
import 'package:fresh/core/utils/connectivity_notifier.dart';
import 'package:fresh/features/home/state/home_notifier.dart';
import 'package:fresh/features/home/state/home_state.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(
      ref.watch(databaseProvider), ref.watch(syncServiceProvider.notifier), ref);
});

class HomeScreen extends ConsumerWidget {
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final connectivity = ref.watch(connectivityNotifierProvider);
    final syncState = ref.watch(syncServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () => ref.read(homeProvider.notifier).syncCoordinates(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _latitudeController,
                    decoration: InputDecoration(labelText: 'Latitude'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _longitudeController,
                    decoration: InputDecoration(labelText: 'Longitude'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final lat = double.tryParse(_latitudeController.text);
                    final lon = double.tryParse(_longitudeController.text);
                    if (lat != null &&
                        lon != null &&
                        lat >= -90 &&
                        lat <= 90 &&
                        lon >= -180 &&
                        lon <= 180) {
                      ref.read(homeProvider.notifier).addCoordinate(lat, lon);
                      _latitudeController.clear();
                      _longitudeController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid coordinates')),
                      );
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: homeState.isLoading || syncState.isSyncing
                ? Center(child: CircularProgressIndicator())
                : homeState.error != null
                ? Center(child: Text(homeState.error!))
                : ListView.builder(
              itemCount: homeState.coordinates.length,
              itemBuilder: (context, index) {
                final coord = homeState.coordinates[index];
                return ListTile(
                  title: Text('Lat: ${coord['latitude']}, Lon: ${coord['longitude']}'),
                  subtitle: Text(coord['synced'] == 1 ? 'Synced' : 'Not synced'),
                );
              },
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final connectivityNotifier = ref.watch(connectivityNotifierProvider.notifier);
              final isConnected = connectivityNotifier.isConnected;

              return Container(
                color: isConnected ? Colors.green : Colors.red,
                padding: EdgeInsets.all(8),
                child: Text(
                  isConnected ? 'Online' : 'Offline',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
