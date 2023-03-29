import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import 'package:front/services/onion_api_service.dart';
import 'package:front/screens/postbox_screens/postbox_widgets/show_growing_onions.dart';
import '../../widgets/trash_can.dart';

class PackageScreen extends StatefulWidget {
  // 우선 user id 하는 식. 이후 토큰으로 api 변경될 예정
  final int id = 1;
  const PackageScreen({super.key});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  // 받아온 기르는 양파 정보들 (우선 홈 화면 api 연결.)
  // 나중에 택배함 api 완성되면 연결
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
              return Stack(
                children: [
                  // ShowGrowingOnions 클래스 사용
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
    );
  }
}
