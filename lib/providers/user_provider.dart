// lib/providers/user_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  UserItem? _user;

  UserItem? get user => _user;
  bool get isLogin => _user != null;

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('user');
    if (jsonStr != null) {
      _user = UserItem.fromJson(json.decode(jsonStr));
      notifyListeners();
    }
  }

  Future<void> setUser(UserItem user) async {
    _user = user;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', json.encode(user.toJson()));
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    notifyListeners();
  }
}
