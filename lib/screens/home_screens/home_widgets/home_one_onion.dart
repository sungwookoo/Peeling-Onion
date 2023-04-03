import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import 'package:front/screens/record_screens/record_screen.dart';
import 'package:front/services/onion_api_service.dart';
import '../../../widgets/show_delete_modal.dart';

// 양파 1개
class HomeOneOnion extends StatefulWidget {
  const HomeOneOnion({
    super.key,
    required CustomHomeOnion onion,
    required this.onDelete,
  }) : _onion = onion;

  final CustomHomeOnion _onion;
  // final int globalIndex;
  final VoidCallback onDelete;

  @override
  State<HomeOneOnion> createState() => _HomeOneOnionState();
}

class _HomeOneOnionState extends State<HomeOneOnion> {
  // 양파 전송 모달
  void _showSendConfirmDialog(BuildContext context, int onionId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('양파를 전송하시겠습니까?'),
          content: const Text('전송할 경우 상대에게 알림이 갑니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                OnionApiService.sendOnionById(onionId);
              },
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 70,
          child: widget._onion.isDead
              ? const Text('으악 죽었따')
              // 전송하기
              : widget._onion.isTime2go
                  ? GestureDetector(
                      onTap: () {
                        _showSendConfirmDialog(context, widget._onion.id);
                      },
                      child: Image.asset('assets/images/ready_to_go.png'),
                    )
                  : !widget._onion.isWatered
                      // 물 주기
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RecordScreen(onion: widget._onion)),
                            );
                          },
                          child: Image.asset('assets/images/need_water.png'),
                        )
                      : Container(),
        ),
        Text('이름 : ${widget._onion.name}'),
        Expanded(
          child: GestureDetector(
            onLongPress: () {
              // 양파 1개 delete 함수
              showDeleteModal(context, widget._onion, widget.onDelete);
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RecordScreen(onion: widget._onion)),
              );
            },
            child: Image.asset(widget._onion.imgSrc),
          ),
        ),
      ],
    );
  }
}
