import 'package:flutter/material.dart';
import './services/notification_service.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

Future<OAuthToken?> kakaoToken = DefaultTokenManager().getToken();

class AlarmProvider with ChangeNotifier {
  List _alarmList = [];
  bool _unreadAlarm = false;

  List get alarmList => _alarmList;
  bool get unreadAlarm => _unreadAlarm;

  Future<void> fetchAlarmList() async {
    final result = await NotificationService().getAlarmList();
    _alarmList = result;
    notifyListeners();
  }

  void getUnreadAlarm() async {
    await fetchAlarmList();
    final unread = _alarmList.any((alarm) => alarm.isRead == false);
    _unreadAlarm = unread;
    print(_unreadAlarm);
    notifyListeners();
  }
}
