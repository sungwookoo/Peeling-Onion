import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import '../onion_one_screen.dart';

// 택배함 양파 1개 출력
class PostboxOneOnion extends StatelessWidget {
  const PostboxOneOnion({
    super.key,
    required List<CustomOnionByOnionIdPostbox> onions,
    required this.globalIndex,
    required this.onUpdate,
  }) : _onions = onions;

  final List<CustomOnionByOnionIdPostbox> _onions;
  final int globalIndex;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    // 양파를 클릭하면 양파 상세 페이지로, 꾹 누르면 삭제창 뜨게
    return GestureDetector(
      // 양파 클릭하면 상세 페이지로.
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            // OnionOneScreen 클래스 사용
            builder: (context) => OnionOneScreen(
              onionId: _onions.elementAt(globalIndex).id,
            ),
          ),
        );
        onUpdate();
      },
      child: OneOnion(onion: _onions.elementAt(globalIndex)),
    );
  }
}

// 택배함에서의 양파 1개 이미지
class OneOnion extends StatelessWidget {
  const OneOnion({
    super.key,
    required CustomOnionByOnionIdPostbox onion,
  }) : _onion = onion;

  final CustomOnionByOnionIdPostbox _onion;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  )),
              child: Column(
                children: [
                  Text(_onion.name),
                  Text(
                    'from : ${_onion.sender}',
                    style: const TextStyle(
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Flexible(
          child: Image.asset('assets/images/gift_box.png'),
        ),
      ],
    );
  }
}
