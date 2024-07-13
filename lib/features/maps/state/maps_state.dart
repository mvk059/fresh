import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsState {
  final Set<Marker> markers;
  final bool isLoading;
  final String? error;

  MapsState({this.markers = const {}, this.isLoading = false, this.error});
}