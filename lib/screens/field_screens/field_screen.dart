import 'package:flutter/material.dart';
import '../../models/custom_models.dart';
import './field_one_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff55D95D),
      body: Column(
        children: [
          Expanded(
            child: MakeFields(fields: _fields),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _fields.add(CustomField(
              name: 'field_${_fields.length + 1}',
              createdAt: DateTime.now(),
              onions: [],
            ));
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
      ),
      children: _fields.map((field) {
        return Container(
          margin: const EdgeInsets.all(20),
          child: InkWell(
            // 밭을 클릭하면, 확대해서 보여줄 예정
            onTap: () {},
            // 밭 1개씩 표시하는 클래스
            child: FieldOneScreen(field: field),
          ),
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
