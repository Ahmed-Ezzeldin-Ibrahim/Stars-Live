// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class UserData {}

class User {
  User({
    this.id,
    this.type,
    this.name,
    this.email,
    this.phone,
    this.country,
    this.image,
    this.diamonds,
    this.gender,
    this.followed,
    this.salary,
    this.balanceInCoins,
    this.shift_transferred_usd,
    this.giftsBalance,
    this.totalReceivedGifts,
    this.apiToken,
    this.createdAt,
    this.updatedAt,
    this.followers,
    this.followeds,
    this.userHostLevel,
    this.userLevel,
  });

  String name;
  String image;
  String email;
  int diamonds;
  String google_id;
  String phone;
  String password;
  String gender;
  String country;
  double latitude;
  double longitude;
  DateTime updatedAt;
  DateTime createdAt;
  int id;
  bool auth;
  File file;
  String apiToken;
  String deviceToken;
  String isFollowed;
  List<Follower> followers = [];
  List<Follower> followeds = [];
  String type;
  String followed;
  Level userLevel;
  Level userHostLevel;
  double salary;
  int balanceInCoins;
  String shift_transferred_usd;
  int giftsBalance;
  int totalReceivedGifts;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] == null ? 1 : json["id"],
        type: json["type"] == null ? '' : json["type"],
        name: json["name"] == null ? '' : json["name"],
        email: json["email"] == null ? '' : json["email"],
        phone: json["phone"] == null ? '' : json["phone"],
        country: json["country"] == null ? '' : json["country"],
        image: json["image"] == null ? '' : json["image"],
        diamonds: json["diamonds"] == null ? 0 : json["diamonds"],
        gender: json["gender"] == null ? '' : json["gender"],
        followed: json["followed"] == null ? '' : json["followed"],
        salary: json["salary"] == null ? 0 : json["salary"].toDouble(),
        balanceInCoins: json["balance_in_coins"] == null ? 0 : int.parse('${json["balance_in_coins"]}'),
        shift_transferred_usd: json["shift_transferred_usd"] == null ? '0.0' : '${json["shift_transferred_usd"]}',
        giftsBalance: json["gifts_balance"] == null ? 0 : json["gifts_balance"],
        totalReceivedGifts: json["total_received_gifts"] == null ? 0 : json["total_received_gifts"],
        apiToken: json["api_token"] == null ? '' : json["api_token"],
        userLevel: Level.fromJson(json["level_user"]) == null ? Level(level: 1) : Level.fromJson(json["level_user"]),
        userHostLevel: Level.fromJson(json["level_host"]) == null ? Level(level: 1) : Level.fromJson(json["level_host"]),
        followers: json["followers"] != null ? List<Follower>.from(json["followers"].map((x) => Follower.fromJson(x))) : null,
        followeds: json["followeds"] != null ? List<Follower>.from(json["followeds"].map((x) => Follower.fromJson(x))) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "name": name,
        "email": email,
        "phone": phone,
        "country": country,
        "image": image,
        "gender": gender,
        "followed": followed,
        "level_user": userLevel.toJson(),
        "level_host": userHostLevel.toJson(),
        "salary": salary,
        "balance_in_coins": balanceInCoins,
        "gifts_balance": giftsBalance,
        "total_received_gifts": totalReceivedGifts,
        "api_token": apiToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "followers": List<dynamic>.from(followers.map((x) => x.toJson())),
        "followeds": List<dynamic>.from(followeds.map((x) => x)),
      };
}

class Follower {
  Follower({
    this.id,
    this.roleId,
    this.agancyId,
    this.name,
    this.blocked,
    this.gender,
    this.country,
    this.email,
    this.phone,
    this.facebookId,
    this.googleId,
    this.avatar,
    this.idImage,
    this.emailVerifiedAt,
    this.deviceToken,
    this.settings,
    this.currentUsd,
    this.currentCoins,
    this.currentGifts,
    this.totalReceivedCoins,
    this.latitude,
    this.longitude,
    this.isOnline,
    this.isLive,
    this.liveType,
    this.liveToken,
    this.rtmToken,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.type,
    this.followed,
    this.whatsApp,
    this.diamonds,
    this.salary,
    this.agencyAmount,
    this.shiftTrxsAmount,
    this.levelHost,
    this.levelUser,
    this.banedFromWriting,
    this.banedFromBroadcasting,
    this.pivot,
    this.roles,
    this.scores,
  });

  int id;
  int roleId;
  dynamic agancyId;
  String name;
  int blocked;
  String gender;
  String country;
  String email;
  String phone;
  dynamic facebookId;
  dynamic googleId;
  String avatar;
  dynamic idImage;
  dynamic emailVerifiedAt;
  dynamic deviceToken;
  List<dynamic> settings;
  int currentUsd;
  int currentCoins;
  int currentGifts;
  int totalReceivedCoins;
  String latitude;
  String longitude;
  int isOnline;
  int isLive;
  dynamic liveType;
  dynamic liveToken;
  dynamic rtmToken;
  DateTime createdAt;
  DateTime updatedAt;
  String image;
  String type;
  String followed;
  dynamic whatsApp;
  int diamonds;
  double salary;
  String agencyAmount;
  String shiftTrxsAmount;
  Level levelHost;
  Level levelUser;
  bool banedFromWriting;
  bool banedFromBroadcasting;
  Pivot pivot;

  List<dynamic> roles;
  List<dynamic> scores;

  factory Follower.fromJson(Map<String, dynamic> json) => Follower(
        id: json["id"],
        roleId: json["role_id"],
        agancyId: json["agancy_id"],
        name: json["name"],
        blocked: json["blocked"],
        gender: json["gender"],
        country: json["country"],
        email: json["email"],
        phone: json["phone"],
        facebookId: json["facebook_id"],
        googleId: json["google_id"],
        avatar: json["avatar"],
        idImage: json["id_image"],
        emailVerifiedAt: json["email_verified_at"],
        deviceToken: json["device_token"],
        // settings: List<dynamic>.from(json["settings"].map((x) => x)),
        currentUsd: json["current_usd"],
        currentCoins: json["current_coins"],
        currentGifts: json["current_gifts"],
        totalReceivedCoins: json["total_received_coins"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        isOnline: json["is_online"] == null ? null : int.parse(json["is_online"]),
        isLive: json["is_live"] == null ? null : int.parse('${json["is_live"]}'),
        liveType: json["live_type"],
        liveToken: json["live_token"],
        rtmToken: json["rtm_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        image: json["image"],
        type: json["type"],
        followed: json["followed"],
        whatsApp: json["whats_app"],
        diamonds: json["diamonds"],
        salary: json["salary"].toDouble(),
        /*agencyAmount: json["agency_amount"],*/
        shiftTrxsAmount: json["shift_trxs_amount"],
        levelHost: Level.fromJson(json["level_host"]),
        levelUser: Level.fromJson(json["level_user"]),
        banedFromWriting: json["baned_from_writing"],
        banedFromBroadcasting: json["baned_from_broadcasting"],
        pivot: Pivot.fromJson(json["pivot"]),
        roles: List<dynamic>.from(json["roles"].map((x) => x)),
        scores: List<dynamic>.from(json["scores"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role_id": roleId,
        "agancy_id": agancyId,
        "name": name,
        "blocked": blocked,
        "gender": gender,
        "country": country,
        "email": email,
        "phone": phone,
        "facebook_id": facebookId,
        "google_id": googleId,
        "avatar": avatar,
        "id_image": idImage,
        "email_verified_at": emailVerifiedAt,
        "device_token": deviceToken,
        "settings": List<dynamic>.from(settings.map((x) => x)),
        "current_usd": currentUsd,
        "current_coins": currentCoins,
        "current_gifts": currentGifts,
        "total_received_coins": totalReceivedCoins,
        "latitude": latitude,
        "longitude": longitude,
        "is_online": isOnline,
        "is_live": isLive,
        "live_type": liveType,
        "live_token": liveToken,
        "rtm_token": rtmToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "image": image,
        "type": type,
        "followed": followed,
        "whats_app": whatsApp,
        "diamonds": diamonds,
        "salary": salary,
        "agency_amount": agencyAmount,
        "shift_trxs_amount": shiftTrxsAmount,
        "level_host": levelHost.toJson(),
        "level_user": levelUser.toJson(),
        "baned_from_writing": banedFromWriting,
        "baned_from_broadcasting": banedFromBroadcasting,
        "pivot": pivot.toJson(),
        "roles": List<dynamic>.from(roles.map((x) => x)),
        "scores": List<dynamic>.from(scores.map((x) => x)),
      };
}

class Pivot {
  Pivot({
    this.followedId,
    this.followerId,
  });

  int followedId;
  int followerId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        followedId: json["followed_id"],
        followerId: json["follower_id"],
      );

  Map<String, dynamic> toJson() => {
        "followed_id": followedId,
        "follower_id": followerId,
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
