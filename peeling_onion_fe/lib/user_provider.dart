import 'package:flutter/material.dart';

// 유저 모델
class UserIdModel with ChangeNotifier {
  int? _userId;

  int? get userId => _userId;

  void setUserId(int? userId) {
    _userId = userId;
    notifyListeners();
  }
}
