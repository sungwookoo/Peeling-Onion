import 'package:flutter/material.dart';
import 'package:front/screens/field_screens/onion_one_screen.dart';
import '../../models/custom_models.dart';

// 밭 1개를 출력하는 클래스
class FieldOneScreen extends StatefulWidget {
  final CustomField field;

  const FieldOneScreen({super.key, required this.field});

  @override
  State<FieldOneScreen> createState() => _FieldOneScreenState();
}

class _FieldOneScreenState extends State<FieldOneScreen> {
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
          children: widget.field.onions.map((onion) {
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
                    Text(
                      onion.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // 꾹 누르면 drag and drop 가능하게
                    LongPressDraggable<int>(
                      data: onion.id,
                      // 드래그 시작하면, 모달을 내리자. 그런데 feedback 도 사라진다. 이후 고민
                      onDragStarted: () {
                        Navigator.pop(context);
                      },
                      feedback: const Text('양파 드래그 앤 드롭'),
                      // 밭의 양파를 누르면, 양파 1개 화면으로 넘어감
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OnionOneScreen(onion: onion),
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
