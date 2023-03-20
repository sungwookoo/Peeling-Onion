import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/custom_models.dart';

String baseUrl = 'https://stoplight.io/mocks/ggaggayang/peelingonion/149504280';

// 밭 1개를 요청하는 클래스
class FieldApiService {
  // 밭 전체 조회
  static Future<List<CustomField>> getFieldsById(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/field/$userId'));

    if (response.statusCode == 200) {
      List fields = jsonDecode(response.body);
      return fields.map((field) => CustomField.fromJson(field)).toList();
    } else {
      throw Exception('Failed to load fields');
    }
  }
}
