import 'package:flutter/material.dart';

class PackageScreen extends StatefulWidget {
  const PackageScreen({super.key});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('여긴 양파 택배함입니다.'),
    );
  }
}
