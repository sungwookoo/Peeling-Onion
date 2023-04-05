import 'package:flutter/material.dart';
import 'package:front/services/alarm_api_service.dart';
import 'package:front/widgets/loading_rotation.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final List<String> _typeMessage = [
    '양파가 상하기 직전이에요.',
    '님이 보낸 양파가 도착했어요.',
    '양파를 보낼 수 있어요.',
    '님이 만든 모아보내기 양파에 초대되었어요.',
  ];
  final List<String> _typeImage = [
    'assets/images/oniondead.png',
    'assets/images/getMessage.png',
    'assets/images/timetosend.png',
    'assets/images/invite.jpg',
  ];
  late Future<List> _alarmList = Future.value([]);

  @override
  void initState() {
    super.initState();
    _alarmList = AlarmApiService().getAlarmList();
  }

  void updateAlarmList() {
    setState(() {
      _alarmList = AlarmApiService().getAlarmList();
    });
    print('제대로 됨?');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFDFDF5),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          );
        }),
        title: const Text(
          '알림',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFDFDF5),
        ),
        child: Column(
          children: [
            FutureBuilder(
              future: _alarmList,
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  final alarmLists = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: alarmLists.length,
                      itemBuilder: (context, int index) {
                        final alarm = alarmLists[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 3, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.symmetric(
                                horizontal: BorderSide(
                              color: Colors.grey.shade200,
                            )),
                          ),
                          // borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            leading: Image(
                              image:
                                  AssetImage(_typeImage[alarm.alarmType - 1]),
                              width: 80,
                            ),
                            title: (alarm.alarmType == 1 ||
                                    alarm.alarmType == 3)
                                ? Text(_typeMessage[alarm.alarmType - 1])
                                : Text(
                                    '${alarm.senderNickname}${_typeMessage[alarm.alarmType - 1]}'),
                            trailing: !alarm.isRead
                                ? const Icon(
                                    Icons.circle,
                                    size: 8,
                                    color: Colors.red,
                                  )
                                : const SizedBox(
                                    width: 8,
                                  ),
                            onTap: () {
                              if (!alarm.isRead) {
                                setState(() {
                                  alarm.changeReadStatus();
                                });
                                AlarmApiService().readAlarm(alarm.alarmId);
                                // updateAlarmList();
                              }
                            },
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Text('데이터를 불러오는데 문제가 발생했습니다');
                }

                return const CustomLoadingWidget(
                    imagePath: 'assets/images/onion_image.png');
              },
            )
          ],
        ),
      ),
    );
  }
}
