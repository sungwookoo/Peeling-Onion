import 'package:flutter/material.dart';
import 'package:front/screens/onion_create/home_onion_create_screen.dart';

class OnionCreateDialog extends StatelessWidget {
  const OnionCreateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      insetPadding: EdgeInsets.zero,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: const Image(
                image: AssetImage('assets/images/createAlone.png'),
                width: 120,
                height: 120,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const OnionCreate(isTogether: false)));
              },
            ),
            const SizedBox(
              width: 20,
            ),
            InkWell(
              child: const Image(
                image: AssetImage('assets/images/createTogether.png'),
                width: 120,
                height: 120,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const OnionCreate(isTogether: true)));
              },
            )
          ],
        ),
      ),
    );
  }
}
