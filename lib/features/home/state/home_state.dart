class HomeState {
  final List<Map<String, dynamic>> coordinates;
  final bool isLoading;
  final String? error;

  HomeState({this.coordinates = const [], this.isLoading = false, this.error});
}
