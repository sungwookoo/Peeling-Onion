import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/custom_models.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

// 카카오 토큰
Future<OAuthToken?> Token = DefaultTokenManager().getToken();

// 밭 관련 api 요청들 모음
class FieldApiService {
  // baseUrl
  static String? baseUrl = dotenv.env['baseUrl'];

  // 밭 전체 조회 get
  static Future<List<CustomField>> getFieldsByUser() async {
    final accessToken = await Token.then((value) => value?.accessToken);
    // get 요청 보내기
    final response = await http.get(
      Uri.parse('$baseUrl/field'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    // 요청 성공
    if (response.statusCode == 200) {
      List fields = jsonDecode(utf8.decode(response.bodyBytes));
      return fields.map((field) => CustomField.fromJson(field)).toList();
    }
    // 요청 실패
    throw Exception('Failed to load fields');
  }

  // 밭 생성 create
  static Future<CustomField> createField(String fieldName) async {
    final accessToken = await Token.then((value) => value?.accessToken);
    final response = await http.post(Uri.parse('$baseUrl/field'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': fieldName,
        }));
    // 요청 성공
    if (response.statusCode == 200) {
      CustomField field =
          CustomField.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      return field;
    } else {
      print(response.statusCode);
      throw Exception('Failed to load fields');
    }
  }

  // 밭 삭제 delete
  static Future<void> deleteField(int fieldId) async {
    final accessToken = await Token.then((value) => value?.accessToken);

    final response = await http.delete(
      Uri.parse('$baseUrl/field/$fieldId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    // 요청 성공
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load fields');
    }
  }

  // 밭 이름 수정 update
  static Future<CustomField> updateFieldName(
      int fieldId, String fieldName) async {
    final accessToken = await Token.then((value) => value?.accessToken);
    final response = await http.put(Uri.parse('$baseUrl/field/$fieldId'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': fieldName,
        }));
    // 요청 성공
    if (response.statusCode == 200) {
      CustomField field =
          CustomField.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      return field;
    } else {
      print(response.statusCode);
      throw Exception('Failed to load fields');
    }
  }

  // 밭 안의 양파들 정보 get
  static Future<List<CustomOnionFromField>> getOnionFromField(
      int fieldId) async {
    final accessToken = await Token.then((value) => value?.accessToken);

    final response = await http.get(
      Uri.parse('$baseUrl/field/$fieldId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    // 요청 성공
    if (response.statusCode == 200) {
      List onions = jsonDecode(utf8.decode(response.bodyBytes));
      return onions
          .map((onion) => CustomOnionFromField.fromJson(onion))
          .toList();
    } else {
      throw Exception('Failed to load fields');
    }
  }
}
