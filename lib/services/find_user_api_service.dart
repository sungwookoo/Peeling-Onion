import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

Future<OAuthToken?> Token = DefaultTokenManager().getToken();

class FindPeopleApiService {
  static String? baseUrl = dotenv.env['baseUrl'];

  static Future<List<Map>> findUsersByWord(String searchWord) async {
    final accessToken = await Token.then((value) => value?.accessToken);
    final response = await http.get(
      Uri.parse('$baseUrl/user/nickname/$searchWord'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List result = jsonDecode(utf8.decode(response.bodyBytes));
      List<Map> users = result
          .map((user) => {'id': user['id'], 'nickname': user['nickname']})
          .toList();

      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }
}
