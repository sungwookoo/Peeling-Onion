import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';

// 양파 겹을 까면서 들을 수 있는 위젯 (화면)
class OnionWithMessage extends StatefulWidget {
  final CustomOnion onion;

  const OnionWithMessage({super.key, required this.onion});

  @override
  State<OnionWithMessage> createState() => _OnionWithMessageState();
}

class _OnionWithMessageState extends State<OnionWithMessage> {
  // 유저가 선택한 녹음 메시지 index
  final int messageIndex = 0;
  // s3 서버에서 녹음된 메시지 가져오기
  late String audioUrl;

  @override
  void initState() {
    super.initState();
    audioUrl = widget.onion.messages.elementAt(messageIndex).url;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
