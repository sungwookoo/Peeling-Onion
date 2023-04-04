import 'package:flutter/material.dart';
import 'package:front/services/field_api_service.dart';
import 'package:front/services/onion_api_service.dart';
import 'package:front/widgets/loading_rotation.dart';
import './onion_one_screen.dart';
import '../../models/custom_models.dart';

// 밭 1개를 모달로 출력하는 클래스
class FieldOneScreen extends StatefulWidget {
  final CustomField field;
  // 부모 (make_fields.dart) 에게 '양파의 밭 이동' 함수를 실행하라 전하기 위한 변수
  final Function parentShowMoveSelectDialog;

  const FieldOneScreen({
    super.key,
    required this.field,
    required this.parentShowMoveSelectDialog,
  });

  @override
  State<FieldOneScreen> createState() => _FieldOneScreenState();
}

class _FieldOneScreenState extends State<FieldOneScreen> {
  ValueNotifier<bool> showDraggableRectangle = ValueNotifier<bool>(false);

  late Future<List<CustomOnionFromField>> _onions;

  // 시작할 때 받아옴
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onions = FieldApiService.getOnionFromField(widget.field.id);
  }

  // 양파 삭제하는 메서드
  void _deleteOnion(int onionId) {
    OnionApiService.deleteOnionById(onionId);
    setState(() {
      // 삭제된 양파를 상태의 onions 데이터 리스트에서 제거
      _onions = _onions.then(
          (onions) => onions.where((onion) => onion.id != onionId).toList());
    });
  }

  // 양파 삭제 모달
  void _showDeleteConfirmationDialog(BuildContext innerContext, int onionId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('양파를 삭제하시겠습니까?'),
          content: const Text('삭제한 양파는 되돌릴 수 없으며, 저장된 메시지 역시 사라지게 됩니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteOnion(onionId);
              },
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (innerContext) {
        return Container(
          width: (MediaQuery.of(context).size.width - 60),
          height: (MediaQuery.of(context).size.width - 60),
          // color: Colors.brown,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/field.png'), fit: BoxFit.fill),
          ),

          // _onions api 받아온 뒤 빌드
          child: FutureBuilder(
            future: _onions,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                List<CustomOnionFromField> onionsData =
                    snapshot.data as List<CustomOnionFromField>;

                return Center(
                  // 양파들을 격자로 표시
                  child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                    ),
                    children: onionsData.map((onion) {
                      return GestureDetector(
                        onLongPressStart: (details) {
                          final RenderBox box =
                              context.findRenderObject() as RenderBox;
                          final Offset position =
                              box.globalToLocal(details.globalPosition);
                          showDeleteModal(
                            context,
                            onion,
                            () => _showDeleteConfirmationDialog(
                                innerContext, onion.id),
                            () => widget.parentShowMoveSelectDialog(
                                innerContext, onion.id, widget.field.id),
                            position,
                          );
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OnionOneScreen(onionId: onion.id),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                onion.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Expanded(
                                child: Image.asset(onion.imgSrc),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                // return const CircularProgressIndicator();
                return const CustomLoadingWidget(
                    imagePath: 'assets/images/onion_image.png');
              }
            },
          ),
        );
      },
    );
  }
}

// delete 모달 표시
Future<void> showDeleteModal(
  BuildContext context,
  CustomOnionFromField onion,
  VoidCallback onDelete,
  VoidCallback onMove,
  Offset position,
) async {
  final RenderBox box = context.findRenderObject() as RenderBox;
  final Offset boxPosition = box.localToGlobal(Offset.zero);
  final Size boxSize = box.size;
  final Offset itemPosition = position - boxPosition;
  final double centerY = MediaQuery.of(context).size.height / 2;

  return showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      itemPosition.dx,
      centerY + itemPosition.dy,
      boxSize.width - itemPosition.dx,
      boxSize.height - itemPosition.dy,
    ),
    items: [
      // 양파 삭제 버튼
      PopupMenuItem(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('삭제'),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
          ],
        ),
      ),
      // 양파 이동 버튼
      PopupMenuItem(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('이동'),
            IconButton(
              icon: const Icon(Icons.update),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                onMove();
              },
            ),
          ],
        ),
      ),
    ],
  );
}
