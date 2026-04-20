import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hrm_framework/src/services/connectivity_status_provider.dart';

class ConnectivityStatusProviderImpl implements ConnectivityStatusProvider {
  final Connectivity connectivity;

  final List<ConnectivityChangedHandler> _handlers = [];

  ConnectivityStatusProviderImpl({required this.connectivity}) {
    connectivity.onConnectivityChanged.listen((statuses) {
      final connected = _isConnected(statuses);
      for (final handler in _handlers) {
        handler.call(connected);
      }
    });
  }

  @override
  Future<bool> get isConnected async {
    final statuses = await connectivity.checkConnectivity();
    return _isConnected(statuses);
  }

  @override
  void addConnectivityChangedHandler(ConnectivityChangedHandler handler) {
    _handlers.add(handler);
  }

  // connectivity_plus 3.0+ returns List<ConnectivityResult> because a device
  // can be on multiple networks at once (Wi-Fi + cellular). "Connected" means
  // at least one active network other than `none`.
  static bool _isConnected(List<ConnectivityResult> statuses) =>
      statuses.any((s) => s != ConnectivityResult.none);
}
