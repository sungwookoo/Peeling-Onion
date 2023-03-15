import 'package:flutter/material.dart';
import '../../models/custom_onion_model.dart';
import '../../models/custom_message_model.dart';

class FieldScreen extends StatefulWidget {
  const FieldScreen({super.key});

  @override
  State<FieldScreen> createState() => _FieldScreenState();
}

class _FieldScreenState extends State<FieldScreen> {
  // 샘플 양파
  final List<CustomOnion> onions = [
    CustomOnion(
      name: 'Onion 1',
      createdAt: DateTime.now(),
      sender: 'Sender 1',
      messages: [
        CustomMessage(
          sender: 'Sender 1',
          createdAt: DateTime.now(),
          url: 'https://example.com/image1.jpg',
        ),
        CustomMessage(
          sender: 'Sender 2',
          createdAt: DateTime.now(),
          url: 'https://example.com/image2.jpg',
        ),
        CustomMessage(
          sender: 'Sender 1',
          createdAt: DateTime.now(),
          url: 'https://example.com/image3.jpg',
        ),
      ],
    ),
    CustomOnion(
      name: 'Onion 2',
      createdAt: DateTime.now(),
      sender: 'Sender 3',
      messages: [
        CustomMessage(
          sender: 'Sender 3',
          createdAt: DateTime.now(),
          url: 'https://example.com/image4.jpg',
        ),
        CustomMessage(
          sender: 'Sender 4',
          createdAt: DateTime.now(),
          url: 'https://example.com/image5.jpg',
        ),
        CustomMessage(
          sender: 'Sender 3',
          createdAt: DateTime.now(),
          url: 'https://example.com/image6.jpg',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff55D95D),
      body: Text('양파 밭 화면입니다.'),
    );
  }
}
