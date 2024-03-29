import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:front/user_provider.dart';
import 'package:provider/provider.dart';

class CustomUser {
  final int? userId;

  CustomUser.fromJson(Map<String, dynamic> json) : userId = json['user_id'];
}

//유저 api 요청들
class UserApiService {
  static String? baseUrl = dotenv.env['baseUrl'];

  // accessToken을 반환하는 함수
  static Future<String?> getToken() async {
    Future<OAuthToken?> Token = DefaultTokenManager().getToken();

    final accessToken = await Token.then((value) => value?.accessToken);
    return accessToken;
  }

  // 회원가입 완료 여부 확인
  static Future<int?> checkSignin(context) async {
    Future<OAuthToken?> Token = DefaultTokenManager().getToken();

    final accessToken = await Token.then((value) => value?.accessToken);
    print("$accessToken : accessToken");
    print('yessssssssssssssssssssssssss');
    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    print("${response.statusCode}, response입니다~~~~~~~~~~~~~~~~~~");
    if (response.statusCode == 200) {
      print(response.body);
      CustomUser user = CustomUser.fromJson(jsonDecode(response.body));
      Provider.of<UserIdModel>(context, listen: false).setUserId(user.userId);
      return user.userId;
    } else if (response.statusCode == 204) {
      print('204204');
      // 회원가입한 녀석이 아니면
      return -1;
      throw Exception('User Not Found');
    } else {
      return 0;
      throw Exception('Failed to request');
    }
  }

  // 유저 정보 받아오기
  static Future<Map<String, dynamic>> getUserInfo(context) async {
    // 유저 ID 가져오기
    final userId = Provider.of<UserIdModel>(context, listen: false).userId;

    // 유저 토큰 가져오기
    Future<OAuthToken?> Token = DefaultTokenManager().getToken();
    final accessToken = await Token.then((value) => value?.accessToken);
    print("$accessToken : accessToken");
    print('yessssssssssssssssssssssssss');

    final response = await http.get(
      Uri.parse('$baseUrl/user/$userId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    print("${response.statusCode}, response입니다~~~~~~~~~~~~~~~~~~");
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      print(json);

      final mobileNumber = json['mobile_number'];
      final nickname = json['nickname'];

      final result = {'mobileNumber': mobileNumber, 'nickname': nickname};
      return result;
    } else if (response.statusCode == 204) {
      print('204204');
      // 회원가입한 녀석이 아니면
      throw Exception('User Not Found');
    } else {
      throw Exception('Failed to request');
    }
  }
}
