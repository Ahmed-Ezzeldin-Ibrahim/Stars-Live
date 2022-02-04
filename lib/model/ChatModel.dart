class Chat {
  Chat({
    this.status,
    this.data,
    this.msg,
    this.errors,
  });

  String status;
  List<Message> data;
  String msg;
  List<dynamic> errors;

  factory Chat.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Message> itemsList = list.map((i) => Message.fromJson(i)).toList();
    return Chat(
      status: json["status"],
//data: List<Item>.from(json["data"].map((x) => Item.fromJson(x))),
      data: itemsList,
      msg: json["msg"],
//errors: List<dynamic>.from(json["errors"].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "msg": msg,
        "errors": List<dynamic>.from(errors.map((x) => x)),
      };
}

class Message {
  Message({
    this.id,
    this.fromId,
    this.toId,
    this.read,
    this.message,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int fromId;
  int toId;
  int read;
  String message;
  DateTime createdAt;
  DateTime updatedAt;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        fromId: json["from_id"],
        toId: json["to_id"],
        read: json["read"],
        message: json["message"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "from_id": fromId,
        "to_id": toId,
        "read": read,
        "message": message,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
