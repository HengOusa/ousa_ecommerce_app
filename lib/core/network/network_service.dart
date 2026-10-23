import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'network_status.dart';

class NetworkService {
  NetworkService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  final StreamController<NetworkStatus> _statusController =
      StreamController<NetworkStatus>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  NetworkStatus _currentStatus = NetworkStatus.disconnected;

  bool _isInitialized = false;

  /// Get the latest known network status.
  NetworkStatus get currentStatus => _currentStatus;

  /// Listen to network status changes.
  Stream<NetworkStatus> get statusStream => _statusController.stream;

  /// Check whether Wi-Fi or mobile data is available.
  Future<NetworkStatus> checkConnection() async {
    final results = await _connectivity.checkConnectivity();

    return _hasConnection(results)
        ? NetworkStatus.connected
        : NetworkStatus.disconnected;
  }

  Future<NetworkStatus> refreshConnection() async {
    try {
      final status = await checkConnection();
      _updateStatus(status);
      return status;
    } catch (_) {
      _updateStatus(NetworkStatus.disconnected);
      return NetworkStatus.disconnected;
    }
  }

  /// Start monitoring network connectivity.
  Future<void> initialize() async {
    if (_isInitialized) return;

    _isInitialized = true;

    // Listen first so connectivity changes are not missed
    // while the initial status is being checked.
    _subscription = _connectivity.onConnectivityChanged.listen(
      (results) {
        _updateStatus(
          _hasConnection(results)
              ? NetworkStatus.connected
              : NetworkStatus.disconnected,
        );
      },
      onError: (_) {
        _updateStatus(NetworkStatus.disconnected);
      },
    );

    try {
      final status = await checkConnection();
      _updateStatus(status);
    } catch (_) {
      _updateStatus(NetworkStatus.disconnected);
    }
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }

  void _updateStatus(NetworkStatus status) {
    if (_currentStatus == status) return;

    _currentStatus = status;

    if (!_statusController.isClosed) {
      _statusController.add(status);
    }
  }

  /// Release resources when the service is no longer needed.
  Future<void> dispose() async {
    await _subscription?.cancel();
    await _statusController.close();

    _isInitialized = false;
  }
}
