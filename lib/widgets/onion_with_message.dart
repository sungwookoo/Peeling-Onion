import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import './listen_audio_url.dart';

// 양파 + 메시지 위젯
class OnionWithMessage extends StatefulWidget {
  final CustomOnion onion;

  const OnionWithMessage({Key? key, required this.onion}) : super(key: key);

  @override
  State<OnionWithMessage> createState() => _OnionWithMessageState();
}

class _OnionWithMessageState extends State<OnionWithMessage> {
  // 메시지 번호를 나타낼 변수
  int index = 0;
  ValueNotifier<bool> isPlayed = ValueNotifier<bool>(false);
  // url 주소를 나타낼 변수
  late String audioUrl;

  @override
  void initState() {
    super.initState();
    // audioUrl 에 양파의 메시지 url 할당 (메시지가 있는 경우)
    if (widget.onion.messages.isNotEmpty) {
      audioUrl = widget.onion.messages.elementAt(index).url;
    } else {
      audioUrl = '';
    }
  }

  // 이전 메시지 출력 함수
  void prev() {
    if (index == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('첫 메시지입니다.'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      setState(
        () {
          index -= 1;
          audioUrl = widget.onion.messages.elementAt(index).url;
          isPlayed.value = true;
        },
      );
    }
  }

  // 다음 메시지 출력 함수
  void next() {
    // 마지막 메시지면, 경고 띄우기
    if (index >= widget.onion.messages.length - 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('마지막 메시지입니다.'),
          duration: Duration(seconds: 1),
        ),
      );
      // 마지막이 아니면, 다음 메시지로 이동
    } else {
      setState(() {
        index += 1;
        audioUrl = widget.onion.messages.elementAt(index).url;
        isPlayed.value = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 양파 중앙 위치
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // 양파 이미지
              children: [
                Image.asset('assets/images/onion_image.png'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // 녹음 버튼들 출력
                  children: [
                    // 이전 재생 버튼
                    IconButton(
                      onPressed: prev,
                      icon: const Icon(Icons.navigate_before_rounded),
                    ),
                    // 녹음 재생 위젯
                    ListenAudioUrl(
                      urlPath: audioUrl,
                      isPlayed: isPlayed,
                    ),
                    // 다음 재생 버튼
                    IconButton(
                      onPressed: next,
                      icon: const Icon(Icons.navigate_next_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
