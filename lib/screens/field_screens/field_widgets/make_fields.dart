import 'dart:math';

import 'package:flutter/material.dart';
import '../../../models/custom_models.dart';
import 'package:front/services/field_api_service.dart';
import '../field_one_screen.dart';
import '../field_widgets/field_one_screen_here.dart';

// 밭 Grid 로 출력
class MakeFields extends StatefulWidget {
  final List<CustomField> _fields;
  // final VoidCallback onDelete;

  const MakeFields({
    super.key,
    required List<CustomField> fields,
    // this.draggedOnionId,
  }) : _fields = fields;

  @override
  State<MakeFields> createState() => _MakeFieldsState();
}

class _MakeFieldsState extends State<MakeFields> {
  // 양파를 drag 한 상태인지 판단하는 변수 (true 면 아래 밭 선택 창 표시)
  ValueNotifier<bool> showDraggableRectangle = ValueNotifier<bool>(false);

  late final List<CustomField> _fields;

  @override
  void initState() {
    super.initState();
    _fields = widget._fields;
  }

  void _updateData(bool newData) {
    setState(() {
      showDraggableRectangle.value = newData;
    });
  }

  // 밭 삭제하는 메서드
  void _deleteField(int fieldId) {
    setState(() {
      _fields.removeWhere((field) => field.id == fieldId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 페이지 수
    int numOfPages = (widget._fields.length / 6).ceil();

    // 페이지 표현
    return SizedBox(
      height: (MediaQuery.of(context).size.width - 60) / 2 * 3 + 20,
      child: PageView.builder(
        itemCount: numOfPages,
        itemBuilder: (BuildContext context, int pageIndex) {
          // 밭 번호 할당
          int startIndex = pageIndex * 6;
          int endIndex = min(startIndex + 6, widget._fields.length);

          // 현재 페이지에 속한 밭들의 리스트 제작
          List<CustomField> pageFields =
              widget._fields.sublist(startIndex, endIndex);

          // 현재 페이지의 밭들을 UI 에 표시
          return Container(
            alignment: Alignment.topCenter,
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              // 각 밭들을 한 번씩 return 해서 children 에 담음
              children: pageFields.map((field) {
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 60) / 2,
                  height: (MediaQuery.of(context).size.width - 60) / 2,
                  // 밭을 클릭하면, 해당 밭을 확대해서 모달로 띄움. 이 때 상세 정보를 api로 받아서 보여줄 예정
                  child: GestureDetector(
                    onLongPress: () {
                      _showDeleteModal(
                          context, field, () => _deleteField(field.id));
                    },
                    onTap: () {
                      // 밭 모달 띄우기
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => Container(
                          width:
                              MediaQuery.of(context).size.width, // 화면의 가로 길이만큼
                          height: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          // 모달로 띄울 밭 1개 (FieldOneScreen 클래스 사용)
                          child: FieldOneScreen(
                            field: field,
                            onValueChanged: _updateData,
                          ),
                        ),
                      );
                    },
                    // 전체 밭 화면에서 나타나게 할 밭 1개
                    child: FieldOneScreenHere(field: field),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

// 밭 삭제 popup 창
Future<void> _showDeleteModal(
    BuildContext context, CustomField field, VoidCallback onDelete) async {
  // final RenderObject? renderObject =
  //     context.findAncestorRenderObjectOfType<RenderObject>();
  // final Offset position =
  //     renderObject?.localToGlobal(Offset.zero) ?? Offset.zero;

  return showMenu(
    context: context,
    position: const RelativeRect.fromLTRB(0, 0, 0, 0),
    items: [
      PopupMenuItem(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(field.name),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                FieldApiService.deleteField(field.id);
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
