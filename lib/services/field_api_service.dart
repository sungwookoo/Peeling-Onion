import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/custom_models.dart';

// 밭 관련 api 요청들 모음
class FieldApiService {
  // baseUrl
  static String? baseUrl = dotenv.env['baseUrl'];

  // 밭 전체 조회
  static Future<List<CustomField>> getFieldsById(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/onion/field/$userId'));

    // 요청 성공
    if (response.statusCode == 200) {
      List fields = jsonDecode(response.body);
      return fields.map((field) => CustomField.fromJson(field)).toList();
    }
    // 요청 실패
    throw Exception('Failed to load fields');
  }
}
