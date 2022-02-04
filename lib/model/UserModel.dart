// To parse this JSON data, do
//
//     final userChatModel = userChatModelFromMap(jsonString);

import 'dart:convert';

class UserChatModel {
  UserChatModel({
    this.id,
    this.name,
    this.image,
    this.lastMessage,
    this.type,
    this.createdAt,
    this.messageTime,
    this.chattingWith,
    this.unreadMessages
  });

  final String id;
  String name;
  String image;
  String lastMessage;
  final int type;
  final DateTime createdAt;
  DateTime messageTime;
  List<String> chattingWith;
  int unreadMessages;

  factory UserChatModel.fromJson(String str) => UserChatModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserChatModel.fromMap(Map<String, dynamic> json) => UserChatModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"],
    lastMessage: json["lastMessage"] == null ? null : json["lastMessage"],
    unreadMessages: json["unreadMessages"] == null ? 0 : json["unreadMessages"],
    type: json["type"] == null ? null : json["type"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    messageTime: json["messageTime"] == null ? null : DateTime.fromMicrosecondsSinceEpoch(json["messageTime"]),
    chattingWith: json["chattingWith"] == null ? [] : List<String>.from(json["chattingWith"].map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "image": image == null ? null : image,
    "lastMessage": lastMessage == null ? null : lastMessage,
    "unreadMessages": unreadMessages == null ? 0 : unreadMessages,
    "type": type == null ? null : type,
    "createdAt": createdAt == null ? null : "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
    "messageTime": messageTime == null ? null : "${messageTime.year.toString().padLeft(4, '0')}-${messageTime.month.toString().padLeft(2, '0')}-${messageTime.day.toString().padLeft(2, '0')}",
    "chattingWith": chattingWith == null ? [] : List<dynamic>.from(chattingWith.map((x) => x)),
  };

  static messageTimeNowMap(){
    return {"messageTime":DateTime.now().microsecondsSinceEpoch};
  }
}
