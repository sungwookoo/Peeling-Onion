// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';

// class ListenAudioUrl extends StatefulWidget {
//   // url 입력
//   final String urlPath;
//   late bool isPlayed;
//   ListenAudioUrl({super.key, required this.urlPath, required this.isPlayed});

//   @override
//   State<ListenAudioUrl> createState() => _ListenAudioUrlState();
// }

// class _ListenAudioUrlState extends State<ListenAudioUrl> {
//   AudioPlayer player = AudioPlayer();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   // 오디오 재생
//   Future<void> _playAudio() async {
//     await player.stop();
//     await player.play(UrlSource(widget.urlPath));
//     widget.isPlayed = true;
//   }

//   Future<void> _pauseAudio() async {
//     await player.stop();
//     widget.isPlayed = false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: widget.isPlayed ? _pauseAudio : _playAudio,
//       icon: widget.isPlayed
//           ? const Icon(Icons.pause)
//           : const Icon(Icons.play_arrow),
//     );
//   }
// }

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class ListenAudioUrl extends StatefulWidget {
  // url 입력
  final String urlPath;
  final ValueNotifier<bool> isPlayed;
  const ListenAudioUrl(
      {super.key, required this.urlPath, required this.isPlayed});

  @override
  State<ListenAudioUrl> createState() => _ListenAudioUrlState();
}

class _ListenAudioUrlState extends State<ListenAudioUrl> {
  AudioPlayer player = AudioPlayer();
  late VoidCallback _playerListenerCallback;

  @override
  void initState() {
    super.initState();
    _playerListenerCallback = () => _toggleAudioPlayback();
    widget.isPlayed.addListener(_playerListenerCallback);
    _prepareAudio();
  }

  @override
  void didUpdateWidget(ListenAudioUrl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.urlPath != widget.urlPath) {
      _prepareAudio();
    }
  }

  @override
  void dispose() {
    widget.isPlayed.removeListener(_playerListenerCallback);
    player.dispose();
    super.dispose();
  }

  // 오디오 준비
  Future<void> _prepareAudio() async {
    await player.setSourceUrl(widget.urlPath);
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
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isPlayed,
      builder: (BuildContext context, bool isPlayed, Widget? child) {
        return IconButton(
          onPressed: () {
            widget.isPlayed.value = !widget.isPlayed.value;
          },
          icon:
              isPlayed ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
        );
      },
    );
  }
}
