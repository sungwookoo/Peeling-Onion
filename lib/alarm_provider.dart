import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

Future<OAuthToken?> kakaoToken = DefaultTokenManager().getToken();
// Future<OAuthToken?> Token = DefaultTokenManager().getToken();

class AlarmProvider extends ChangeNotifier {
  List _alarmList = [];
  bool _unreadAlarm = false;

  List get alarmList => _alarmList;
  bool get unreadAlarm => _unreadAlarm;

  Future<void> getAlarmList() async {
    String baseUrl = dotenv.get('baseUrl');
    final accessToken = await kakaoToken.then((value) => value?.accessToken);

    final response = await http.get(
      Uri.parse('$baseUrl/alarm/list'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List responseAlarms = jsonDecode(utf8.decode(response.bodyBytes));

      _alarmList = responseAlarms
          .map((alarm) => CustomAlarmField.fromJson(alarm))
          .toList();
      _unreadAlarm = _alarmList.any((alarm) => alarm.isRead == false);
      notifyListeners();
    } else {
      throw Exception('알림 리스트 불러오기 실패');
    }
  }
}
