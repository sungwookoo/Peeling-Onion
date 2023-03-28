import 'package:flutter/material.dart';
import '../../../models/custom_models.dart';

// 밭들 격자 안에서, 밭 1개를 출력해 보여주는 클래스
class FieldOneScreenHere extends StatefulWidget {
  final CustomField field;

  const FieldOneScreenHere({super.key, required this.field});

  @override
  State<FieldOneScreenHere> createState() => _FieldOneScreenHereState();
}

class _FieldOneScreenHereState extends State<FieldOneScreenHere> {
  @override
  Widget build(BuildContext context) {
    // 밭 drag and drop 기능
    return LongPressDraggable(
      data: widget.field.id,
      // drag 할 때 보이는 화면 (양파들은 표시할 필요 없을지도?)
      feedback: Opacity(
        opacity: 0.6,
        child: SizedBox(
          height: (MediaQuery.of(context).size.width - 60) / 2,
          width: (MediaQuery.of(context).size.width - 60) / 2,
          child: Center(
            child: Container(
              height: 70,
              width: 70,
              color: Colors.brown,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 밭 이름 표시
                    Text(
                      widget.field.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    // 밭 안의 양파들 출력할 경우, 여기 코드 작성
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // feedback 이 나타날 위치
      feedbackOffset: const Offset(
        0,
        0,
      ),
      child: OneField(widget: widget),
    );
  }
}

// 전체 화면으로 보이는 양파밭 1개의 코드
class OneField extends StatelessWidget {
  const OneField({
    super.key,
    required this.widget,
  });

  final FieldOneScreenHere widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 밭 이름 표시
            Text(
              widget.field.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // 밭 안의 양파들 출력
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.field.onions.map((onion) {
                return Column(
                  children: [
                    Text(
                      onion.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Image.asset('assets/images/onion_image.png'),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
