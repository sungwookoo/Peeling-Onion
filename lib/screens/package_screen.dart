import 'package:flutter/material.dart';
import '../widgets/navigation_bar.dart';

class PackageScreen extends StatefulWidget {
  const PackageScreen({super.key});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('여긴 양파 밭입니다.'),
      bottomNavigationBar: NavigateBar(),
    );
  }
}
