import 'package:flutter/material.dart';
import 'widgets/custom_navigation_bar.dart';

void main() {
  runApp(const App());
}

// 위젯 상속
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CustomNavigationBar(),
    );
  }
}
