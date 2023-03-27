// 양파 모델. 이렇게 만들어 쓰는 게 맞나?

class CustomOnion {
  final int id;
  final String name;
  final String sender;
  final List<CustomMessage> messages;

  CustomOnion.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['onion_name'],
        sender = json['sender'],
        messages = (json['messages'] as List)
            .map((messageJson) => CustomMessage.fromJson(messageJson))
            .toList();
}

// 홈 화면에서의 양파 모델 (상세 메시지는 안받음)
class CustomHomeOnion {
  final int onionId;
  final String onionName;
  final String imgSrc;
  final int sendDate;
  final String mobileNumber;

  CustomHomeOnion.fromJson(Map<String, dynamic> json)
      : onionId = json['onion_id'],
        onionName = json['onion_name'],
        imgSrc = json['img_src'],
        sendDate = json['send_date'],
        mobileNumber = json['mobile_number'];
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
