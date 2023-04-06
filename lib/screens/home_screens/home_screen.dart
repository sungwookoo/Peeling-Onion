import 'package:flutter/material.dart';
import 'package:front/widgets/loading_rotation.dart';
// import 'package:front/widgets/onion_create_modal.dart';
import '../onion_create/home_onion_create_screen.dart';
import 'package:front/models/custom_models.dart';
import 'package:front/services/onion_api_service.dart';
import './home_widgets/home_one_onion.dart';
import 'package:front/widgets/on_will_pop.dart';

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

  void updateOnions() {
    try {
      setState(() {
        onions = OnionApiService.getGrowingOnionByUserId();
        // print('됨?');
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: FutureBuilder(
            future: onions,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                List<CustomHomeOnion> onionsData =
                    snapshot.data as List<CustomHomeOnion>;
                // 양파들 출력
                return ShowGrowingOnions(
                    onions: onionsData, onUpdate: () => updateOnions());
              } else if (snapshot.hasError) {
                return Text('에러: ${snapshot.error}');
              }
              // 로딩 화면
              // return const CircularProgressIndicator();
              return const CustomLoadingWidget(
                  imagePath: 'assets/images/onion_image.png');
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    insetPadding: EdgeInsets.zero,
                    content: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            child: const Image(
                              image:
                                  AssetImage('assets/images/createAlone.png'),
                              width: 120,
                              height: 120,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const OnionCreate(
                                                  isTogether: false)))
                                  .then((value) => updateOnions());
                            },
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            child: const Image(
                              image: AssetImage(
                                  'assets/images/createTogether.png'),
                              width: 120,
                              height: 120,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const OnionCreate(
                                                  isTogether: true)))
                                  .then((value) => updateOnions());
                            },
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
        // bottomNavigationBar: const NavigateBar(),
      ),
    );
  }
}

// 양파들을 격자로 표시 (페이지 뷰 사용)
class ShowGrowingOnions extends StatefulWidget {
  final List<CustomHomeOnion> _onions;
  final VoidCallback onUpdate;
  const ShowGrowingOnions({
    super.key,
    required List<CustomHomeOnion> onions,
    required this.onUpdate,
  }) : _onions = onions;

  @override
  State<ShowGrowingOnions> createState() => _ShowGrowingOnionsState();
}

class _ShowGrowingOnionsState extends State<ShowGrowingOnions> {
  late final List<CustomHomeOnion> _onions = widget._onions;

  void _deleteOnion(int index) {
    setState(() {
      _onions.removeAt(index);
    });
  }

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
        padding: EdgeInsets.fromLTRB(0, AppBar().preferredSize.height, 0, 0),
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
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/wall_paper.jpg'),
            fit: BoxFit.fill),
      ),
      padding: EdgeInsets.fromLTRB(0, AppBar().preferredSize.height, 0, 0),
      // 양파 페이지
      child: PageView.builder(
        itemCount: numOfPages,
        itemBuilder: (context, pageIndex) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(
                shelvesPerPage,
                (shelfIndex) {
                  int firstOnionIndex =
                      pageIndex * onionsPerPage + shelfIndex * onionsPerShelf;
                  // 양파 1개 출력
                  return Expanded(
                    // 양파 크기 조절
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        double columnHeight =
                            constraints.maxHeight; // Column의 높이 구하기
                        double columnWidth = constraints.maxWidth; //
                        double a = columnWidth / 2;
                        double b = (columnHeight -
                            (MediaQuery.of(context).size.width - 16) *
                                (64.9 / 395.4));
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GridView.builder(
                              padding: EdgeInsets.zero, // set padding to zero
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: onionsPerShelf,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: onionsPerShelf,
                                childAspectRatio: a / b,
                              ),
                              itemBuilder:
                                  (BuildContext context, int itemIndex) {
                                int globalIndex = firstOnionIndex + itemIndex;
                                if (globalIndex < widget._onions.length) {
                                  // 양파 1개
                                  return HomeOneOnion(
                                      onion:
                                          widget._onions.elementAt(globalIndex),
                                      onDelete: () => _deleteOnion(globalIndex),
                                      onUpdate: widget.onUpdate);
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                            // 선반 그림
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset('assets/images/shelf.png'),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// Future<void> _displayOnionCreateModal(
//   BuildContext context,
// ) async {
//   return showDialog(
//       context: context,
//       builder: (context) {
//         return const OnionCreateDialog();
//       });
// }
