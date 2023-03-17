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

// 메시지 모델
class CustomMessage {
  final String sender;
  final DateTime createdAt;
  final String url;

  CustomMessage({
    required this.sender,
    required this.createdAt,
    required this.url,
  });
}

// 밭 모델
class CustomField {
  final int id;
  final String name;
  final DateTime createdAt;
  final List<CustomOnion> onions;

  CustomField({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.onions,
  });
}
