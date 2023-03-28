import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import 'package:front/services/onion_api_service.dart';

// delete 모달 표시
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
            const Text('Delete Onion'),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // TODO: Implement the delete functionality

                OnionApiService.deleteOnionById(onion.id);
                onDelete();

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    ],
  );
}
