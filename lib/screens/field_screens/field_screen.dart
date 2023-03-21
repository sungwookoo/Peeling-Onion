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
      // 밭 표시
      body: Column(
        children: [
          // api로 받아오는 밭 정보를 바탕으로 밭 표시
          FutureBuilder(
            future: fields,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                List<CustomField> fieldsData =
                    snapshot.data as List<CustomField>;
                // 밭을 출력하는 class
                return MakeFields(fields: fieldsData);
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              // 로딩 화면
              return const CircularProgressIndicator();
            },
          ),
        ],
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
    return Container(
      // 밭들을 화면에 표시 (지금은 화면 크면 밭도 커짐)
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: _fields.map((field) {
          return SizedBox(
            width: (MediaQuery.of(context).size.width - 60) / 2,
            height: (MediaQuery.of(context).size.width - 60) / 2,
            child: GestureDetector(
              // 밭 클릭하면 해당 밭으로 이동
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: FieldOneScreen(
                      field: field,
                    ),
                  ),
                );
              },
              // 해당 밭 표시
              child: FieldOneScreenHere(field: field),
            ),
          );
        }).toList(),
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
