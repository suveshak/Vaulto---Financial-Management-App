import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userImagePathKey = 'user_image_path';

  bool _isLoggedIn = false;
  String _userEmail = '';
  String _userName = '';
  String? _userImagePath;
  String _storedPin = '1234'; // Default PIN for demo purposes

  AuthProvider() {
    _loadAuthState();
  }

  bool get isLoggedIn => _isLoggedIn;
  String get userEmail => _userEmail;
  String get userName => _userName;
  String? get userImagePath => _userImagePath;
  bool get isAuthenticated => _isLoggedIn;

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    _userEmail = prefs.getString(_userEmailKey) ?? '';
    _userName = prefs.getString(_userNameKey) ?? '';
    _userImagePath = prefs.getString(_userImagePathKey);
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    // TODO: Implement actual login logic
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userNameKey, 'User'); // Default name
    _isLoggedIn = true;
    _userEmail = email;
    _userName = 'User';
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    _isLoggedIn = false;
    _userEmail = '';
    _userName = '';
    _userImagePath = null;
    notifyListeners();
  }

  Future<void> updateUserProfile({
    required String name,
    required String email,
    String? imagePath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userEmailKey, email);
    if (imagePath != null) {
      await prefs.setString(_userImagePathKey, imagePath);
    }
    _userName = name;
    _userEmail = email;
    _userImagePath = imagePath;
    notifyListeners();
  }

  Future<void> loginWithPin(String pin) async {
    // In a real app, you would verify the PIN against a secure storage
    if (pin == _storedPin) {
      _isLoggedIn = true;
      _userName = 'User'; // Default name for demo
      _userEmail = 'user@example.com'; // Default email for demo
      notifyListeners();
    } else {
      throw Exception('Invalid PIN');
    }
  }

  Future<void> setNewPin(String newPin) async {
    if (newPin.length != 4) {
      throw Exception('PIN must be 4 digits');
    }
    _storedPin = newPin;
    notifyListeners();
  }
} 