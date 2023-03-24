import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FindPeopleApiService {
  static String? baseUrl = dotenv.env['baseUrl'];

  static Future<List<Map>> findUsersByWord(String searchWord) async {
    final response =
        await http.get(Uri.parse('$baseUrl/user/nickname/$searchWord'));

    if (response.statusCode == 200) {
      List result = jsonDecode(response.body);
      List<Map> users = result
          .map((user) => {'id': user['id'], 'nickname': user['nickname']})
          .toList();

      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }
}
