import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import '../onion_one_screen.dart';

// 택배함 양파 1개 출력
class PostboxOneOnion extends StatelessWidget {
  const PostboxOneOnion({
    super.key,
    required List<CustomOnionByOnionId> onions,
    required this.globalIndex,
  }) : _onions = onions;

  final List<CustomOnionByOnionId> _onions;
  final int globalIndex;

  @override
  Widget build(BuildContext context) {
    // 양파를 클릭하면 양파 상세 페이지로, 꾹 누르면 삭제창 뜨게
    return GestureDetector(
      // 양파 클릭하면 상세 페이지로.
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            // OnionOneScreen 클래스 사용
            builder: (context) => const OnionOneScreen(onionId: 10),
          ),
        );
      },
      child: OneOnion(onions: _onions, globalIndex: globalIndex),
    );
  }
}

// 택배함에서의 양파 1개 이미지
class OneOnion extends StatelessWidget {
  const OneOnion({
    super.key,
    required List<CustomOnionByOnionId> onions,
    required this.globalIndex,
  }) : _onions = onions;

  final List<CustomOnionByOnionId> _onions;
  final int globalIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_onions.elementAt(globalIndex).name),
        Image.asset('assets/images/onion_image.png'),
      ],
    );
  }
}
