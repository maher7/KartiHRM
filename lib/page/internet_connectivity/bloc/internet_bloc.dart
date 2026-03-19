import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  StreamSubscription? _subscription;
  Connectivity connectivity = Connectivity();
  InternetBloc() : super(const InternetState()) {
    on<InternetEvent>((event, emit) {
      if (event is ConnectedEvent) {
        emit(state.copyWith(message: "Connected",status: InternetStatus.online));
      } else if (event is NotConnectedEvent) {
        emit(state.copyWith(message: "No Internet Connection",status: InternetStatus.offline));
      }
    });
    checkConnectionStatus();
  }

  void checkConnectionStatus() async {
    connectivity.checkConnectivity().then((res){
      checkStatus(res);
      _subscription = Connectivity().onConnectivityChanged.listen(checkStatus);
    });
  }

  void checkStatus(List<ConnectivityResult> result) async {
    // If device reports no connectivity at all, mark offline immediately
    if (result.contains(ConnectivityResult.none)) {
      add(NotConnectedEvent());
      return;
    }

    // Device has a connection — verify with DNS lookup (try multiple hosts)
    final hosts = ['google.com', 'cloudflare.com', '1.1.1.1'];
    for (final host in hosts) {
      try {
        final lookupResult = await InternetAddress.lookup(host)
            .timeout(const Duration(seconds: 5));
        if (lookupResult.isNotEmpty && lookupResult[0].rawAddress.isNotEmpty) {
          add(ConnectedEvent());
          return;
        }
      } catch (_) {
        // Try next host
      }
    }

    // All hosts failed — but device says connected, give benefit of the doubt
    // and mark as online (API calls will handle errors individually)
    add(ConnectedEvent());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
