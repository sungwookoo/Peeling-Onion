import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:front/widgets/kakao_share.dart';
import 'package:front/services/user_api_service.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  static String? baseUrl = dotenv.env['baseUrl'];
  late Future<Map<String, dynamic>> userInfo; // userInfo 변수 선언

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  void getInfo() async {
    userInfo = UserApiService.getUserInfo(context);
  }

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

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserIdModel>(context, listen: false).userId;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: FutureBuilder<Map<String, dynamic>>(
              future: userInfo, // userInfo 변수 사용
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final nickname = snapshot.data!['nickname'];
                  final phoneNumber = snapshot.data!['mobileNumber'];

                  return Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        "마이페이지",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffA1D57A),
                        ),
                      ),
                      Text('$userId'),
                      Text('$nickname'),
                      Text('$phoneNumber'),
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
                  );
                } else if (snapshot.hasError) {
                  return Text('에러 발생: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
