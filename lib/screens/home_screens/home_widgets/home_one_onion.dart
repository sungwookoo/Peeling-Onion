import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import 'package:front/screens/record_screens/record_screen.dart';
import '../../../widgets/show_delete_modal.dart';

// 양파 1개 (이후 이곳의 onTap 속성에, 혜빈누나 작업물 붙일 예정)
class HomeOneOnion extends StatelessWidget {
  const HomeOneOnion({
    super.key,
    required List<CustomHomeOnion> onions,
    required this.globalIndex,
    required this.onDelete,
  }) : _onions = onions;

  final List<CustomHomeOnion> _onions;
  final int globalIndex;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        // 양파 1개 delete 함수
        showDeleteModal(context, _onions.elementAt(globalIndex), onDelete);
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RecordScreen(onion: _onions.elementAt(globalIndex))),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_onions.elementAt(globalIndex).name),
          Image.asset('assets/images/onion_image.png'),
        ],
      ),
    );
  }
}
