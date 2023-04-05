import 'dart:math';
import 'package:flutter/material.dart';
import '../../services/find_user_api_service.dart';
import '../../widgets/loading_rotation.dart';

class InvitePeople extends StatefulWidget {
  const InvitePeople({Key? key, required this.people}) : super(key: key);

  final List<Map> people;

  @override
  State<InvitePeople> createState() => _InvitePeopleState();
}

class _InvitePeopleState extends State<InvitePeople> {
  List<Map?> _selectedPeople = [];
  final _findPeopleKey = GlobalKey<FormState>();
  late Future<List<Map>> _searchedUser = Future.value([]);
  String _searchWord = '';

  @override
  void initState() {
    super.initState();
    _selectedPeople = widget.people.map((person) => person).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFdFdF5),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Navigator.pop(context, []);
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
            onPressed: () {
              Navigator.pop(context, _selectedPeople);
            },
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
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFDFDF5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                _selectedPeople.isNotEmpty
                    ? SizedBox(
                        height: 40,
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
                      )
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: _findPeopleKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: '검색어를 입력하세요.',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            if (_findPeopleKey.currentState!.validate()) {
                              _findPeopleKey.currentState!.save();

                              _searchedUser =
                                  FindPeopleApiService.findUsersByWord(
                                      _searchWord);
                            }
                          },
                          icon: const Icon(Icons.search),
                          iconSize: 33,
                          padding: const EdgeInsets.only(top: 5),
                        )),
                    onSaved: (val) {
                      setState(() {
                        _searchWord = val as String;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '검색어를 입력해주세요!';
                      }
                      return null;
                    },
                  ),
                ),
                FutureBuilder(
                  future: _searchedUser,
                  builder: (context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      final searchedUsers = snapshot.data!;
                      return Expanded(
                        child: ListView.builder(
                          itemCount: searchedUsers.length,
                          itemBuilder: (context, int index) {
                            final user = searchedUsers[index];
                            return ListTile(
                              title: Text(user['nickname']),
                              trailing: _selectedPeople
                                      .any((obj) => obj?['id'] == user['id'])
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectedPeople.removeWhere(
                                              (element) =>
                                                  element?['id'] == user['id']);
                                        });
                                      },
                                      icon: const Icon(Icons.remove))
                                  : IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          _selectedPeople.add(user);
                                        });
                                      },
                                    ),
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text('데이터를 불러오는데 문제가 발생했습니다.');
                    }

                    return const CustomLoadingWidget(
                        imagePath: 'assets/images/onion_image.png');
                  },
                )
              ],
            ),
          ),
        ),
      ),
      bottomSheet: ElevatedButton(
        onPressed: () {
          setState(() {
            int n = Random().nextInt(100) + 1;
            _selectedPeople.add({'id': 123, 'nickname': n.toString()});
          });
        },
        child: const Text('추가'),
      ),
    );
  }
}
