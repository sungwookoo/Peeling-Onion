import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OnionCreate extends StatefulWidget {
  const OnionCreate({super.key});

  @override
  State<OnionCreate> createState() => _OnionCreateState();
}

class _OnionCreateState extends State<OnionCreate> {
  String date = DateFormat.yMMMd().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/backfarm.png'), fit: BoxFit.fill),
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
                const SizedBox(
                  height: 50,
                ),
                const Center(
                  child: Image(
                    image: AssetImage('assets/images/customonion1.png'),
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: '양파 이름',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: '수신자(전화번호)',
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
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(date),
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
                                          primary:
                                              Color.fromARGB(255, 33, 206, 122),
                                        )),
                                        child: child!);
                                  },
                                );
                                if (selectedDate != null) {
                                  setState(() {
                                    date =
                                        DateFormat.yMMMd().format(selectedDate);
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
                          onPressed: () {},
                          child: const Text('양파 만들기'),
                        ),
                      ),
                    ],
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
