import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import 'package:front/widgets/onion_with_message.dart';

// 양파 밭에서 클릭하면 나오는 양파 1개 화면
class OnionOneScreen extends StatefulWidget {
  final CustomOnion onion;

  const OnionOneScreen({super.key, required this.onion});

  @override
  State<OnionOneScreen> createState() => _OnionOneScreenState();
}

class _OnionOneScreenState extends State<OnionOneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 가능하면 다른 화면으로 넘어갈 수 있는 사이드바 같은 것도 추가
      body: Row(
        children: [
          OnionWithMessage(onion: widget.onion),
        ],
      ),
    );
  }
}
