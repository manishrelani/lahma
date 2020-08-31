import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:lahma/styles/strings.dart';

// https://github.com/dennmat/flutter-connectiontest-example/tree/master/lib

class InternetConnectivityService {

  static final InternetConnectivityService _internetConnectivityService = InternetConnectivityService._();
  Connectivity _connectivity;
  StreamController _streamController;
  bool _isInternetFound;

  InternetConnectivityService._() :
        _connectivity = Connectivity(),
        _streamController = StreamController.broadcast(),
        _isInternetFound = false;

  _connectionCheck(ConnectivityResult result){
    _checkConnectivity();
  }

  Future<bool> _checkConnectivity() async {

    bool checkConnection = _isInternetFound;
    try {

      final result = await InternetAddress.lookup(LOOKUP);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty)
        _isInternetFound = true;
      else
        _isInternetFound = false;
    } on SocketException catch(_){
      _isInternetFound = false;
    }

    if (checkConnection != _isInternetFound){
      _streamController.add(_isInternetFound);
    }
    return _isInternetFound;
  }

  get isInternetFound => _isInternetFound;
  get streamController => _streamController.stream;

  initialize() async{
    _connectivity.onConnectivityChanged.listen(_connectionCheck);
  }

  dispose(){
    _streamController.close();
  }

  static InternetConnectivityService getInstance() => _internetConnectivityService;
}