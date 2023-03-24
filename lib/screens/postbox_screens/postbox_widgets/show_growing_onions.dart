import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import 'package:front/screens/postbox_screens/postbox_widgets/draggable_onion.dart';

//
class ShowGrowingOnions extends StatefulWidget {
  final List<CustomHomeOnion> _onions;

  const ShowGrowingOnions({
    super.key,
    required List<CustomHomeOnion> onions,
  }) : _onions = onions;

  @override
  State<ShowGrowingOnions> createState() => _ShowGrowingOnionsState();
}

class _ShowGrowingOnionsState extends State<ShowGrowingOnions> {
  int onionsPerPage = 9;

  late int numOfPages = (widget._onions.length / onionsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    // 양파 수가 많으면, 페이지 넘겨서 확인
    return PageView.builder(
      itemCount: numOfPages,
      itemBuilder: (context, pageIndex) {
        // 선반 세로로 출력
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // 선반 3개출력
            children: List.generate(
              3,
              (shelfIndex) {
                int onionsPerShelf = 3;
                int firstOnionIndex =
                    pageIndex * onionsPerPage + shelfIndex * onionsPerShelf;
                // 각 선반 1개
                return Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: onionsPerShelf,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (BuildContext context, int itemIndex) {
                        int globalIndex = firstOnionIndex + itemIndex;
                        if (globalIndex < widget._onions.length) {
                          // 각 양파 1개 (텍스트 + 이미지)
                          return DraggableOnion(
                              onions: widget._onions, globalIndex: globalIndex);
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    // 선반 1개 이미지
                    Image.asset(
                      'assets/images/shelf.png',
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
