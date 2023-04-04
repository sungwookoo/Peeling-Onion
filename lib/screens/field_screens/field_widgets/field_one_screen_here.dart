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
    return Stack(
      children: [
        Image.asset('assets/images/pannel_nosand.png', height: 200),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 40, 40, 0),
          width: (MediaQuery.of(context).size.width - 60) / 2,
          decoration: const BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 10),
              child: Text(
                widget.field.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
