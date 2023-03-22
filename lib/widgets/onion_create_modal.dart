import 'package:flutter/material.dart';
import 'package:front/screens/onion_create/home_onion_create_screen.dart';

class OnionCreateDialog extends StatelessWidget {
  const OnionCreateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 154, 229, 187),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('혼자 보내기'),
                  Image(
                    image: AssetImage('assets/images/letter.png'),
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const OnionCreate(isAlone: false)));
              },
            ),
            InkWell(
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('모아 보내기'),
                  Image(
                    image: AssetImage('assets/images/letters.png'),
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const OnionCreate(isAlone: true)));
              },
            )
          ],
        ),
      ),
    );
  }
}
