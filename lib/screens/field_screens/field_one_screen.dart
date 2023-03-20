import 'package:flutter/material.dart';
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
            return Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
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
      ),
    );
  }
}
