import 'package:flutter/material.dart';
import 'package:front/services/field_api_service.dart';
import 'package:front/services/onion_api_service.dart';
import './onion_one_screen.dart';
import '../../models/custom_models.dart';

// 밭 1개를 모달로 출력하는 클래스
class FieldOneScreen extends StatefulWidget {
  final CustomField field;
  // late bool showDraggableRectangle;
  final Function(bool) onValueChanged;

  const FieldOneScreen({
    super.key,
    required this.field,
    required this.onValueChanged,
  });

  @override
  State<FieldOneScreen> createState() => _FieldOneScreenState();
}

class _FieldOneScreenState extends State<FieldOneScreen> {
  ValueNotifier<bool> showDraggableRectangle = ValueNotifier<bool>(false);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                Navigator.pop(context); // dismiss the dialog
              },
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // dismiss the dialog
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
          color: Colors.brown,
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
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                    ),
                    children: onionsData.map((onion) {
                      return Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        children: [
                          // 꾹 누르면 이동/삭제 선택창이 나타나게
                          // 이동 누르면 이전 창으로 가서, 밭을 선택할 수 있음
                          GestureDetector(
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
                            child: Column(
                              children: [
                                Text(onion.onionName),
                                Image.asset(onion.imgSrc),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
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
      // boxSize.height,

      // 10000,
      boxSize.width - itemPosition.dx,
      boxSize.height - itemPosition.dy,
    ),
    items: [
      PopupMenuItem(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(onion.onionName),
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
    ],
  );
}
