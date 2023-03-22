import 'package:flutter/material.dart';
import 'package:front/widgets/onion_create_modal.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: const Text('여긴 홈 화면'),
      floatingActionButton: FloatingActionButton(
          child: const Text('양파생성'),
          onPressed: () {
            _displayOnionCreateModal(context);
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const OnionCreate()));
          }),
      // bottomNavigationBar: const NavigateBar(),
    );
  }
}

// service에서 받아온 axios 요청을 바탕으로, 양파 출력

// 양파 생성 모달 띄우는 함수
Future<void> _displayOnionCreateModal(
  BuildContext context,
) async {
  return showDialog(
      context: context,
      builder: (context) {
        return const OnionCreateDialog();
      });
}
