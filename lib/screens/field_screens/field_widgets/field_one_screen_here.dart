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
    return LongPressDraggable(
      data: widget.field.id,
      feedback: Opacity(
        opacity: 0.6,
        child: SizedBox(
          height: (MediaQuery.of(context).size.width - 60) / 2,
          width: (MediaQuery.of(context).size.width - 60) / 2,
          child: Center(
            child: Container(
              // height: (MediaQuery.of(context).size.width - 60) / 2,
              height: 70,
              // width: (MediaQuery.of(context).size.width - 60) / 2,
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
                    // 밭 안의 양파들 출력
                    // Wrap(
                    //   spacing: 8,
                    //   runSpacing: 8,
                    //   children: widget.field.onions.map((onion) {
                    //     return Column(
                    //       children: [
                    //         Text(
                    //           onion.name,
                    //           maxLines: 1,
                    //           overflow: TextOverflow.ellipsis,
                    //         ),
                    //         Image.asset('assets/images/onion_image.png'),
                    //       ],
                    //     );
                    //   }).toList(),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      feedbackOffset: const Offset(
        0,
        0,
      ),
      child: OneField(widget: widget),
    );
  }
}

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
              children: widget.field.onionInfos.map((onion) {
                return Column(
                  children: [
                    // Text(
                    //   onion.name,
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
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
