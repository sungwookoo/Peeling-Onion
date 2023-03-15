import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Text('여긴 홈 화면'),
      // bottomNavigationBar: const NavigateBar(),
    );
  }
}

// service에서 받아온 axios 요청을 바탕으로, 양파 출력
