import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class DioConnectivityRequestRetrier {
  final Dio? dio;
  final Connectivity? connectivity;

  DioConnectivityRequestRetrier(
      {required this.dio, required this.connectivity});

  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    StreamSubscription? streamSubscription;
    final responseCompleter = Completer<Response>();
    streamSubscription =
        connectivity!.onConnectivityChanged.listen((statuses) {
      // connectivity_plus 3.0+ emits List<ConnectivityResult> — reconnected
      // means at least one active network other than `none`.
      final connected = statuses.any((s) => s != ConnectivityResult.none);
      if (!connected) return;
      streamSubscription!.cancel();
      responseCompleter.complete(dio?.request(requestOptions.path,
            cancelToken: requestOptions.cancelToken,
            data: requestOptions.data,
            onReceiveProgress: requestOptions.onReceiveProgress,
            onSendProgress: requestOptions.onSendProgress,
            queryParameters: requestOptions.queryParameters,
            options: Options(
                method: requestOptions.method,
                headers: requestOptions.headers,
                contentType: requestOptions.contentType)));
    });
    return responseCompleter.future;
  }
}
