import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import 'package:front/services/onion_api_service.dart';
import 'package:front/screens/postbox_screens/postbox_widgets/show_posted_onions.dart';

class PackageScreen extends StatefulWidget {
  const PackageScreen({super.key});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  // 택배함의 양파들 정보
  late Future<List<CustomOnionByOnionIdPostbox>> onions;

  @override
  void initState() {
    super.initState();
    onions = OnionApiService.getPostboxOnion();
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
              List<CustomOnionByOnionIdPostbox> onionsData =
                  snapshot.data as List<CustomOnionByOnionIdPostbox>;
              // 양파들 출력
              return Stack(
                children: [
                  // ShowPostedOnions 클래스 사용
                  ShowPostedOnions(onions: onionsData),
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
