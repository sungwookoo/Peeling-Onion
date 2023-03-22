import 'package:flutter/material.dart';

class InvitePeople extends StatefulWidget {
  const InvitePeople({super.key});

  @override
  State<InvitePeople> createState() => _InvitePeopleState();
}

class _InvitePeopleState extends State<InvitePeople> {
  final List<Map?> _selectedPeople = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFdFdF5),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            );
          },
        ),
        title: const Text(
          '함께 보낼 사람 초대',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          FloatingActionButton(
            elevation: 0,
            backgroundColor: const Color(0xFFFDFDF5),
            onPressed: () {},
            child: const Text(
              '확인',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFDFDF5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // _selectedPeople.isNotEmpty
              //     ? SingleChildScrollView(
              //         scrollDirection: Axis.horizontal,
              //         child: Row(
              //           children: _selectedPeople.map((person) {
              //             return Container(
              //               padding: const EdgeInsets.all(8.0),
              //               width: 50,
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(20),
              //                 color: Colors.grey,
              //               ),
              //               child: Text(
              //                 person?['nickname'] ?? '',
              //                 style: const TextStyle(
              //                     fontSize: 16, color: Colors.black),
              //               ),
              //             );
              //           }).toList(),
              //         ))
              //     : Container(),
              _selectedPeople.isNotEmpty
                  ? SizedBox(
                      height: 40,
                      child: Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedPeople.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      const Color.fromARGB(255, 192, 188, 188),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      _selectedPeople[index]?['nickname'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectedPeople.removeAt(index);
                                        });
                                      },
                                      icon: const Icon(Icons.clear),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      iconSize: 18,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 10,
              ),
              const Text('heloo')
            ],
          ),
        ),
      ),
      bottomSheet: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedPeople.add({'id': 123, 'nickname': '이름'});
          });
        },
        child: const Text('추가'),
      ),
    );
  }
}
