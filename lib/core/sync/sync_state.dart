class SyncState {
  final bool isSyncing;
  final bool isSyncComplete;
  final String? error;

  SyncState({this.isSyncing = false, this.isSyncComplete = false, this.error});
}