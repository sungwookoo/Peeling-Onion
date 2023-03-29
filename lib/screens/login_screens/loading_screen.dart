import 'package:flutter/material.dart';
import 'package:front/services/user_api_service.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late Future<CustomUser?> userId;
  late Future<String> accessTokenFuture;

  Future<String> getAccessToken() async {
    OAuthToken? token = await DefaultTokenManager().getToken();
    return token?.accessToken ?? '';
  }

  Future<void> goNext(context) async {
    // 가입 되어 있으면 userId를 반환받아서 상태 저장.
    // 가입 안 되어 있으면 sign_in으로 푸쉬 아니면 홈으로 푸쉬.
    final userId = await UserApiService.checkSignin(context);
    if (userId != -1) {
      Navigator.pushNamed(context, '/home');
      // signin 테스트할 때
      // Navigator.pushNamed(context, '/signin');
    } else if (userId == -1) {
      Navigator.pushNamed(context, '/signin');
    }
  }

  void tokenCheck(context) async {
    if (await AuthApi.instance.hasToken()) {
      try {
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        // print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');

        // 가입 되어 있으면 userId를 반환받아서 상태 저장.
        // 가입 안 되어 있으면 sign_in으로 푸쉬 아니면 홈으로 푸쉬.
        final userId = await UserApiService.checkSignin(context);
        print(userId);
        if (userId != -1) {
          Navigator.pushNamed(context, '/home');
        } else {
          // 테스트용~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          Navigator.pushNamed(context, '/signin');
        }
      } catch (error) {
        if (error is KakaoException && error.isInvalidTokenError()) {
          print('토큰 만료 $error');
        } else {
          print('토큰 정보 조회 실패 $error');
        }
      }
    } else {
      print('발급된 토큰 없음');
    }
  }

  Future<void> kakaoLogin(context) async {
    // 카카오 로그인 구현 예제
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
        await goNext(context);
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)

        // if (error is PlatformException && error.code == 'CANCELED') {
        //   return;
        // }

        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          await goNext(context);
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        await goNext(context);
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    accessTokenFuture = getAccessToken();
    tokenCheck(context);
  }

  void refreshAccessToken() {
    setState(() {
      accessTokenFuture = getAccessToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("지금 로딩중입니다"),
            ElevatedButton(
              onPressed: () async {
                await kakaoLogin(context);
              },
              child: const Text('Kakao Login'),
            ),
            FutureBuilder<String>(
              future: accessTokenFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SelectableText(
                        'Access Token: \n ${snapshot.data}',
                        style: const TextStyle(fontSize: 32),
                      ));
                } else {
                  return const Text('No access token found');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
