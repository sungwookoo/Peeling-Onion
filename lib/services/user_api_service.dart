import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CustomUser {
  final int userId;

  CustomUser.fromJson(Map<String, dynamic> json) : userId = json['userId'];
}

//유저 api 요청들
class UserApiService {
  static String? baseUrl = dotenv.env['baseUrl'];

  // 회원가입 완료 여부 확인
  static dynamic checkSignin(int tokenId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: <String, String>{
        'Authorization': 'Bearer $tokenId',
      },
    );

    if (response.statusCode == 200) {
      CustomUser userId = jsonDecode(response.body);
      return userId;
    } else if (response.statusCode == 204) {
      throw Exception('User Not Found');
    } else {
      throw Exception('Failed to request');
    }
  }
}

// 양파 api 요청들
// class OnionApiService {
//   static String? baseUrl = dotenv.env['baseUrl'];

//   // 택배함 get (유저가 받은 택배함 양파 정보 조회)

//   // 양파 get (양파 1개 조회. 연결된 message들 포함)
//   static Future<CustomOnion> getOnionById(int onionId) async {
//     final response = await http.get(Uri.parse('$baseUrl/onion/$onionId'));

//     if (response.statusCode == 200) {
//       CustomOnion onion = jsonDecode(response.body);
//       return onion;
//     } else {
//       throw Exception('Failed to load onion');
//     }
//   }

  // 양파 post (양파 생성)

  // 양파 delete (양파 삭제)
// }
