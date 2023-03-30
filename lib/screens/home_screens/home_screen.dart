import 'package:flutter/material.dart';
import 'package:front/widgets/onion_create_modal.dart';
import 'package:front/models/custom_models.dart';
import 'package:front/services/onion_api_service.dart';
import './home_widgets/home_one_onion.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 받아온 기르는 양파 정보들
  late Future<List<CustomHomeOnion>> onions;

  @override
  void initState() {
    super.initState();
    onions = OnionApiService.getGrowingOnionByUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FutureBuilder(
          future: onions,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              List<CustomHomeOnion> onionsData =
                  snapshot.data as List<CustomHomeOnion>;
              // 양파들 출력
              return ShowGrowingOnions(onions: onionsData);
            } else if (snapshot.hasError) {
              return Text('에러: ${snapshot.error}');
            }
            // 로딩 화면
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayOnionCreateModal(context);
        },
      ),
      // bottomNavigationBar: const NavigateBar(),
    );
  }
}

// 양파들을 격자로 표시 (페이지 뷰 사용)
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
  late final List<CustomHomeOnion> _onions = widget._onions;

  void _deleteOnion(int index) {
    setState(() {
      // Remove the onion from the list
      _onions.removeAt(index);
    });
  }

  int onionsPerPage = 9;

  late int numOfPages = (widget._onions.length / onionsPerPage).ceil();
  double onionMaxHeight = 210;

  @override
  Widget build(BuildContext context) {
    // 선반이 비어있으면, 빈 선반 표시
    if (widget._onions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // Display 3 shelves
          children: List.generate(
            3,
            (shelfIndex) {
              // Display each shelf
              return SizedBox(
                height: onionMaxHeight,
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
              3,
              (shelfIndex) {
                int onionsPerShelf = 3;
                int firstOnionIndex =
                    pageIndex * onionsPerPage + shelfIndex * onionsPerShelf;
                // 각 선반 1개
                return SizedBox(
                  height: onionMaxHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: onionsPerShelf,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (BuildContext context, int itemIndex) {
                          int globalIndex = firstOnionIndex + itemIndex;
                          if (globalIndex < widget._onions.length) {
                            // 양파 1개 (텍스트 + 이미지) (HomeOneOnion 클래스 사용)
                            return HomeOneOnion(
                              onions: widget._onions,
                              globalIndex: globalIndex,
                              onDelete: () => _deleteOnion(globalIndex),
                            );
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

Future<void> _displayOnionCreateModal(
  BuildContext context,
) async {
  return showDialog(
      context: context,
      builder: (context) {
        return const OnionCreateDialog();
      });
}
