import 'package:flutter/material.dart';
import 'package:front/alarm_provider.dart';
import 'package:provider/provider.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  Widget build(BuildContext context) {
    var alarmList = Provider.of<AlarmProvider>(context).alarmList;
    return ChangeNotifierProvider(
      create: (_) => AlarmProvider(),
      child: Scaffold(
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
            child: const Text('1')),
      ),
    );
  }
}
