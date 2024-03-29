import 'package:flutter/material.dart';
import '../../models/custom_models.dart';
import '../../services/field_api_service.dart';
import './field_widgets/field_add_modal.dart';
import './field_widgets/make_fields.dart';
import '../../widgets/loading_rotation.dart';
import 'package:front/widgets/on_will_pop.dart';

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
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
                  List<CustomField> fieldsData =
                      snapshot.data as List<CustomField>;
                  // 밭들을 출력하는 class
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // 밭들을 grid 로 출력 (MakeField 클래스 사용)
                      MakeFields(
                        fields: fieldsData,
                        onCreate: () =>
                            displayTextInputDialog(context, addField),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                // 로딩 화면
                return const CustomLoadingWidget(
                    imagePath: 'assets/images/onion_image.png');
              }),
          floatingActionButton: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () => displayTextInputDialog(context, addField),
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
        ),
      ),
    );
  }
}
