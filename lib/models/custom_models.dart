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
  final String createdAt;
  final String growDueDate;
  final bool isSingle;
  final String receiverNumber;
  final bool isDead;
  final bool isTime2go;
  final bool isWatered;

  CustomHomeOnion.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        imgSrc = json['img_src'],
        createdAt = json['created_at'],
        growDueDate = json['grow_due_date'],
        isSingle = json['is_single'],
        receiverNumber = json['receiver_number'],
        isDead = json['is_dead'],
        isTime2go = json['is_time2go'],
        isWatered = json['is_watered'];
}

// 메시지 모델
class CustomMessage {
  final int id;
  final String sender;
  final String createdAt;
  final String content;
  final int posRate;
  final int negRate;
  final int neuRate;
  final String fileSrc;

  CustomMessage.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        sender = json['sender'],
        createdAt = json['created_at'],
        content = json['content'],
        posRate = json['pos_rate'],
        negRate = json['neg_rate'],
        neuRate = json['neu_rate'],
        fileSrc = json['file_src'];
}

// 양파 1개 모델 (메시지들은 messageIdList 로 받음. 양파 받 출력할 때 사용)
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
        imgSrc = json['img_src'],
        sender = json['sender'],
        sendDate = json['send_date'],
        growDueDate = json['grow_due_date'],
        isSingle = json['is_single'],
        isBookmarked = json['is_bookmarked'],
        messageIdList =
            List<int>.from(json['message_id_list'] as List<dynamic>);
}

// 택배함 화면에서의 양파 모델 ()
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
  final String name;
  final String imgSrc;
  final String recieveDate;
  final String sender;
  final bool isSingle;

  CustomOnionFromField.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['onion_name'],
        imgSrc = json['img_src'],
        recieveDate = json['receive_date'],
        sender = json['sender'],
        isSingle = json['is_single'];
}

class CustomAlarmField {
  final int senderId;
  final String senderNickname;
  final int receiverId;
  final int alarmType;
  final int alarmId;
  final bool isRead;

  CustomAlarmField.fromJson(Map<String, dynamic> json)
      : senderId = json['sender_id'],
        senderNickname = json['sender_nickname'],
        receiverId = json['receiver_id'],
        alarmType = json['type'],
        alarmId = json['message_id'],
        isRead = json['is_read'];
}
