import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import 'package:front/screens/record_screens/record_screen.dart';
import '../../../widgets/show_delete_modal.dart';

// 양파 1개
class HomeOneOnion extends StatefulWidget {
  const HomeOneOnion({
    super.key,
    required CustomHomeOnion onion,
    required this.onDelete,
  }) : _onion = onion;

  final CustomHomeOnion _onion;
  // final int globalIndex;
  final VoidCallback onDelete;

  @override
  State<HomeOneOnion> createState() => _HomeOneOnionState();
}

class _HomeOneOnionState extends State<HomeOneOnion> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        // 양파 1개 delete 함수
        showDeleteModal(context, widget._onion, widget.onDelete);
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RecordScreen(onion: widget._onion)),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget._onion.name),
          Image.asset(widget._onion.imgSrc),
        ],
      ),
    );
  }
}
