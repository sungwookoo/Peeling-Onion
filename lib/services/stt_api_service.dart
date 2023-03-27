import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SttApiService {
  final baseUrl = Uri.parse('https://openapi.vito.ai/v1/authenticate');
  Map<String, String?> datas = {
    'client_id': dotenv.env['sttClientId'],
    'client_secret': dotenv.env['sttClientSecret'],
  };

  Future<String> getSttToken() async {
    final response = await http.post(baseUrl, body: datas);

    if (response.statusCode == 200) {
      var tt = jsonDecode(response.body);
      return tt['access_token'];
      // return onions.map((onion) => CustomHomeOnion.fromJson(onion)).toList();
    } else {
      throw Exception('STT 인증 토큰 받기 실패');
    }
  }
}
