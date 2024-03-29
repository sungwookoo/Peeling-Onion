import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/screens/onion_create/invite_people.dart';
import 'package:front/services/onion_api_service.dart';
import 'package:intl/intl.dart';

class OnionCreate extends StatefulWidget {
  const OnionCreate({Key? key, required this.isTogether}) : super(key: key);

  final bool isTogether;

  @override
  State<OnionCreate> createState() => _OnionCreateState();
}

class _OnionCreateState extends State<OnionCreate> {
  int _imageidx = 0;
  String _date = DateFormat('yyyy/MM/dd').format(DateTime.now());
  String _onionName = '';
  String _mobileNumber = '';
  List<Map> _withUser = [];
  final _onionFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isTogether = widget.isTogether;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/createbackground.jpg'),
            fit: BoxFit.fill),
      ),
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          // appBar: AppBar(
          //   backgroundColor: Colors.black,
          //   toolbarHeight: 15,
          // ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_imageidx == 0) {
                                _imageidx = 5;
                              } else {
                                _imageidx--;
                              }
                            });
                          },
                          icon: const Icon(Icons.keyboard_arrow_left),
                          iconSize: 40,
                        ),
                        Image(
                          image: AssetImage(
                              'assets/images/customonion$_imageidx.png'),
                          height: 220,
                          width: 220,
                          fit: BoxFit.cover,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _imageidx = (_imageidx + 1) % 6;
                            });
                          },
                          icon: const Icon(Icons.keyboard_arrow_right),
                          iconSize: 40,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _onionFormKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '양파 이름',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                            TextFormField(
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffA1D57A)),
                                ),
                              ),
                              onSaved: (val) {
                                setState(() {
                                  _onionName = val as String;
                                });
                              },
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return '양파 이름을 입력해주세요';
                                }
                                return null;
                              },
                              maxLength: 25,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '수신자(전화번호)',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffA1D57A)),
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                NumberFormatter(),
                                LengthLimitingTextInputFormatter(13)
                              ],
                              onSaved: (val) {
                                setState(() {
                                  String result = val as String;
                                  _mobileNumber = result.replaceAll('-', '');
                                });
                              },
                              validator: (val) {
                                if (val == null) {
                                  return '전화번호를 입력해주세요!';
                                } else if (val.length != 13) {
                                  return '올바르지 않은 전화번호입니다!';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        Visibility(
                            visible: isTogether,
                            child: const SizedBox(
                              height: 10,
                            )),
                        Visibility(
                          visible: isTogether,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '선택된 사람',
                                  style: TextStyle(
                                    // fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                _withUser.isNotEmpty
                                    ? Row(
                                        children: [
                                          Text(_withUser[0]['nickname']),
                                          if (_withUser.length > 1)
                                            Text('외 ${_withUser.length - 1}명'),
                                        ],
                                      )
                                    : Container(
                                        width: 100,
                                      ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 22, 110, 24),
                                  ),
                                  onPressed: () async {
                                    final people = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => InvitePeople(
                                                  people: _withUser,
                                                )));
                                    if (people is List<Map>) {
                                      setState(() {
                                        _withUser = people;
                                      });
                                    }
                                  },
                                  child: const Text('함께 보낼 사람'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.black54))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '수확일',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(_date),
                              const SizedBox(
                                width: 15,
                              ),
                              IconButton(
                                onPressed: () async {
                                  final selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2050),
                                    builder: (context, child) {
                                      return Theme(
                                          data: Theme.of(context).copyWith(
                                              colorScheme:
                                                  const ColorScheme.light(
                                            primary: Color.fromARGB(
                                                255, 33, 206, 122),
                                          )),
                                          child: child!);
                                    },
                                  );
                                  if (selectedDate != null) {
                                    setState(() {
                                      _date = DateFormat('yyyy/MM/dd')
                                          .format(selectedDate);
                                    });
                                  }
                                },
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 22, 110, 24),
                            ),
                            onPressed: () async {
                              if (_onionFormKey.currentState!.validate()) {
                                _onionFormKey.currentState!.save();
                                if (_withUser.isEmpty && isTogether) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('함께 보낼 사람을 적어도 1명 선택해주세요!')),
                                  );
                                } else {
                                  bool isSingle = !isTogether;

                                  OnionApiService.createOnion(
                                          onionName: _onionName,
                                          onionImage:
                                              'assets/images/customonion$_imageidx.png',
                                          receiverNumber: _mobileNumber,
                                          growDueDate: _date,
                                          isSingle: isSingle,
                                          userList: _withUser)
                                      .then((value) => Navigator.pop(context));
                                }
                              }
                            },
                            child: const Text('양파 만들기'),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex <= 3) {
        if (nonZeroIndex % 3 == 0 && nonZeroIndex != text.length) {
          buffer.write('-'); // Add double spaces.
        }
      } else {
        if (nonZeroIndex % 7 == 0 &&
            nonZeroIndex != text.length &&
            nonZeroIndex > 4) {
          buffer.write('-');
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}
