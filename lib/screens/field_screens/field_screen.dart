import 'dart:math';

import 'package:flutter/material.dart';
import 'package:front/screens/field_screens/field_one_screen.dart';
import '../../models/custom_models.dart';
import '../../services/field_api_service.dart';

String textInput = '';

// 밭 화면
class FieldScreen extends StatefulWidget {
  const FieldScreen({super.key});
  final int id = 1;

  @override
  State<FieldScreen> createState() => _FieldScreenState();
}

class _FieldScreenState extends State<FieldScreen> {
  // 나타낼 밭 모양
  late Future<List<CustomField>> fields;

  @override
  void initState() {
    super.initState();
    fields = FieldApiService.getFieldsById(widget.id);
  }

  // 밭 추가하는 메서드 (이후 api 연결할 것)
  void addOne(fieldName) {
    setState(() {
      // 이후 여기는 수정. api 받아오도록.
      // fields.add(CustomField(
      //   id: 100,
      //   name: fieldName,
      //   // createdAt: DateTime.now(),
      //   onions: [],
      // ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff55D95D),
      // 밭 표시 (그리드는 최대한 중앙에)
      body: Center(
        child: FutureBuilder(
          future: fields,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              List<CustomField> fieldsData = snapshot.data as List<CustomField>;
              // 밭들을 출력하는 class
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MakeFields(fields: fieldsData),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            // 로딩 화면
            return const CircularProgressIndicator();
          },
        ),
      ),
      // 밭 추가하는 버튼 (이후 디자인 따라 수정할 예정)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayTextInputDialog(context, addOne);
        },
        child: const Text('밭 추가'),
      ),
    );
  }
}

// 모달로 밭 이름 입력받아서 추가 밭 생성 (이후 밭 이름 안겹치게 유효성 검사 하기)
// 문자 변수
TextEditingController _textFieldController = TextEditingController();

// 문자 포함하는 모달
Future<void> _displayTextInputDialog(
  BuildContext context,
  Function addOne,
) async {
  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          // 모달 창 시작
          return AlertDialog(
            title: const Text('밭 이름 작성'),
            // 입력 창
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
                hintText: '밭 이름',
                errorText:
                    _textFieldController.text.isEmpty ? '값을 입력해 주세요' : null,
              ),
              // 입력값 있으면 빨간 줄 사라지게
              onChanged: (value) {
                setState(() {
                  _textFieldController.text.isEmpty;
                });
              },
            ),
            // 버튼 누르기
            actions: <Widget>[
              TextButton(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('등록'),
                onPressed: () {
                  // Get the value of the text input
                  String text = _textFieldController.text;
                  // Do something with the text
                  if (text.isEmpty) {
                    return;
                  }
                  Navigator.pop(context);
                  addOne(text);
                },
              ),
            ],
          );
        },
      );
    },
  );
}

// 밭을 격자무늬로 표시하는 클래스
class MakeFields extends StatelessWidget {
  const MakeFields({
    super.key,
    required List<CustomField> fields,
  }) : _fields = fields;

  final List<CustomField> _fields;

  @override
  Widget build(BuildContext context) {
    // 페이지 수
    int numOfPages = (_fields.length / 6).ceil();

    // 페이지 표현
    return SizedBox(
      height: (MediaQuery.of(context).size.width - 60) / 2 * 3 + 20,
      child: PageView.builder(
        itemCount: numOfPages,
        itemBuilder: (BuildContext context, int pageIndex) {
          // 밭 번호 할당
          int startIndex = pageIndex * 6;
          int endIndex = min(startIndex + 6, _fields.length);

          // 현재 페이지에 속한 밭들의 리스트 제작
          List<CustomField> pageFields = _fields.sublist(startIndex, endIndex);

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
                    onTap: () {
                      // 밭 모달 띄우기
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => Container(
                          width:
                              MediaQuery.of(context).size.width, // 화면의 가로 길이만큼
                          height: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          // 띄울 밭 1개
                          child: FieldOneScreen(
                            field: field,
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

// 밭 1개를 출력하는 클래스
class FieldOneScreenHere extends StatefulWidget {
  final CustomField field;

  const FieldOneScreenHere({super.key, required this.field});

  @override
  State<FieldOneScreenHere> createState() => _FieldOneScreenHereState();
}

class _FieldOneScreenHereState extends State<FieldOneScreenHere> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 밭 이름 표시
            Text(
              widget.field.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // 픽셀 벗어나는 버그 고치기 위한 wrap
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.field.onions.map((onion) {
                return Column(
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
          ],
        ),
      ),
    );
  }
}
