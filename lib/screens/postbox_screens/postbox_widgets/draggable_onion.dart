import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';

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
    // 양파를 클릭하면 양파 상세 페이지로, 꾹 누르면 drag and drop
    return GestureDetector(
      // 양파 클릭하면 상세 페이지로.
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) =>
      //           OnionOneScreen(onion: _onions.elementAt(globalIndex)),
      //     ),
      //   );
      // },
      child: LongPressDraggable<int>(
        // 일정 시간 눌러야 드래그 가능
        delay: const Duration(seconds: 1),
        // 전달할 데이터 (양파 번호)
        data: _onions.elementAt(globalIndex).onionId,
        // 드래그 할 때 양파 이미지만 투명해지게 이동하기. 이후 예쁘게 수정 예정
        feedback: SizedBox(
          width: 100,
          height: 100,
          child: Center(
            child: Transform.scale(
              scale: 1.2,
              child: Opacity(
                opacity: 0.6,
                child: Image.asset('assets/images/onion_image.png'),
              ),
            ),
          ),
        ),
        // 드래그할 때 보일 양파 이미지
        childWhenDragging: OneOnion(onions: _onions, globalIndex: globalIndex),
        // 겉으로 보일 양파
        child: OneOnion(onions: _onions, globalIndex: globalIndex),
      ),
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
        Text(_onions.elementAt(globalIndex).onionName),
        Image.asset('assets/images/onion_image.png'),
      ],
    );
  }
}
