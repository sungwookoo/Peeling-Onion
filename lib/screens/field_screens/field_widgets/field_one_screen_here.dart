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
    return OneField(widget: widget);
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
          ],
        ),
      ),
    );
  }
}
