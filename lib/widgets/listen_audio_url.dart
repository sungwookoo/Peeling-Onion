import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// 녹음 재생을 위한 위젯
class ListenAudioUrl extends StatefulWidget {
  // url 저장할 변수
  final String urlPath;
  // 재생중인지 저장할 변수
  final ValueNotifier<bool> isPlayed;

  // 생성자
  const ListenAudioUrl(
      {super.key, required this.urlPath, required this.isPlayed});

  @override
  State<ListenAudioUrl> createState() => _ListenAudioUrlState();
}

class _ListenAudioUrlState extends State<ListenAudioUrl> {
  // player 선언 (flutter audiop plyaers 참조)
  AudioPlayer player = AudioPlayer();
  // isPlayed 가 바뀔 때마다 호출해서, 위젯을 새로 만들 변수
  late VoidCallback _playerListenerCallback;

  @override
  void initState() {
    super.initState();
    _playerListenerCallback = () => _toggleAudioPlayback();
    widget.isPlayed.addListener(_playerListenerCallback);
    _prepareAudio();
  }

  // 위젯이 업데이트 되면 호출 (urlPath가 변경되면 _prepareAudio 호출)
  @override
  void didUpdateWidget(ListenAudioUrl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.urlPath != widget.urlPath) {
      _prepareAudio();
    }
  }

  // 위젯이 제거될 때 호출 (_playerListenCallback, player 제거)
  @override
  void dispose() {
    widget.isPlayed.removeListener(_playerListenerCallback);
    player.dispose();
    super.dispose();
  }

  // 오디오 준비 (urlPath 가 올바른 url 형식이면)
  Future<void> _prepareAudio() async {
    try {
      Uri.parse(widget.urlPath);
      await player.setSourceUrl(widget.urlPath);
    } catch (e) {}
  }

  // 오디오 재생/일시정지
  void _toggleAudioPlayback() {
    if (widget.isPlayed.value) {
      player.resume();
    } else {
      player.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    // isPlayed 를 참조해서, 그게 바뀌면 다시 빌드
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isPlayed,
      builder: (BuildContext context, bool isPlayed, Widget? child) {
        // 재생/정지 버튼 구현
        return IconButton(
          onPressed: () {
            widget.urlPath != null
                ? widget.isPlayed.value = !widget.isPlayed.value
                : null;
            player.onPlayerComplete.listen((_) {
              widget.isPlayed.value = false;
              _prepareAudio();
            });
          },
          icon: widget.isPlayed.value
              ? const Icon(Icons.pause)
              : const Icon(Icons.play_arrow),
        );
      },
    );
  }
}
