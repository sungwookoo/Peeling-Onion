import 'package:flutter/material.dart';
import 'package:front/screens/login_screens/loading_screen.dart';
import 'package:front/screens/login_screens/sign_in_screen.dart';
import 'widgets/custom_navigation_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

void main() async {
  await dotenv.load(fileName: ".env"); // 추가
  String? nativeAppKey = dotenv.env['nativeAppKey'];
  // print("-------------------------------");
  // print(nativeAppKey);
  KakaoSdk.init(nativeAppKey: '$nativeAppKey');
  runApp(const App());
}

// 위젯 상속
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const LoadingScreen(),
        '/signin': (context) => const SigninScreen(),
        '/home': (context) => const CustomNavigationBar(),
      },
    );
  }
}
