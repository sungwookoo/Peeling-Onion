// import 'package:flutter/material.dart';
// import 'package:front/models/custom_models.dart';
// import './listen_audio_url.dart';

// class OnionWithMessage extends StatefulWidget {
//   final CustomOnion onion;

//   const OnionWithMessage({super.key, required this.onion});

//   @override
//   State<OnionWithMessage> createState() => _OnionWithMessageState();
// }

// class _OnionWithMessageState extends State<OnionWithMessage> {
//   int index = 0;
//   // 재생 중인지 판단 (맨 처음에는 중지. 이후 버튼을 누르거나, 다음 메시지로 넘어가면 재생 시작)
//   bool isPlayed = false;
//   late String audioUrl;

//   @override
//   void initState() {
//     super.initState();
//     audioUrl = widget.onion.messages.elementAt(index).url;
//   }

//   // 다음 메시지 출력
//   void next() {
//     if (index >= widget.onion.messages.length - 1) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('마지막 메시지입니다.'),
//           duration: Duration(seconds: 1),
//         ),
//       );
//     } else {
//       setState(() {
//         index += 1;
//         audioUrl = widget.onion.messages.elementAt(index).url;
//         isPlayed = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Row(
//         children: [
//           ListenAudioUrl(
//             urlPath: audioUrl,
//             isPlayed: isPlayed,
//           ),
//           IconButton(
//             onPressed: next,
//             icon: const Icon(Icons.navigate_next_rounded),
//           ),
//         ],
//       ),
//     );
//   }
// }

// chatgpt 코드
import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import './listen_audio_url.dart';

// 양파 + 메시지 위젯
class OnionWithMessage extends StatefulWidget {
  final CustomOnion onion;

  const OnionWithMessage({super.key, required this.onion});

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
    // audioUrl 에 양파의 메시지 url 할당
    audioUrl = widget.onion.messages.elementAt(index).url;
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
          audioUrl = widget.onion.messages.elementAt(0).url;
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
    return Center(
      child: Row(
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
    );
  }
}
