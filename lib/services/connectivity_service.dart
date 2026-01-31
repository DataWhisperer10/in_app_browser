import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Connectivity state
enum ConnectivityState {
  online,
  offline,
}

/// Connectivity service provider
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

/// Connectivity state provider
final connectivityStateProvider = StreamProvider<ConnectivityState>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.connectivityStream;
});

/// Simple connectivity check provider
final isOnlineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityStateProvider);
  return connectivity.whenOrNull(data: (state) => state == ConnectivityState.online) ?? true;
});

/// Connectivity service for checking network status
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  
  StreamController<ConnectivityState>? _controller;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Stream<ConnectivityState> get connectivityStream {
    _controller ??= StreamController<ConnectivityState>.broadcast(
      onListen: _startListening,
      onCancel: _stopListening,
    );
    return _controller!.stream;
  }

  void _startListening() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final state = _mapResultToState(results);
      _controller?.add(state);
    });

    // Check initial state
    _checkConnectivity();
  }

  void _stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  Future<void> _checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    final state = _mapResultToState(results);
    _controller?.add(state);
  }

  ConnectivityState _mapResultToState(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none)) {
      return ConnectivityState.offline;
    }
    return ConnectivityState.online;
  }

  Future<bool> isOnline() async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  void dispose() {
    _stopListening();
    _controller?.close();
    _controller = null;
  }
}
