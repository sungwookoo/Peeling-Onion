import 'package:flutter/material.dart';
import '../widgets/navigation_bar.dart';

class FieldScreen extends StatefulWidget {
  const FieldScreen({super.key});

  @override
  State<FieldScreen> createState() => _FieldScreenState();
}

class _FieldScreenState extends State<FieldScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Text('양파 밭 화면입니다.'),
      bottomNavigationBar: NavigateBar(),
    );
  }
}
