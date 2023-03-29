import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import '../onion_one_screen.dart';

// drag & drop 가능한 양파 구현
class DraggableOnion extends StatelessWidget {
  const DraggableOnion({
    super.key,
    required List<CustomHomeOnion> onions,
    required this.globalIndex,
  }) : _onions = onions;

  final List<CustomHomeOnion> _onions;
  final int globalIndex;

  @override
  Widget build(BuildContext context) {
    // 양파를 클릭하면 양파 상세 페이지로, 꾹 누르면 삭제
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
    required List<CustomHomeOnion> onions,
    required this.globalIndex,
  }) : _onions = onions;

  final List<CustomHomeOnion> _onions;
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
