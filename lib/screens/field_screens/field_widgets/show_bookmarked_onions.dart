import 'package:flutter/material.dart';
import 'package:front/screens/field_screens/onion_one_screen.dart';
import '../../../models/custom_models.dart';

class ShowBookmarkedOnions extends StatefulWidget {
  final List<CustomOnionFromField> onions;
  const ShowBookmarkedOnions({super.key, required this.onions});

  @override
  State<ShowBookmarkedOnions> createState() => _ShowBookmarkedOnionsState();
}

class _ShowBookmarkedOnionsState extends State<ShowBookmarkedOnions> {
  late List<CustomOnionFromField> onions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onions = widget.onions;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: onions.length,
      itemBuilder: (context, index) {
        final onion = onions[index];
        final String recievedDay =
            '${onion.recieveDate.substring(0, 4)} / ${onion.recieveDate.substring(5, 7)} / ${onion.recieveDate.substring(8, 10)}';

        return Container(
          // margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OnionOneScreen(onionId: onion.id)),
              );
            },
            child: Row(
              children: [
                Expanded(
                  child: Image.asset(onion.imgSrc),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('이름: ${onion.name}'),
                    const SizedBox(height: 8.0),
                    Text('보낸 날짜: $recievedDay'),
                    const SizedBox(height: 8.0),
                    Text('보낸 이: ${onion.sender}'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
