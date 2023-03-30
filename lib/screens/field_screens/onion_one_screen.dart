import 'package:flutter/material.dart';
import 'package:front/models/custom_models.dart';
import 'package:front/services/onion_api_service.dart';

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
    return const Scaffold(
      // 가능하면 다른 화면으로 넘어갈 수 있는 사이드바 같은 것도 추가
      body: Row(
        children: [
          // OnionWithMessage(onionId: widget.onionId),
        ],
      ),
    );
  }
}
