// lib/services/user_provider.dart

import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    // This tells any widgets listening to this provider to rebuild.
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}