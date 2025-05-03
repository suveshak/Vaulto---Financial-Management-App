import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BudgetProvider with ChangeNotifier {
  static const String _dailyLimitKey = 'daily_limit';
  static const String _weeklyLimitKey = 'weekly_limit';
  static const String _monthlyLimitKey = 'monthly_limit';
  static const String _dailySpentKey = 'daily_spent';
  static const String _weeklySpentKey = 'weekly_spent';
  static const String _monthlySpentKey = 'monthly_spent';

  // Budget limits
  double _dailyLimit = 1000.0;
  bool _isDailyLimitEnabled = true;
  
  double _weeklyLimit = 5000.0;
  bool _isWeeklyLimitEnabled = true;
  
  double _monthlyLimit = 20000.0;
  bool _isMonthlyLimitEnabled = true;

  // Category limits
  final Map<String, double> _categoryLimits = {
    'Dining': 3000.0,
    'Shopping': 5000.0,
    'Entertainment': 2000.0,
  };

  double _dailySpent = 0;
  double _weeklySpent = 0;
  double _monthlySpent = 0;

  BudgetProvider() {
    _loadLimits();
    _loadSpent();
  }

  // Getters
  double get dailyLimit => _dailyLimit;
  bool get isDailyLimitEnabled => _isDailyLimitEnabled;
  
  double get weeklyLimit => _weeklyLimit;
  bool get isWeeklyLimitEnabled => _isWeeklyLimitEnabled;
  
  double get monthlyLimit => _monthlyLimit;
  bool get isMonthlyLimitEnabled => _isMonthlyLimitEnabled;
  
  Map<String, double> get categoryLimits => Map.unmodifiable(_categoryLimits);

  double get dailySpent => _dailySpent;
  double get weeklySpent => _weeklySpent;
  double get monthlySpent => _monthlySpent;

  Future<void> _loadLimits() async {
    final prefs = await SharedPreferences.getInstance();
    _dailyLimit = prefs.getDouble(_dailyLimitKey) ?? 0;
    _weeklyLimit = prefs.getDouble(_weeklyLimitKey) ?? 0;
    _monthlyLimit = prefs.getDouble(_monthlyLimitKey) ?? 0;
    notifyListeners();
  }

  Future<void> _loadSpent() async {
    final prefs = await SharedPreferences.getInstance();
    _dailySpent = prefs.getDouble(_dailySpentKey) ?? 0;
    _weeklySpent = prefs.getDouble(_weeklySpentKey) ?? 0;
    _monthlySpent = prefs.getDouble(_monthlySpentKey) ?? 0;
    notifyListeners();
  }

  // Setters
  void setDailyLimit(double amount) {
    _dailyLimit = amount;
    notifyListeners();
  }

  void setWeeklyLimit(double amount) {
    _weeklyLimit = amount;
    notifyListeners();
  }

  void setMonthlyLimit(double amount) {
    _monthlyLimit = amount;
    notifyListeners();
  }

  void toggleDailyLimit(bool enabled) {
    _isDailyLimitEnabled = enabled;
    notifyListeners();
  }

  void toggleWeeklyLimit(bool enabled) {
    _isWeeklyLimitEnabled = enabled;
    notifyListeners();
  }

  void toggleMonthlyLimit(bool enabled) {
    _isMonthlyLimitEnabled = enabled;
    notifyListeners();
  }

  void setCategoryLimit(String category, double amount) {
    _categoryLimits[category] = amount;
    notifyListeners();
  }

  // Save all changes
  void saveChanges({
    required double dailyLimit,
    required bool isDailyEnabled,
    required double weeklyLimit,
    required bool isWeeklyEnabled,
    required double monthlyLimit,
    required bool isMonthlyEnabled,
    required Map<String, double> categoryLimits,
  }) {
    _dailyLimit = dailyLimit;
    _isDailyLimitEnabled = isDailyEnabled;
    _weeklyLimit = weeklyLimit;
    _isWeeklyLimitEnabled = isWeeklyEnabled;
    _monthlyLimit = monthlyLimit;
    _isMonthlyLimitEnabled = isMonthlyEnabled;
    _categoryLimits.clear();
    _categoryLimits.addAll(categoryLimits);
    notifyListeners();
  }

  Future<void> addExpense(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    
    _dailySpent += amount;
    _weeklySpent += amount;
    _monthlySpent += amount;
    
    await prefs.setDouble(_dailySpentKey, _dailySpent);
    await prefs.setDouble(_weeklySpentKey, _weeklySpent);
    await prefs.setDouble(_monthlySpentKey, _monthlySpent);
    
    notifyListeners();
  }

  Future<void> resetDailySpent() async {
    final prefs = await SharedPreferences.getInstance();
    _dailySpent = 0;
    await prefs.setDouble(_dailySpentKey, 0);
    notifyListeners();
  }

  Future<void> resetWeeklySpent() async {
    final prefs = await SharedPreferences.getInstance();
    _weeklySpent = 0;
    await prefs.setDouble(_weeklySpentKey, 0);
    notifyListeners();
  }

  Future<void> resetMonthlySpent() async {
    final prefs = await SharedPreferences.getInstance();
    _monthlySpent = 0;
    await prefs.setDouble(_monthlySpentKey, 0);
    notifyListeners();
  }

  bool isDailyLimitExceeded() {
    return _dailyLimit > 0 && _dailySpent >= _dailyLimit;
  }

  bool isWeeklyLimitExceeded() {
    return _weeklyLimit > 0 && _weeklySpent >= _weeklyLimit;
  }

  bool isMonthlyLimitExceeded() {
    return _monthlyLimit > 0 && _monthlySpent >= _monthlyLimit;
  }
} 