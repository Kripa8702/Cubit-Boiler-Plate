import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  Connectivity connectivity;

  static final NetworkInfo _networkInfo = NetworkInfo._internal(Connectivity());

  factory NetworkInfo() {
    return _networkInfo;
  }

  NetworkInfo._internal(this.connectivity) {
    connectivity = connectivity;
  }

  StreamController controller = StreamController.broadcast();

  Stream get networkStream => controller.stream;

  ///checks internet is connected or not
  ///returns [true] if internet is connected
  ///else it will return [false]
  // void initialize() async {
  //   List<ConnectivityResult> result = await connectivity.checkConnectivity();
  //   _checkStatus(result.first);
  //
  //   connectivity.onConnectivityChanged
  //       .listen((List<ConnectivityResult> result) {
  //     _checkStatus(result.first);
  //   });
  // }
  Future<bool> isConnected() async {
    List<ConnectivityResult> result = await connectivity.checkConnectivity();
    if (result.first != ConnectivityResult.none) {
      return true;
    }
    return false;
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else {
        isOnline = false;
      }
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}
