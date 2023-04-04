import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/models/custom_models.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

Future<OAuthToken?> kakaoToken = DefaultTokenManager().getToken();

class AlarmApiService {
  static String baseUrl = dotenv.get('baseUrl');

  Future<List> getAlarmList() async {
    final accessToken = await kakaoToken.then((value) => value?.accessToken);

    final response = await http.get(
      Uri.parse('$baseUrl/alarm/list'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List responseAlarms = jsonDecode(utf8.decode(response.bodyBytes));
      return responseAlarms
          .map((alarm) => CustomAlarmField.fromJson(alarm))
          .toList();
    } else {
      throw Exception('알림 리스트 불러오기 실패');
    }
  }

  Future<void> readAlarm(int alarmId) async {
    final accessToken = await kakaoToken.then((value) => value?.accessToken);

    final response = await http.put(
      Uri.parse('$baseUrl/alarm/$alarmId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    print(response.statusCode);
  }
}
