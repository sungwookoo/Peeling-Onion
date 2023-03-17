import 'package:flutter/material.dart';
import '../../models/custom_models.dart';
import './field_one_screen.dart';

String textInput = '';

// 밭 화면
class FieldScreen extends StatefulWidget {
  const FieldScreen({super.key});

  @override
  State<FieldScreen> createState() => _FieldScreenState();
}

class _FieldScreenState extends State<FieldScreen> {
  // 나타낼 밭 모양
  final List<CustomField> _fields = _getFields();
  // 확대됐는지 아닌지 판단
  final bool _isExpanded = false;

  // 확대될 밭을 결정
  final int _expandedIndex = -1;

  // 밭 추가하는 메서드
  void addOne(fieldName) {
    setState(() {
      _fields.add(CustomField(
        name: fieldName,
        createdAt: DateTime.now(),
        onions: [],
      ));
      print(_fields.elementAt(4).name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff55D95D),
      // 밭 표시
      body: Column(
        children: [
          Expanded(
            child: MakeFields(fields: _fields),
          ),
        ],
      ),
      // 밭 추가하는 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayTextInputDialog(context, addOne);
        },
        child: const Text('밭 추가'),
      ),
    );
  }
}

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
    return GridView(
      // 밭을 2줄짜리 격자로 표현
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
      ),
      children: _fields.map((field) {
        return Container(
          margin: const EdgeInsets.all(20),
          child: FieldOneScreen(field: field),
        );
      }).toList(),
    );
  }
}

// 샘플 양파
final List<CustomOnion> _onions = [
  CustomOnion(
    name: '양파 1',
    createdAt: DateTime.now(),
    sender: 'Sender 1',
    messages: [
      CustomMessage(
        sender: 'Sender 1',
        createdAt: DateTime.now(),
        url: 'https://example.com/image1.jpg',
      ),
      CustomMessage(
        sender: 'Sender 2',
        createdAt: DateTime.now(),
        url: 'https://example.com/image2.jpg',
      ),
      CustomMessage(
        sender: 'Sender 1',
        createdAt: DateTime.now(),
        url: 'https://example.com/image3.jpg',
      ),
    ],
  ),
  CustomOnion(
    name: '양파 2 ㅎㅎㅎㅎㅎㅎㅎㅎ',
    createdAt: DateTime.now(),
    sender: 'Sender 3',
    messages: [
      CustomMessage(
        sender: 'Sender 3',
        createdAt: DateTime.now(),
        url: 'https://example.com/image4.jpg',
      ),
      CustomMessage(
        sender: 'Sender 4',
        createdAt: DateTime.now(),
        url: 'https://example.com/image5.jpg',
      ),
      CustomMessage(
        sender: 'Sender 3',
        createdAt: DateTime.now(),
        url: 'https://example.com/image6.jpg',
      ),
    ],
  ),
  CustomOnion(
    name: '양파 3 ㅎㅎㅎㅎㅎㅎㅎㅎ',
    createdAt: DateTime.now(),
    sender: 'Sender 3',
    messages: [],
  ),
  CustomOnion(
    name: '양파 4 ㅎㅎㅎㅎㅎㅎㅎㅎ',
    createdAt: DateTime.now(),
    sender: 'Sender 3',
    messages: [],
  ),
];
// 샘플 밭
List<CustomField> _getFields() {
  return [
    CustomField(
      name: 'field_1',
      createdAt: DateTime.now(),
      onions: _onions,
    ),
    CustomField(
      name: 'field_2',
      createdAt: DateTime.now(),
      onions: _onions,
    ),
    CustomField(
      name: 'field_3',
      createdAt: DateTime.now(),
      onions: _onions,
    ),
    CustomField(
      name: 'field_4',
      createdAt: DateTime.now(),
      onions: _onions,
    ),
  ];
}
