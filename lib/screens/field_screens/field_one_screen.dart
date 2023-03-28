import 'package:flutter/material.dart';
import 'package:front/services/field_api_service.dart';
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

  late Future<List<CustomOnionFromField>> _onions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onions = FieldApiService.getOnionFromField(widget.field.id);
  }

  @override
  Widget build(BuildContext context) {
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        onLongPress: () {},
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OnionOneScreen(onionId: onion.id),
                            ),
                          );
                        },
                        child: Image.asset('assets/images/onion_image.png'),
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
  }
}
