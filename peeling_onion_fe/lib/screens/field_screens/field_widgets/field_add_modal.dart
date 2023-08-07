import 'package:flutter/material.dart';

// 모달로 밭 이름 입력받아서 추가 밭 생성 (이후 밭 이름 안겹치게 유효성 검사 하기)
// 문자 변수
TextEditingController textFieldController = TextEditingController();

// 문자 포함하는 모달 출력 함수
Future<void> displayTextInputDialog(
  BuildContext context,
  Function addField,
) async {
  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          // 모달 창 시작
          return AlertDialog(
            title: const Text(
              '밭 이름 작성',
            ),
            // 입력 창
            content: TextField(
              controller: textFieldController,
              decoration: InputDecoration(
                hintText: '밭 이름',
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffA1D57A)),
                ),
                errorText:
                    textFieldController.text.isEmpty ? '값을 입력해 주세요' : null,
              ),
              // 입력값 있으면 빨간 줄 사라지게
              onChanged: (value) {
                setState(() {
                  textFieldController.text.isEmpty;
                });
              },
            ),
            // 버튼 누르기
            actions: <Widget>[
              TextButton(
                child: const Text(
                  '취소',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text(
                  '등록',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: () {
                  // text input 값
                  String text = textFieldController.text;
                  // 예외 처리
                  if (text.isEmpty) {
                    return;
                  }
                  Navigator.pop(context);
                  addField(text);
                },
              ),
            ],
          );
        },
      );
    },
  );
}
