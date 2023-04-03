import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/models/custom_models.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

Future<OAuthToken?> kakaoToken = DefaultTokenManager().getToken();

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> getFcmToken() async {
    String? token = await _messaging.getToken();

    await saveFcmToken(token!);
    _messaging.onTokenRefresh.listen(saveFcmToken);
  }

  Future<void> saveFcmToken(String token) async {
    String baseUrl = dotenv.get('baseUrl');
    final accessToken = await kakaoToken.then((value) => value?.accessToken);

    final response = await http.post(
      Uri.parse('$baseUrl/user/fcm/$token'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    print(token);
    print(response.statusCode);
    print('fcm 토큰이 정상적으로 갔나요????');
  }

  Future<List> getAlarmList() async {
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
      return responseAlarms
          .map((alarm) => CustomAlarmField.fromJson(alarm))
          .toList();
    } else {
      throw Exception('알림 리스트 불러오기 실패');
    }
  }
}
