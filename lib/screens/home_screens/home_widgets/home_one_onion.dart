import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import 'package:front/screens/home_screens/home_widgets/home_onion_detail.dart';
import 'package:front/screens/record_screens/record_screen.dart';
import 'package:front/services/onion_api_service.dart';

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
              child: const Text('전송'),
            ),
          ],
        );
      },
    );
  }

  // 양파 삭제 모달
  void _showDeleteConfirmationDialog(BuildContext innerContext, int onionId) {
    showDialog(
      context: innerContext,
      builder: (context) {
        return AlertDialog(
          title: const Text('양파를 삭제하시겠습니까?'),
          content: widget._onion.isSingle
              ? const Text('삭제한 양파는 되돌릴 수 없으며, 저장된 메시지 역시 사라지게 됩니다.')
              : const Text('모아보내기 양파입니다. 이걸 지우면 다른 사람들의 녹음 역시 사라집니다.'),
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
                widget.onDelete();
              },
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }

// delete 모달 표시
  void showDeleteModal(BuildContext context, CustomHomeOnion onion,
      VoidCallback onDelete) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);
    final Size size = box.size;

    // 양파 삭제할지 팝업 메뉴
    return showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height,
        position.dx + size.width,
        position.dy,
      ),
      items: [
        PopupMenuItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(onion.name),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // TODO: Implement the delete functionality
                  Navigator.pop(context);
                  _showDeleteConfirmationDialog(context, onion.id);
                  // OnionApiService.deleteOnionById(onion.id);
                  // onDelete();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: constraints.maxHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 70,
              child: widget._onion.isDead
                  ? const Text('으악 죽었따')
                  // 전송하기 (보낼 수 있으면서, 내가 만든 양파면)
                  : widget._onion.isTime2go && widget._onion.isOnionMaker
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
                              child:
                                  Image.asset('assets/images/need_water.png'),
                            )
                          : Container(),
            ),
            Text('이름 : ${widget._onion.name}'),
            Flexible(
              child: GestureDetector(
                onLongPress: () {
                  // 양파 1개 delete 함수
                  showDeleteModal(context, widget._onion, widget.onDelete);
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomeOnionDetail(onion: widget._onion)),
                  );
                },
                // child: Image.asset(widget._onion.imgSrc),
                child: Image.asset('assets/images/onioninbottle.png'),
              ),
            ),
          ],
        ),
      );
    });
  }
}
