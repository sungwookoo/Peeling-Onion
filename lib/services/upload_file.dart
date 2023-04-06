import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:simple_s3/simple_s3.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class UploadApiService {
  final SimpleS3 _simpleS3 = SimpleS3();
  static String? baseUrl = dotenv.env['baseUrl'];

  Future<String> uploadRecord(File recordFile) async {
    String result = await _simpleS3.uploadFile(
        recordFile,
        dotenv.get('s3Bucket'),
        dotenv.get('s3PoolId'),
        AWSRegions.apNorthEast2);
    return result;
  }

  Future<bool> saveMessage(int onionId, String recordUrl, int pos, int neg,
      int neu, String sttText) async {
    var datas = {
      'id': onionId,
      'content': sttText,
      'pos_rate': pos,
      'neg_rate': neg,
      'neu_rate': neu,
      'file_src': recordUrl
    };
    Future<OAuthToken?> Token = DefaultTokenManager().getToken();
    final accessToken = await Token.then((value) => value?.accessToken);
    final data = jsonEncode(datas);

    final response = await http.post(
      Uri.parse('$baseUrl/onion/message'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: data,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print(response.statusCode);
      return true;
    } else {
      return false;
    }
  }
}
