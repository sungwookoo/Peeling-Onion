import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:front/screens/field_screens/field_one_screen.dart';
import 'package:front/screens/field_screens/field_widgets/field_one_screen_here.dart';
import 'package:front/screens/field_screens/field_widgets/show_bookmarked_onions.dart';
import 'package:front/services/onion_api_service.dart';
import '../../../models/custom_models.dart';
import 'package:front/services/field_api_service.dart';
import '../../../widgets/loading_rotation.dart';

// 밭 Grid 로 출력
class MakeFields extends StatefulWidget {
  final List<CustomField> _fields;
  final Function onCreate;

  const MakeFields({
    super.key,
    required List<CustomField> fields,
    required this.onCreate,
  }) : _fields = fields;

  @override
  State<MakeFields> createState() => _MakeFieldsState();
}

class _MakeFieldsState extends State<MakeFields> {
  // 양파 밭 이동할 때 사용할 변수들
  bool _isOnionMoving = false;
  late int _movingOnionId;
  late int _movingFromFId;
  // 밭들 정보
  late final List<CustomField> _fields;
  // 즐겨찾기 양파들 정보
  late Future<List<CustomOnionFromField>> _bookmarkedOnions;

  @override
  void initState() {
    super.initState();
    _fields = widget._fields;
    _bookmarkedOnions = OnionApiService.getBookmarkedOnion();
  }

  void _updateBookmark() {
    setState(() {
      _bookmarkedOnions = OnionApiService.getBookmarkedOnion();
    });
  }

  // 밭 삭제하는 메서드
  void _deleteField(int fieldId) {
    FieldApiService.deleteField(fieldId);

    setState(() {
      _fields.removeWhere((field) => field.id == fieldId);
    });
  }

  // 밭 삭제 모달
  void _showDeleteConfirmationDialog(int fieldId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('밭을 삭제하시겠습니까?'),
          content: const Text('삭제한 밭은 되돌릴 수 없으며, 저장된 양파 역시 사라지게 됩니다.'),
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
                _deleteField(fieldId);
              },
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }

  // 양파 이동 모달
  void showMoveSelectDialog(
      BuildContext innerContext, int onionId, int fromFId) {
    setState(() {
      _isOnionMoving = true;
      _movingOnionId = onionId;
      _movingFromFId = fromFId;
    });
  }

  // 밭 이름 변경 메서드
  String fieldName = 'basic';
  void _renameField(int fieldId, String fieldName) async {
    await FieldApiService.updateFieldName(fieldId, fieldName);
    // Update local state
    setState(() {
      int index = _fields.indexWhere((field) => field.id == fieldId);
      _fields[index] = _fields[index].copyWith(name: fieldName);
    });
  }

  // 밭 이름 변경 모달
  void _showGetRenameDialog(int fieldId) async {
    final TextEditingController fieldNameUpdate = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        String text = 'basic text';
        return AlertDialog(
          title: const Text('바꿀 이름을 입력하세요.'),
          content: TextField(
            controller: fieldNameUpdate,
            decoration: InputDecoration(
              hintText: '밭 이름',
              errorText: fieldNameUpdate.text.isEmpty ? '값을 입력해 주세요' : null,
            ),
            // 입력값 있으면 빨간 줄 사라지게
            onChanged: (value) {
              setState(() {
                fieldNameUpdate.text.isEmpty;
              });
            },
          ),
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
                _renameField(
                    fieldId, fieldNameUpdate.text); // call the delete method
              },
              child: const Text('변경'),
            ),
          ],
        );
      },
    );
  }

  // 즐겨찾기 한 양파들 모달
  void _showBookmarkedDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFEFEF5),
          title: const Text(
            '즐겨찾기',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'CookieRun',
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: FutureBuilder(
                future: _bookmarkedOnions,
                builder: (BuildContext context,
                    AsyncSnapshot<List<CustomOnionFromField>> snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: 300,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: ShowBookmarkedOnions(
                                onions: snapshot.data ?? []),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('에러');
                  } else {
                    return const SizedBox(
                      height: 300,
                      child: CustomLoadingWidget(
                          imagePath: 'assets/images/onion_image.png'),
                    );
                  }
                }),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 페이지 수
    int numOfPages = (widget._fields.length / 2).ceil();
    // 페이지 표현
    return Expanded(
      child: GestureDetector(
        onTap: () {
          print(_isOnionMoving);
          setState(() {
            _isOnionMoving = false;
          });
        },
        child: Stack(
          children: [
            // 양파 이동시키려는 상태면 아래 글을 표시
            if (_isOnionMoving)
              Center(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 2)),
                      child: Column(
                        children: [
                          const Text(
                            '양파를 옮길 밭을 골라주세요!',
                            style: TextStyle(
                                fontFamily: 'cookieRun',
                                color: Colors.black,
                                fontSize: 20),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _isOnionMoving = false;
                              });
                            },
                            child: const Text('취소'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            // 양파 밭을 페이지처럼 넘기도록 구현
            Column(
              children: [
                // 즐겨찾기 목록
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 50),
                    alignment: Alignment.bottomLeft,
                    child: GestureDetector(
                      onTap: () {
                        _updateBookmark();
                        _showBookmarkedDialog();
                      },
                      child: SizedBox(
                        height: 100,
                        child: Image.asset('assets/images/starwithwing.png'),
                      ),
                    ),
                  ),
                ),
                // 아래의 밭 페이지 구현
                Expanded(
                  child: PageView.builder(
                    itemCount: numOfPages,
                    itemBuilder: (BuildContext context, int pageIndex) {
                      // 밭 번호 할당
                      int startIndex = pageIndex * 2;
                      int endIndex = min(startIndex + 2, widget._fields.length);

                      // 현재 페이지에 속한 밭들의 리스트 제작
                      List<CustomField> pageFields =
                          widget._fields.sublist(startIndex, endIndex);

                      // 현재 페이지의 밭들을 UI 에 표시
                      return Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Wrap(
                              // 각 밭들을 한 번씩 return 해서 children 에 담음
                              children: pageFields.map((field) {
                                double top = 0;
                                return SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width - 60) /
                                          2,
                                  height:
                                      (MediaQuery.of(context).size.width - 60) /
                                          2.5,
                                  // 밭을 클릭하면, 해당 밭을 확대해서 모달로 띄움. 이 때 상세 정보를 api로 받아서 보여줄 예정
                                  child: GestureDetector(
                                    onLongPressStart: (details) {
                                      _showFieldPopup(
                                        context,
                                        field,
                                        () => _showDeleteConfirmationDialog(
                                            field.id),
                                        () => _showGetRenameDialog(field.id),
                                        details,
                                      );
                                    },
                                    onTap: () {
                                      // 양파 밭 이동하는 상태인 경우
                                      if (_isOnionMoving) {
                                        if (_movingFromFId == field.id) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('이미 그 밭에 있습니다.'),
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        } else {
                                          OnionApiService.updateOnionField(
                                              _movingOnionId,
                                              _movingFromFId,
                                              field.id);
                                          setState(() {
                                            _isOnionMoving = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('옮겨심기 성공!'),
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        }
                                      } else {
                                        // 밭 모달 띄우기
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width, // 화면의 가로 길이만큼
                                            height: MediaQuery.of(context)
                                                .size
                                                .width,
                                            alignment: Alignment.center,
                                            // 모달로 띄울 밭 1개 (FieldOneScreen 클래스 사용)
                                            child: FieldOneScreen(
                                              field: field,
                                              parentShowMoveSelectDialog:
                                                  showMoveSelectDialog,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    // 전체 밭 화면에서 나타나게 할 밭 1개
                                    child: Animate(
                                      // 양파 이동 중이면, 밭 표지판을 진동시키기
                                      child: _isOnionMoving
                                          ? FieldOneScreenHere(field: field)
                                              .animate(
                                                onPlay: (controller) =>
                                                    controller.repeat(),
                                              )
                                              .moveX(begin: 0, end: 5)
                                              .then()
                                              .moveX(begin: 5, end: 0)
                                          : FieldOneScreenHere(field: field),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            // 밭 추가 아이콘
            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () => widget.onCreate(),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      )),
                  height: 65,
                  child: Image.asset('assets/images/shovel.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 밭 삭제 popup 창
Future<void> _showFieldPopup(
    BuildContext context,
    CustomField field,
    VoidCallback onDelete,
    VoidCallback onRename,
    LongPressStartDetails details) async {
  final position = details.globalPosition;
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;
  final RelativeRect positionOffset = RelativeRect.fromRect(
    Rect.fromPoints(position, position),
    Offset.zero & overlay.size,
  );
  return showMenu(
    context: context,
    position: positionOffset,
    items: [
      PopupMenuItem(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // const Text('삭제'),
            // IconButton(
            //   icon: const Icon(Icons.delete),
            //   onPressed: () {
            //     Navigator.pop(context);
            //     onDelete();
            //   },
            // ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
              child: const Text('삭제'),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onRename();
              },
              child: const Text('이동'),
            )
          ],
        ),
      ),
      // PopupMenuItem(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       // const Text('이름 변경'),
      //       IconButton(
      //         icon: const Icon(Icons.update),
      //         onPressed: () {
      //           Navigator.pop(context);
      //           onRename();
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    ],
  );
}
