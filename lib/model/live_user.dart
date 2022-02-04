// To parse this JSON data, do
//
//     final liveRoomsResponse = liveRoomsResponseFromJson(jsonString);

import 'dart:convert';

LiveRoomsResponse liveRoomsResponseFromJson(String str) => LiveRoomsResponse.fromJson(json.decode(str));

String liveRoomsResponseToJson(LiveRoomsResponse data) => json.encode(data.toJson());

class LiveRoomsResponse {
  LiveRoomsResponse({
    this.status,
    this.data,
    this.msg,
  });

  final String status;
  final List<LiveUserData> data;
  final String msg;

  factory LiveRoomsResponse.fromJson(Map<String, dynamic> json) => LiveRoomsResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : List<LiveUserData>.from(json["data"].map((x) => LiveUserData.fromJson(x))),
        msg: json["msg"] == null ? null : json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
        "msg": msg == null ? null : msg,
      };
}

class LiveUserData {
  LiveUserData({
    this.id,
    this.type,
    this.name,
    this.isOnline,
    this.isLive,
    this.image,
    this.followed,
    this.levelHost,
    this.levelUser,
    this.followers,
    this.followeds,
  });

  final int id;
  final String type;
  final String name;
  final int isOnline;
  final int isLive;
  final String image;
  final String followed;
  final Level levelHost;
  final Level levelUser;
  final List<dynamic> followers;
  final List<dynamic> followeds;

  factory LiveUserData.fromJson(Map<String, dynamic> json) => LiveUserData(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        name: json["name"] == null ? null : json["name"],
        isOnline: json["is_online"] == null ? null : int.parse(json["is_online"]),
        isLive: json["is_live"] == null ? null : int.parse('${json["is_live"]}'),
        image: json["image"] == null ? null : json["image"],
        followed: json["followed"] == null ? null : json["followed"],
        levelHost: json["level_host"] == null ? null : Level.fromJson(json["level_host"]),
        levelUser: json["level_user"] == null ? null : Level.fromJson(json["level_user"]),
        followers: json["followers"] == null ? null : List<dynamic>.from(json["followers"].map((x) => x)),
        followeds: json["followeds"] == null ? null : List<dynamic>.from(json["followeds"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "name": name == null ? null : name,
        "is_online": isOnline == null ? null : isOnline,
        "is_live": isLive == null ? null : isLive,
        "image": image == null ? null : image,
        "followed": followed == null ? null : followed,
        "level_host": levelHost == null ? null : levelHost.toJson(),
        "level_user": levelUser == null ? null : levelUser.toJson(),
        "followers": followers == null ? null : List<dynamic>.from(followers.map((x) => x)),
        "followeds": followeds == null ? null : List<dynamic>.from(followeds.map((x) => x)),
      };
}

class Level {
  Level({
    this.level,
    this.previous,
    this.current,
    this.next,
    this.remaining,
    this.value,
  });

  final int level;
  final double previous;
  final double current;
  final double next;
  final double remaining;
  final double value;

  factory Level.fromJson(Map<String, dynamic> json) => Level(
        level: json["level"] == null ? null : json["level"],
        previous: json["previous"] == null ? null : json["previous"].toDouble(),
        current: json["current"] == null ? null : json["current"].toDouble(),
        next: json["next"] == null ? null : json["next"].toDouble(),
        remaining: json["remaining"] == null ? null : json["remaining"].toDouble(),
        value: json["value"] == null ? null : json["value"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "level": level == null ? null : level,
        "previous": previous == null ? null : previous,
        "current": current == null ? null : current,
        "next": next == null ? null : next,
        "remaining": remaining == null ? null : remaining,
        "value": value == null ? null : value,
      };
}
