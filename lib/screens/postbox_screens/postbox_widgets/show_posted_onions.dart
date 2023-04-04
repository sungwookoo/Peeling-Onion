import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import '../postbox_widgets/postbox_one_onion.dart';

// 택배함에서 기르는 양파들 보여주는 클래스
class ShowPostedOnions extends StatefulWidget {
  final List<CustomOnionByOnionIdPostbox> _onions;

  const ShowPostedOnions({
    super.key,
    required List<CustomOnionByOnionIdPostbox> onions,
  }) : _onions = onions;

  @override
  State<ShowPostedOnions> createState() => _ShowPostedOnionsState();
}

class _ShowPostedOnionsState extends State<ShowPostedOnions> {
  int onionsPerPage = 4;
  int shelvesPerPage = 2;
  int onionsPerShelf = 2;

  late int numOfPages = (widget._onions.length / onionsPerPage).ceil();
  @override
  Widget build(BuildContext context) {
    // 선반이 비어있으면, 빈 선반 표시
    if (widget._onions.isEmpty) {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/wall_paper.jpg'),
              fit: BoxFit.fill),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // Display 3 shelves
            children: List.generate(
              shelvesPerPage,
              (shelfIndex) {
                // Display each shelf
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Display shelf image
                      Image.asset(
                        'assets/images/shelf.png',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    }
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
              shelvesPerPage,
              (shelfIndex) {
                int firstOnionIndex =
                    pageIndex * onionsPerPage + shelfIndex * onionsPerShelf;
                // 각 선반 1개
                return Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: onionsPerShelf,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: onionsPerShelf,
                          childAspectRatio: 0.9,
                        ),
                        itemBuilder: (BuildContext context, int itemIndex) {
                          int globalIndex = firstOnionIndex + itemIndex;
                          if (globalIndex < widget._onions.length) {
                            // 각 양파 1개 (텍스트 + 이미지)
                            return PostboxOneOnion(
                                onions: widget._onions,
                                globalIndex: globalIndex);
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
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
