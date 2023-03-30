// 양파 공통 모델.

class CustomOnion {
  final int id;
  final String name;
  final String sender;

  CustomOnion.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['onion_name'],
        sender = json['sender'];
}

// 홈 화면에서의 양파 모델 (상세 메시지는 안받음)
class CustomHomeOnion {
  final int id;
  final String name;
  final String imgSrc;
  final String growDueDate;
  final String receiverNumber;

  CustomHomeOnion.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        imgSrc = json['img_src'],
        growDueDate = json['grow_due_date'],
        receiverNumber = json['receiver_number'];
}

// 택배함 화면에서의 양파 모델 ()

// 메시지 모델
class CustomMessage {
  final int id;
  final String sender;
  final String createdAt;
  final String content;
  final double posRate;
  final double negRate;
  final String fileSrc;

  CustomMessage.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        sender = json['sender'],
        createdAt = json['created_at'],
        content = json['content'],
        posRate = json['pos_rate'],
        negRate = json['neg_rate'],
        fileSrc = json['file_src'];
}

// 양파 1개 모델 (메시지들은 messageIdList 로 받음)
class CustomOnionByOnionId {
  final int id;
  final String name;
  final String imgSrc;
  final String sender;
  final String? sendDate;
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

class CustomOnionByOnionIdPostbox {
  final int id;
  final String name;
  final String imgSrc;
  final String sender;
  final String? receiveDate;
  final String growDueDate;
  final bool isSingle;

  CustomOnionByOnionIdPostbox.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        sender = json['sender'],
        imgSrc = json['img_src'],
        receiveDate = json['receive_date'],
        growDueDate = json['grow_due_date'],
        isSingle = json['is_single'];
}

// 전체 밭 모델
class CustomField {
  final int id;
  final String name;
  final String createdAt;
  CustomField({required this.id, required this.name, required this.createdAt});

  CustomField.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        createdAt = json['created_at'];

  CustomField copyWith({int? id, String? name, String? createdAt}) {
    return CustomField(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// 밭 1개의 양파 정보 모델
class CustomOnionFromField {
  final int id;
  final String onionName;
  final String imgSrc;
  final String recieveDate;
  final String sender;
  final bool isSingle;

  CustomOnionFromField.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        onionName = json['name'],
        imgSrc = json['img_src'],
        recieveDate = json['recieve_date'],
        sender = json['sender'],
        isSingle = json['is_single'];
}
