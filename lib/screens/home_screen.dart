import 'package:flutter/material.dart';
import '../widgets/navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('hi!!'),
      ),
      body: const Text('여긴 홈 화면'),
      bottomNavigationBar: const NavigateBar(),
    );
  }
}

// service에서 받아온 axios 요청을 