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
                    // 꾹 누르면 이동/삭제 선택창이 나타나게
                    // 이동 누르면 이전 창으로 가서, 밭을 선택할 수 있음
                    GestureDetector(
                      onLongPress: () {},
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => OnionOneScreen(onion: onion),
                        //   ),
                        // );
                      },
                      child: Image.asset('assets/images/onion_image.png'),
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
