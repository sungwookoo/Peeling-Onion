import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import 'package:front/screens/home_screens/home_widgets/home_onion_detail.dart';
import 'package:front/screens/record_screens/record_screen.dart';
import 'package:front/services/onion_api_service.dart';
import 'package:front/widgets/kakao_share.dart';

// 양파 1개
class HomeOneOnion extends StatefulWidget {
  const HomeOneOnion({
    super.key,
    required CustomHomeOnion onion,
    required this.onDelete,
    required this.onUpdate,
  }) : _onion = onion;

  final CustomHomeOnion _onion;
  // final int globalIndex;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  @override
  State<HomeOneOnion> createState() => _HomeOneOnionState();
}

class _HomeOneOnionState extends State<HomeOneOnion> {
  // 양파 전송 모달
  void _showSendConfirmDialog(BuildContext context, CustomHomeOnion onion) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('양파를 전송하시겠습니까?'),
          content: SizedBox(
            height: 230,
            child: Column(
              children: [
                const Text('전송할 경우 상대에게 알림이 갑니다.'),
                Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 100,
                        child: Image.asset(onion.imgSrc),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('양파 이름 : ${onion.name}'),
                          const SizedBox(
                            height: 5,
                          ),
                          Text('받을 번호 : ${onion.receiverNumber}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                OnionApiService.sendOnionById(onion.id);
                _showSendCompleteDialog(context, onion);
              },
              child: const Text('전송'),
            ),
          ],
        );
      },
    );
  }

  // 양파 전송 후 성공 모달
  void _showSendCompleteDialog(BuildContext context, CustomHomeOnion onion) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('배송 완료!!'),
          content: SizedBox(
            height: 200,
            child: Column(
              children: [
                const Text('대상에게 공유하기 버튼을 누르세요!'),
                Expanded(
                  child: Image.asset('assets/images/gift_box.png'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onUpdate();
              },
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                widget.onUpdate();
                shareMessage();
              },
              child: const Text('공유하기'),
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
                OnionApiService.deleteOnionById(onionId);
                widget.onDelete();
                Navigator.pop(innerContext);
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
                  Navigator.pop(context);
                  // await Future.delayed(const Duration(milliseconds: 100));
                  _showDeleteConfirmationDialog(context, onion.id);
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
              child: widget._onion.isTime2go && widget._onion.isOnionMaker
                  ? GestureDetector(
                      onTap: () {
                        _showSendConfirmDialog(context, widget._onion);
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
                                  builder: (context) => RecordScreen(
                                        onion: widget._onion,
                                        onUpdate: widget.onUpdate,
                                      )),
                            );
                          },
                          child: Image.asset('assets/images/need_water.png'),
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
                  if (widget._onion.isWatered) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomeOnionDetail(onion: widget._onion)),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecordScreen(
                          onion: widget._onion,
                          onUpdate: widget.onUpdate,
                        ),
                      ),
                    );
                  }
                },
                // child: Image.asset(widget._onion.imgSrc),
                child: widget._onion.isDead
                    ? Image.asset('assets/images/deadonion.png')
                    : Image.asset(
                        'assets/images/onionbottle/${widget._onion.imgSrc[widget._onion.imgSrc.length - 5]}onionbottle.png'),
              ),
            ),
          ],
        ),
      );
    });
  }
}
