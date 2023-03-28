import 'package:flutter/material.dart';
import 'package:front/widgets/onion_create_modal.dart';
import 'package:front/models/custom_models.dart';
import 'package:front/services/onion_api_service.dart';
import '../../widgets/trash_can.dart';

class HomeScreen extends StatefulWidget {
  final int id = 1;
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
    onions = OnionApiService.getGrowingOnionByUserId(widget.id);
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
              return Stack(
                children: [
                  ShowGrowingOnions(onions: onionsData),
                  const TrashCan(kind: 'onion'),
                ],
              );
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

// 양파들을 격자로 표시할 예정
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
                        // mainAxisSpacing: 10,
                        // crossAxisSpacing: 10,
                      ),
                      itemBuilder: (BuildContext context, int itemIndex) {
                        int globalIndex = firstOnionIndex + itemIndex;
                        if (globalIndex < widget._onions.length) {
                          // 각 양파 1개 (텍스트 + 이미지)
                          return OneOnion(
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
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// 양파 1개 (이후 이곳의 onTap 속성에, 혜빈누나 작업물 붙일 예정)
class OneOnion extends StatelessWidget {
  const OneOnion({
    super.key,
    required List<CustomHomeOnion> onions,
    required this.globalIndex,
    required this.onDelete,
  }) : _onions = onions;

  final List<CustomHomeOnion> _onions;
  final int globalIndex;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _showDeleteModal(context, _onions.elementAt(globalIndex), onDelete);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_onions.elementAt(globalIndex).name),
          Image.asset('assets/images/onion_image.png'),
        ],
      ),
    );
  }
}

// 양파 delete 모달창 띄우는 함수
Future<void> _showDeleteModal(
    BuildContext context, CustomHomeOnion onion, VoidCallback onDelete) async {
  final RenderBox box = context.findRenderObject() as RenderBox;
  final Offset position = box.localToGlobal(Offset.zero);
  final Size size = box.size;

  return showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy + size.height,
      position.dx + size.width,
      position.dy,
    ),
    items: [
      PopupMenuItem(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Delete Onion'),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // TODO: Implement the delete functionality

                OnionApiService.deleteOnionById(onion.id);
                onDelete();

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    ],
  );
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
