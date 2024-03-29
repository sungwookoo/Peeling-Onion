import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import 'package:front/services/onion_api_service.dart';
import './listen_audio_url.dart';

// 양파 + 메시지 위젯
class OnionWithMessage extends StatefulWidget {
  final CustomOnionByOnionId onion;
  final int messageIndex;

  const OnionWithMessage({
    Key? key,
    required this.onion,
    required this.messageIndex,
  }) : super(key: key);

  @override
  State<OnionWithMessage> createState() => _OnionWithMessageState();
}

class _OnionWithMessageState extends State<OnionWithMessage> {
  // 메시지 번호를 나타낼 변수
  int audioId = 0;
  // 몇 번째 메시지인지 나타낼 변수
  int index = 0;
  ValueNotifier<bool> isPlayed = ValueNotifier<bool>(false);
  // url 주소를 나타낼 변수
  late Future<CustomMessage>? messageData;
  // 북마크 여부 판단
  final ValueNotifier<bool> _isBookMarked = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    // audioUrl 에 양파의 메시지 url 할당 (메시지가 있는 경우)
    if (widget.onion.messageIdList.isNotEmpty) {
      int audioId = widget.onion.messageIdList.elementAt(index);
      messageData = OnionApiService.getMessage(audioId);
    } else {
      messageData = OnionApiService.getMessage(1);
    }
    print(widget.onion.imgSrc.substring(0, 26));
    _isBookMarked.value = widget.onion.isBookmarked;
  }

  // 이전 메시지 출력 함수
  void prev() {
    if (index <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '첫 메시지입니다.',
            style: TextStyle(fontFamily: 'CookieRun'),
          ),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      setState(
        () {
          index -= 1;
          audioId = widget.onion.messageIdList.elementAt(index);
          messageData = OnionApiService.getMessage(audioId);
          isPlayed.value = true;
        },
      );
    }
  }

  // 다음 메시지 출력 함수
  void next() {
    // 마지막 메시지면, 경고 띄우기
    if (index >= widget.onion.messageIdList.length - 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '마지막 메시지입니다.',
            style: TextStyle(fontFamily: 'CookieRun'),
          ),
          duration: Duration(seconds: 1),
        ),
      );
      // 마지막이 아니면, 다음 메시지로 이동
    } else {
      setState(() {
        index += 1;
        audioId = widget.onion.messageIdList.elementAt(index);
        messageData = OnionApiService.getMessage(audioId);
        isPlayed.value = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 양파 중앙 위치
    return FutureBuilder<CustomMessage>(
      future: messageData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          CustomMessage message = snapshot.data as CustomMessage;
          String img;
          if (message.posRate >= 70) {
            img = '${widget.onion.imgSrc.substring(0, 26)}_positive.png';
          } else if (message.negRate >= 70) {
            img = '${widget.onion.imgSrc.substring(0, 26)}_negative.png';
          } else {
            img = '${widget.onion.imgSrc.substring(0, 26)}.png';
          }
          // widget.onion.growDueDate.substring(0, 10)
          String createDate = message.createdAt.substring(0, 10);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 50, 8, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage('assets/images/rainbow.jpg'),
                            fit: BoxFit.fill,
                          )),
                          height: 320,
                          width: 350,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 50.0, left: 20, right: 20),
                            child: Column(
                              children: [
                                Text(
                                  createDate,
                                  style: const TextStyle(
                                      fontFamily: 'CookieRun', fontSize: 22),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  '내용 : ${message.content}',
                                  style:
                                      const TextStyle(fontFamily: 'CookieRun'),
                                ),
                                widget.onion.isSingle
                                    ? const Text('')
                                    : Text(
                                        'from ${message.sender}',
                                        style: const TextStyle(
                                            fontFamily: 'CookieRun'),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        // 양파 이미지
                        Flexible(
                          child: Stack(
                            children: [
                              Image.asset(img,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8),

                              // 즐겨찾기 나타내는 아이콘
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ValueListenableBuilder(
                                      valueListenable: _isBookMarked,
                                      builder: (BuildContext context,
                                          bool value, Widget? child) {
                                        return Container(
                                          padding: const EdgeInsets.all(8.0),
                                          height: 50,
                                          child: GestureDetector(
                                            onTap: () {
                                              _isBookMarked.value =
                                                  !_isBookMarked.value;
                                              OnionApiService
                                                  .postMarkedOnionById(
                                                      widget.onion.id);
                                            },
                                            // 북마크 아이콘
                                            child: _isBookMarked.value
                                                ? Image.asset(
                                                    'assets/images/star_yellow.png')
                                                : Image.asset(
                                                    'assets/images/star_black.png'),
                                          ),
                                        );
                                      },
                                    ),
                                    Text(
                                        '메시지 : ${index + 1} / ${widget.onion.messageIdList.length}'),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        // 오디오 재생 버튼
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Row(
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
                                urlPath: message.fileSrc,
                                isPlayed: isPlayed,
                              ),
                              // 다음 재생 버튼
                              IconButton(
                                onPressed: next,
                                icon: const Icon(Icons.navigate_next_rounded),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '양파 이름 : ${widget.onion.name}',
                              style: const TextStyle(fontFamily: 'CookieRun'),
                            ),
                            Text(
                              '보낸 이 : ${widget.onion.sender}',
                              style: const TextStyle(fontFamily: 'CookieRun'),
                            ),
                            Text(
                              '보낸 날짜 : ${widget.onion.sendDate!.substring(0, 10)}',
                              style: const TextStyle(fontFamily: 'CookieRun'),
                            ),
                            // Text('내용 : ${}')
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Failed to load onion'),
          );
        } else {
          // return const Center(
          //   child:
          //       CustomLoadingWidget(imagePath: 'assets/images/onion_image.png'),
          // );
          return Container();
        }
      },
    );
  }
}
