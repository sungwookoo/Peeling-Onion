// 양파 모델. 이렇게 만들어 쓰는 게 맞나?
class CustomOnion {
  final String name;
  final String sender;
  final List<CustomMessage> messages;

  CustomOnion.fromJson(Map<String, dynamic> json)
      : name = json['onion_name'],
        sender = json['sender'],
        messages = (json['messages'] as List)
            .map((messageJson) => CustomMessage.fromJson(messageJson))
            .toList();
}

// 메시지 모델
class CustomMessage {
  final int id;
  final int senderId;
  final String url;

  CustomMessage.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        senderId = json['user_id'],
        url = json['file_src'];
}

// 밭 모델
class CustomField {
  final int id;
  final String name;
  final List<CustomOnion> onions;

  CustomField.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        onions = (json['onions'] as List)
            .map((onionJson) => CustomOnion.fromJson(onionJson))
            .toList();
}
