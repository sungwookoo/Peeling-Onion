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
      color: Colors.brown,
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
        ),
        children: widget.field.onions.map((onion) {
          return Container(
            child: Column(
              children: [
                Text(
                  onion.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Image.asset('assets/images/onion_image.png'),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
