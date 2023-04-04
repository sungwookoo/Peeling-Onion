import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';

// delete 모달 표시 (이후 안쓸 예정)
Future<void> showDeleteModal(
    BuildContext context, CustomHomeOnion onion, VoidCallback onDelete) async {
  final RenderBox box = context.findRenderObject() as RenderBox;
  final Offset position = box.localToGlobal(Offset.zero);
  final Size size = box.size;

  return showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy + size.height,
      position.dx + size.width,
      position.dy,
    ),
    items: [
      PopupMenuItem(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(onion.name),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // TODO: Implement the delete functionality

                // OnionApiService.deleteOnionById(onion.id);
                // onDelete();

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    ],
  );
}
