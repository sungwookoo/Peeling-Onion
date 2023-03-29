import 'dart:io';
import 'dart:async';
import 'package:simple_s3/simple_s3.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UploadApiService {
  final SimpleS3 _simpleS3 = SimpleS3();

  Future<String> uploadRecord(File recordFile) async {
    String result = await _simpleS3.uploadFile(
        recordFile,
        dotenv.get('s3Bucket'),
        dotenv.get('s3PoolId'),
        AWSRegions.apNorthEast2);
    print(result);
    return result;
  }
}
