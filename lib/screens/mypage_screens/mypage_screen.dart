import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/user_provider.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserIdModel>(context, listen: false).userId;
    return Scaffold(
        body: Column(
      children: [
        const Text('여긴 마이페이지 입니다.'),
        Text('$userId'),
      ],
    ));
  }
}
