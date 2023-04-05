import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import 'package:front/services/onion_api_service.dart';
import 'package:front/widgets/onion_with_message.dart';
import '../../widgets/loading_rotation.dart';

// 양파 밭에서 클릭하면 나오는 양파 1개 화면 (첫 번째 메시지 화면으로 이동)
class OnionOneScreen extends StatefulWidget {
  final int onionId;

  const OnionOneScreen({super.key, required this.onionId});

  @override
  State<OnionOneScreen> createState() => _OnionOneScreenState();
}

class _OnionOneScreenState extends State<OnionOneScreen> {
  int messageIndex = 0;
  late Future<CustomOnionByOnionId> onion;

  @override
  void initState() {
    super.initState();
    onion = OnionApiService.getOnionById(widget.onionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<CustomOnionByOnionId>(
        future: onion,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              children: [
                OnionWithMessage(
                    onion: snapshot.data!, messageIndex: messageIndex),
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load onion'),
            );
          } else {
            return const Center(
              child: CustomLoadingWidget(
                  imagePath: 'assets/images/onion_image.png'),
            );
          }
        },
      ),
    );
  }
}
