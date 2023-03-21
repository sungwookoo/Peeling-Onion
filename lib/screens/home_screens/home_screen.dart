import 'package:flutter/material.dart';
import 'package:front/screens/home_onion_create_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: const Center(
        child: Text('hi'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const OnionCreate()));
      }),
      // bottomNavigationBar: const NavigateBar(),
    );
  }
}

// service에서 받아온 axios 요청을 바탕으로, 양파 출력
// class HomeOnions extends StatefulWidget {


//   const HomeOnions({super.key});

//   @override
//   State<HomeOnions> createState() => _HomeOnionsState();
// }

// class _HomeOnionsState extends State<HomeOnions> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
