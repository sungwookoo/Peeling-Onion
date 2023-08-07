import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import 'package:front/services/onion_api_service.dart';
import 'package:front/widgets/onion_with_message.dart';
import '../../widgets/loading_rotation.dart';

// 양파 밭에서 클릭하면 나오는 양파 1개 화면
class OnionOneScreen extends StatefulWidget {
  final int onionId;

  const OnionOneScreen({super.key, required this.onionId});

  @override
  State<OnionOneScreen> createState() => _OnionOneScreenState();
}

class _OnionOneScreenState extends State<OnionOneScreen> {
  late Future<CustomOnionByOnionId> onion;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onion = OnionApiService.getOnionById(widget.onionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 가능하면 다른 화면으로 넘어갈 수 있는 사이드바 같은 것도 추가
      body: Center(
        child: Container(
          // 배경화면
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/wall_paper.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          // 양파 출력
          child: FutureBuilder(
            future: onion,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                CustomOnionByOnionId onion =
                    snapshot.data as CustomOnionByOnionId;
                // 양파 1개 화면 공통으로 사용 (OnionWithMessage 클래스)
                return Column(
                  children: [
                    OnionWithMessage(
                      onion: onion,
                      messageIndex: 0,
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Text('에러');
              } else {
                return const CustomLoadingWidget(
                    imagePath: 'assets/images/onion_image.png');
              }
            },
          ),
        ),
      ),
    );
  }
}
