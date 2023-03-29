import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:front/models/custom_models.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

Future<OAuthToken?> Token = DefaultTokenManager().getToken();

// 양파 api 요청들
class OnionApiService {
  // base url
  static String? baseUrl = dotenv.env['baseUrl'];

  // 기르는 양파 get (홈 화면에 띄울 양파 정보)
  static Future<List<CustomHomeOnion>> getGrowingOnionByUserId() async {
    final accessToken = await Token.then((value) => value?.accessToken);

    // get 요청 보내기
    final response = await http.get(
      Uri.parse('$baseUrl/onion/growing'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    // 요청에 따라 저장
    if (response.statusCode == 200) {
      List onions = jsonDecode(response.body);
      return onions.map((onion) => CustomHomeOnion.fromJson(onion)).toList();
    } else {
      print(response.statusCode);
      throw Exception('Failed to load home onions');
    }
  }

  // 택배함 get (유저가 받은 택배함 양파 정보 조회)

  // 양파 get (양파 1개 조회. 연결된 message들 포함)
  static Future<CustomOnionByOnionId> getOnionById(int onionId) async {
    final accessToken = await Token.then((value) => value?.accessToken);

    // get 요청 보내기
    final response = await http.get(
      Uri.parse('$baseUrl/onion/$onionId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      CustomOnionByOnionId onion =
          CustomOnionByOnionId.fromJson(jsonDecode(response.body));
      return onion;
    } else {
      throw Exception('Failed to load onion');
    }
  }

  // 양파 post (양파 생성)

  // 양파 delete (양파 삭제)
  static Future<void> deleteOnionById(int onionId) async {
    final accessToken = await Token.then((value) => value?.accessToken);

    final response = await http.delete(
      Uri.parse('$baseUrl/onion/$onionId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      // On success, do something
    } else {
      throw Exception('Failed to delete onion');
    }
  }

  // 양파의 메시지 get
  static Future<CustomMessage> getMessage(int messageId) async {
    final accessToken = await Token.then((value) => value?.accessToken);

    final response = await http.get(
      Uri.parse('$baseUrl/onion/message/$messageId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      CustomMessage message = CustomMessage.fromJson(jsonDecode(response.body));
      return message;
    } else {
      throw Exception('Failed to get message');
    }
  }
}
