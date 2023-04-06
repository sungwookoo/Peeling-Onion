import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

DateTime? backbuttonpressedTime;

Future<bool> onWillPop() async {
  DateTime currentTime = DateTime.now();

  bool backButton = backbuttonpressedTime == null ||
      currentTime.difference(backbuttonpressedTime!) >
          const Duration(seconds: 2);

  if (backButton) {
    backbuttonpressedTime = currentTime;
    Fluttertoast.showToast(
      msg: "뒤로가기를 한 번 더 누르면 앱이 종료됩니다.",
      backgroundColor: Colors.black,
      textColor: Colors.white,
      gravity: ToastGravity.CENTER,
    );
    return false;
  }
  SystemNavigator.pop(); // 이 부분을 추가합니다.
  return true;
}
