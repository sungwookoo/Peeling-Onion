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
  void addField(fieldName) {
    FieldApiService.createField(fieldName).then((createdField) {
      setState(() {
        _fields = _fields.then((fields) {
          fields.add(createdField);
          return fields;
        });
      });
    });
  }

  // 밭 삭제하는 메서드
  void _deleteField(int index) {
    setState(() {
      _fields = _fields.then((fields) {
        fields.removeAt(index);
        return fields;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/backfarm.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
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
                  // 밭들을 grid 로 출력 (MakeField 클래스 사용)
                  MakeFields(
                    fields: fieldsData,
                  ),
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
            displayTextInputDialog(context, addField);
          },
          child: const Text('밭 추가'),
        ),
      ),
    );
  }
}
