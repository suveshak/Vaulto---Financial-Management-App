import 'package:flutter/foundation.dart';

class AIConnectionProvider with ChangeNotifier {
  String _baseUrl = 'http://192.168.1.9';
  String _port = '1234';
  bool _isConnected = false;

  String get baseUrl => _baseUrl;
  String get port => _port;
  bool get isConnected => _isConnected;
  String get fullUrl => '$_baseUrl:$_port/v1';

  void updateConnection(String baseUrl, String port) {
    _baseUrl = baseUrl;
    _port = port;
    notifyListeners();
  }

  void setConnectionStatus(bool status) {
    _isConnected = status;
    notifyListeners();
  }
} 