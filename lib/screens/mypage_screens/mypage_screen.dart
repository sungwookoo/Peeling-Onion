import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

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
      print('회원탈퇴 완료');
      await UserApi.instance.logout();
      print('토큰 삭제 완료');
    } else {
      // 회원가입이 실패한 경우
      print('회원탈퇴 실패: ${response.body}');
    }
    Navigator.pushNamed(context, '/');
  }

  void share() async {
    print('공유하기 구현하자!');
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserIdModel>(context, listen: false).userId;
    return Scaffold(
        body: Column(
      children: [
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
            share();
          },
          child: const Text('공유하기'),
        ),
      ],
    ));
  }
}
