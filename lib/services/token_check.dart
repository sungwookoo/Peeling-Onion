import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class Token {
  dynamic tokenCheck(context) async {
    if (await AuthApi.instance.hasToken()) {
      try {
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');
        // Navigator.pushNamed(context, '/home');
        return tokenInfo;
      } catch (error) {
        if (error is KakaoException && error.isInvalidTokenError()) {
          print('토큰 만료 $error');
        } else {
          print('토큰 정보 조회 실패 $error');
        }

        Navigator.pushNamed(context, '/');
      }
    } else {
      print('발급된 토큰 없음');
      Navigator.pushNamed(context, '/');
    }
  }
}
