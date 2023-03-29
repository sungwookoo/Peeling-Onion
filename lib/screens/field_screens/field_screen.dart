import 'package:flutter/material.dart';
import '../../models/custom_models.dart';
import '../../services/field_api_service.dart';
import './field_widgets/field_add_modal.dart';
import './field_widgets/make_fields.dart';

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
  late Future<List<CustomField>> _fields;

  @override
  void initState() {
    super.initState();
    _fields = FieldApiService.getFieldsByUser();
  }

  // 밭 추가하는 메서드 (이후 api 연결할 것)
  void addOne(fieldName) {
    setState(() {
      // 이후 여기는 수정. api 받아오도록.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff55D95D),
      // 밭 표시 (그리드는 최대한 중앙에)
      body: FutureBuilder(
        future: _fields,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            List<CustomField> fieldsData = snapshot.data as List<CustomField>;
            // 밭들을 출력하는 class
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 밭들을 grid 로 출력
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
      // 밭 추가하는 버튼, 모달로 띄움(이후 디자인 따라 수정할 예정)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          displayTextInputDialog(context, addOne);
        },
        child: const Text('밭 추가'),
      ),
    );
  }
}
