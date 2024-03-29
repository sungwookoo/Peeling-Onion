import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:front/models/custom_models.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

// 양파 api 요청들
class OnionApiService {
  // base url
  static String? baseUrl = dotenv.env['baseUrl'];

  // 기르는 양파 get (홈 화면에 띄울 양파 정보)
  static Future<List<CustomHomeOnion>> getGrowingOnionByUserId() async {
    Future<OAuthToken?> Token = DefaultTokenManager().getToken();
    final accessToken = await Token.then((value) => value?.accessToken);

    // get 요청 보내기
    final response = await http.get(
      Uri.parse('$baseUrl/onion/growing'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    print(accessToken);
    // 요청에 따라 저장
    if (response.statusCode == 200) {
      List onions = jsonDecode(utf8.decode(response.bodyBytes));
      return onions.map((onion) => CustomHomeOnion.fromJson(onion)).toList();
    } else {
      print(response.body);
      print(response.statusCode);
      throw Exception('Failed to get home_onions');
    }
  }

  // 택배함 get (유저가 받은 택배함 양파 정보 조회)
  static Future<List<CustomOnionByOnionIdPostbox>> getPostboxOnion() async {
    Future<OAuthToken?> Token = DefaultTokenManager().getToken();

    final accessToken = await Token.then((value) => value?.accessToken);

    // get 요청 보내기
    final response = await http.get(
      Uri.parse('$baseUrl/onion/postbox'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    // 요청에 따라 저장
    if (response.statusCode == 200) {
      List onions = jsonDecode(utf8.decode(response.bodyBytes));
      return onions
          .map((onion) => CustomOnionByOnionIdPostbox.fromJson(onion))
          .toList();
    } else {
      print(response.statusCode);
      throw Exception('Failed to get postbox_onions');
    }
  }

  // 양파 get (양파 1개 조회. 연결된 message들 포함)
  static Future<CustomOnionByOnionId> getOnionById(int onionId) async {
    Future<OAuthToken?> Token = DefaultTokenManager().getToken();

    final accessToken = await Token.then((value) => value?.accessToken);

    // get 요청 보내기
    final response = await http.get(
      Uri.parse('$baseUrl/onion/$onionId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      CustomOnionByOnionId onion = CustomOnionByOnionId.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      return onion;
    } else if (response.statusCode == 404) {
      throw Exception('접근할 수 없는 양파입니다');
    } else {
      throw Exception('Failed to get onion');
    }
  }

  // 양파 즐겨찾기 get
  Future<OAuthToken?> Token = DefaultTokenManager().getToken();
  static Future<List<CustomOnionFromField>> getBookmarkedOnion() async {
    Future<OAuthToken?> Token = DefaultTokenManager().getToken();

    final accessToken = await Token.then((value) => value?.accessToken);

    // get 요청 보내기
    final response = await http.get(
      Uri.parse('$baseUrl/onion/bookmarked'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    // 요청에 따라 저장
    if (response.statusCode == 200) {
      List onions = jsonDecode(utf8.decode(response.bodyBytes));
      return onions
          .map((onion) => CustomOnionFromField.fromJson(onion))
          .toList();
    } else {
      throw Exception('Failed to get home_onions');
    }
  }

  // 양파 즐겨찾기 post
  static Future<void> postMarkedOnionById(int onionId) async {
    Future<OAuthToken?> Token = DefaultTokenManager().getToken();

    final accessToken = await Token.then((value) => value?.accessToken);

    // post 요청 보내기
    final response = await http.post(
      Uri.parse('$baseUrl/onion/$onionId/bookmark'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 404) {
      throw Exception('접근할 수 없는 양파입니다');
    } else {
      throw Exception('Failed to get onion');
    }
  }

  // 양파 post (양파 생성)
  static Future<void> createOnion({
    required String onionName,
    required String onionImage,
    required String receiverNumber,
    required String growDueDate,
    required bool isSingle,
    required List userList,
  }) async {
    Future<OAuthToken?> Token = DefaultTokenManager().getToken();

    final accessToken = await Token.then((value) => value?.accessToken);

    var idList = userList.map((user) => user['id']).toList();

    Map<String, dynamic> datas = {
      'name': onionName,
      'img_src': onionImage,
      'receiver_number': receiverNumber,
      'grow_due_date': growDueDate,
      'is_single': isSingle,
      'user_id_list': idList,
    };
    print(datas);

    final data = jsonEncode(datas);

    final response = await http.post(
      Uri.parse('$baseUrl/onion'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: data,
    );

    if (response.statusCode == 201) {
      print('생성 성공');
    } else {
      print('생성 실패');
      print(response.body);
    }
  }

  // 양파 delete (양파 삭제)
  static Future<void> deleteOnionById(int onionId) async {
    Future<OAuthToken?> Token = DefaultTokenManager().getToken();

    final accessToken = await Token.then((value) => value?.accessToken);

    final response = await http.delete(
      Uri.parse('$baseUrl/onion/$onionId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to delete onion');
    }
  }

  // 양파 send (다 키운 양파 전송)
  static Future<void> sendOnionById(int onionId) async {
    Future<OAuthToken?> Token = DefaultTokenManager().getToken();

    final accessToken = await Token.then((value) => value?.accessToken);

    final response = await http.post(
      Uri.parse('$baseUrl/onion/growing/send/$onionId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      print('전송 완료');
    } else {
      throw Exception('Failed to delete onion');
    }
  }

  // 양파의 메시지 get
  static Future<CustomMessage> getMessage(int messageId) async {
    Future<OAuthToken?> Token = DefaultTokenManager().getToken();

    final accessToken = await Token.then((value) => value?.accessToken);

    final response = await http.get(
      Uri.parse('$baseUrl/onion/message/$messageId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      CustomMessage message =
          CustomMessage.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      return message;
    } else {
      throw Exception('존재하지 않는 메시지입니다.');
    }
  }

  // 양파 밭 이동
  static Future<void> updateOnionField(
      int onionId, int fromFId, int toFId) async {
    Future<OAuthToken?> Token = DefaultTokenManager().getToken();

    final accessToken = await Token.then((value) => value?.accessToken);

    final response = await http.put(
      Uri.parse('$baseUrl/onion/$onionId/$fromFId/$toFId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('옮겨심는 도중 문제가 발생했어요!');
    }
  }
}
