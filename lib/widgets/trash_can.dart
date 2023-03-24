import 'package:flutter/material.dart';

// 쓰레기통
class TrashCan extends StatefulWidget {
  final String kind;

  const TrashCan({
    super.key,
    required this.kind,
  });

  @override
  State<TrashCan> createState() => _TrashCanState();
}

class _TrashCanState extends State<TrashCan> {
  int trashCan = 0;

  @override
  Widget build(BuildContext context) {
    // 위치 (화면의 오른쪽 상단)
    return Positioned(
      top: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topRight,
        // drag & drop 기능 (쓰레기통에 drop)
        child: DragTarget<int>(
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            // 쓰레기통 UI
            return Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(25),
              ),
              // child: const Icon(Icons.delete),   // 쓰레기통 아이콘
              child: Text('$trashCan'),
            );
          },
          // drop 하면 경고창 (정말 삭제하시겠습니까?) 표시 후, 삭제 api 요청
          onAccept: (int data) {
            // 경고창
            if (widget.kind == 'field') {
              setState(() {
                trashCan = data + 1;
              });
            } else if (widget.kind == 'onion') {
              setState(() {
                trashCan = data + 101;
              });
            }
            // DELETE API 보내기 (현재는 쓰레기통 위치의 숫자가 바뀜)
          },
        ),
      ),
    );
  }
}
