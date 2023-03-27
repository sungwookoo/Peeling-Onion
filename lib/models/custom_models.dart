// 양파 공통 모델.

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
  final int id;
  final String name;
  final String imgSrc;
  final String growDueDate;
  final String receiverName;

  CustomHomeOnion.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        imgSrc = json['img_src'],
        growDueDate = json['grow_due_date'],
        receiverName = json['receiver_number'];
}

// 택배함 화면에서의 양파 모델 ()

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

// 양파 1개 모델 (메시지들은 messageIdList 로 받음)
class CustomOnionByOnionId {
  final int id;
  final String name;
  final String imgSrc;
  final String sender;
  final String sendDate;
  final String growDueDate;
  final bool isSingle;
  final bool isBookmarked;
  final List<int> messageIdList;

  CustomOnionByOnionId.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        sender = json['sender'],
        imgSrc = json['img_src'],
        sendDate = json['send_date'],
        growDueDate = json['grow_due_date'],
        isSingle = json['is_single'],
        isBookmarked = json['is_bookmarked'],
        messageIdList =
            List<int>.from(json['message_id_list'] as List<dynamic>);
}

// 밭에 쓰이는 양파 모델
class OnionInfo {
  final int id;
  final String onionName;
  final String imgSrc;
  final String receiveDate;
  final String sender;
  final bool isSingle;

  OnionInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        onionName = json['onion_name'],
        imgSrc = json['img_src'],
        receiveDate = json['receive_date'],
        sender = json['sender'],
        isSingle = json['is_single'];
}

// 밭 모델 (onionInfos 포함)
class CustomField {
  final int id;
  final String name;
  final String createdAt;
  final List<OnionInfo> onionInfos;

  CustomField.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        createdAt = json['created_at'],
        onionInfos = (json['onion_infos'] as List)
            .map((onionInfoJson) => OnionInfo.fromJson(onionInfoJson))
            .toList();
}
