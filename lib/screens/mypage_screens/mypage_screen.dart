import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  static String? baseUrl = dotenv.env['baseUrl'];

  void logOut(context) async {
    try {
      await UserApi.instance.logout();
      print('로그아웃 성공, SDK에서 토큰 삭제');
    } catch (error) {
      print('로그아웃 실패, SDK에서 토큰 삭제 $error');
    }
    Navigator.pushNamed(context, '/');
  }

  void signOut() async {
    Future<OAuthToken?> Token = DefaultTokenManager().getToken();
    final accessToken = await Token.then((value) => value?.accessToken);

    http.Response response = await http.delete(
      Uri.parse('$baseUrl/user'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      // 성공적으로 회원가입이 완료된 경우
      print(response.body);
      print('회원탈퇴 완료, 카카오 연동 해제 시도');
      try {
        await UserApi.instance.unlink();
        print('연결 끊기 성공, SDK에서 토큰 삭제');
        Navigator.pushNamed(context, '/');
      } catch (error) {
        print('연결 끊기 실패 $error');
      }
    } else {
      // 회원가입이 실패한 경우
      print('회원탈퇴 실패: ${response.body}');
    }
    Navigator.pushNamed(context, '/');
  }

  void shareMessage() async {
    // 사용자 정의 템플릿 ID
    int templateId = 91849;
// 카카오톡 실행 가능 여부 확인
    bool isKakaoTalkSharingAvailable =
        await ShareClient.instance.isKakaoTalkSharingAvailable();

    if (isKakaoTalkSharingAvailable) {
      try {
        Uri uri =
            await ShareClient.instance.shareCustom(templateId: templateId);
        await ShareClient.instance.launchKakaoTalk(uri);
        print('카카오톡 공유 완료');
      } catch (error) {
        print('카카오톡 공유 실패 $error');
      }
    } else {
      try {
        Uri shareUrl = await WebSharerClient.instance
            .makeCustomUrl(templateId: templateId);
        await launchBrowserTab(shareUrl, popupOpen: true);
      } catch (error) {
        print('카카오톡 공유 실패 $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserIdModel>(context, listen: false).userId;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Text('여긴 마이페이지 입니다.'),
            Text('$userId'),
            ElevatedButton(
              onPressed: () async {
                logOut(context);
              },
              child: const Text('로그아웃'),
            ),
            ElevatedButton(
              onPressed: () async {
                signOut();
              },
              child: const Text('회원탈퇴'),
            ),
            ElevatedButton(
              onPressed: () async {
                shareMessage();
              },
              child: const Text('공유하기'),
            ),
          ],
        ),
      ),
    ));
  }
}
