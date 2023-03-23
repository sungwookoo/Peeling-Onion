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

  void tokenCheck(context) async {
    if (await AuthApi.instance.hasToken()) {
      try {
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        // print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');
        // print(tokenInfo.id);
        // print(tokenInfo);

        // 여기서 tokenInfo.id를 통해서 우리 서비스 가입했는지 가려야 함. (헤더로 보냄)
        // 가입 되어 있으면 userId를 반환받아서 상태 저장.
        // 가입 안 되어 있으면 sign_in으로 푸쉬 아니면 홈으로 푸쉬.
        Future<OAuthToken?> accessToken = DefaultTokenManager().getToken();

        print("accessToken입니다.");
        accessToken.then((value) => print(value));
        accessToken.then((value) => print(UserApiService.checkSignin(value)));
        final userId = await accessToken
            .then((value) => UserApiService.checkSignin(value));
        print(userId);
        print('aaaaaaaaaaa');

        // userId = UserApiService.checkSignin(accessToken);
        // print(userId);

        // Navigator.pushNamed(context, '/home');
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

  Future<void> kakaoLogin() async {
    // 카카오 로그인 구현 예제
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        dynamic a = await UserApi.instance.loginWithKakaoTalk();
        print('------------------------------------------------------------');
        print(a);
        print('카카오톡으로 로그인 성공');

        print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
        Future<OAuthToken?> oAuthToken = DefaultTokenManager().getToken();
        oAuthToken.then((value) => print(value));
        // access token
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
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    tokenCheck(context);
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
                  await kakaoLogin();
                },
                child: const Text('Kakao Login'))
          ],
        ),
      ),
    );
  }
}
