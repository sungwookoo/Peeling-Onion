import './custom_message_model.dart';

// 양파 모델. 이렇게 만들어 쓰는 게 맞나?
class CustomOnion {
  final String name;
  final DateTime createdAt;
  final String sender;
  final List<CustomMessage> messages;

  CustomOnion({
    required this.name,
    required this.createdAt,
    required this.sender,
    required this.messages,
  });
}
