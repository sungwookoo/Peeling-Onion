import 'package:flutter/material.dart';
import '../../models/custom_models.dart';

// 밭 1개를 출력하는 클래스
class FieldOneScreen extends StatefulWidget {
  final CustomField field;
  final List<CustomField> fields;
  // late bool showDraggableRectangle;
  final Function(bool) onValueChanged;

  const FieldOneScreen({
    super.key,
    required this.field,
    required this.onValueChanged,
    required this.fields,
  });

  @override
  State<FieldOneScreen> createState() => _FieldOneScreenState();
}

class _FieldOneScreenState extends State<FieldOneScreen> {
  ValueNotifier<bool> showDraggableRectangle = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 60),
      height: (MediaQuery.of(context).size.width - 60),
      color: Colors.brown,
      child: Center(
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
          ),
          children: widget.field.onionInfos.map((onion) {
            // 밭 하나하나가 drag target 이다 (양파 이동 시)
            return DragTarget<int>(
              onWillAccept: (data) {
                return true;
              },
              onAccept: (data) async {
                // 밭 위치 조정 API 보내기 (data 는 onion Id)
                int targetField = widget.field.id;
              },
              builder: (
                BuildContext context,
                List<dynamic> accepted,
                List<dynamic> rejected,
              ) {
                return Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  children: [
                    // Text(
                    //   onion.name,
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    // 꾹 누르면 drag and drop 가능하게
                    // 꾹 누를 때 모달이 사라지면 draggable 도 사라짐.
                    // 꾹 누르면 아래에 밭들 이름이 나타나게 해서 이동하도록 수정
                    LongPressDraggable<int>(
                      data: onion.id,
                      // 드래그 시작하면, 아래에 밭들 나타나게
                      onDragStarted: () {
                        setState(() {
                          // widget.showDraggableRectangle = true;
                          widget.onValueChanged(true);
                        });
                      },
                      onDragCompleted: () {
                        setState(() {
                          // widget.showDraggableRectangle = false;
                          widget.onValueChanged(false);
                        });
                      },
                      onDraggableCanceled: (_, __) {
                        setState(() {
                          // widget.showDraggableRectangle = false;
                          widget.onValueChanged(false);
                        });
                      },
                      feedback: const Text('양파 드래그 앤 드롭'),
                      // 밭의 양파를 누르면, 양파 1개 화면으로 넘어감
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Text('hi')
                                // OnionOneScreen(onion: onion),
                                ),
                          );
                        },
                        child: Image.asset('assets/images/onion_image.png'),
                      ),
                    ),
                  ],
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
