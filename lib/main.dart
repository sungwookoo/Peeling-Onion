import 'package:flutter/material.dart';
import './screens/home_screen.dart';
import './screens/field_screen.dart';
import './screens/mypage_screen.dart';
import './screens/package_screen.dart';

void main() {
  runApp(const App());
}

// 위젯 상속
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/field': (context) => const FieldScreen(),
        '/mypage': (context) => const MypageScreen(),
        '/package': (context) => const PackageScreen(),
      },
    );
  }
}
