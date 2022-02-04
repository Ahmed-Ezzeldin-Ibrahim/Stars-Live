// To parse this JSON data, do
//
//     final profileResponse = profileResponseFromJson(jsonString);

import 'dart:convert';

import 'package:starslive/model/User.dart';

ProfileResponse profileResponseFromJson(String str) => ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) => json.encode(data.toJson());

class ProfileResponse {
  ProfileResponse({
    this.status,
    this.data,
    this.msg,
    this.errors,
  });

  final String status;
  final List<Profile> data;
  final String msg;
  final List<dynamic> errors;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : List<Profile>.from(json["data"].map((x) => Profile.fromJson(x))),
        msg: json["msg"] == null ? null : json["msg"],
        errors: json["errors"] == null ? null : List<dynamic>.from(json["errors"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
        "msg": msg == null ? null : msg,
        "errors": errors == null ? null : List<dynamic>.from(errors.map((x) => x)),
      };
}

class Profile {
  Profile({
    this.id,
    this.type,
    this.name,
    this.email,
    this.phone,
    this.salary,
    this.balanceInCoins,
    this.diamonds,
    this.totalReceivedGifts,
    this.isOnline,
    this.isLive,
    this.image,
    this.followed,
    this.levelHost,
    this.levelUser,
    this.apiToken,
    this.followers,
    this.followeds,
    this.shift_transferred_usd,
  });

  final int id;
  final String type;
  final String name;
  final String email;
  final String phone;
  final double salary;
  int balanceInCoins;
  String shift_transferred_usd;
  final int diamonds;
  final int totalReceivedGifts;
  final int isOnline;
  final int isLive;
  final String image;
  final String followed;
  final Level levelHost;
  final Level levelUser;
  final String apiToken;
  final List<Profile> followers;
  final List<Profile> followeds;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        phone: json["phone"] == null ? null : json["phone"],
        salary: json["salary"] == null ? 0 : json["salary"].toDouble(),
        balanceInCoins: json["balance_in_coins"] == null ? 0 : int.parse('${json["balance_in_coins"]}'),
        shift_transferred_usd: json["shift_transferred_usd"] == null ? '0.0' : '${json["shift_transferred_usd"]}',
        diamonds: json["diamonds"] == null ? 0 : json["diamonds"],
        totalReceivedGifts: json["total_received_gifts"] == null ? 0 : json["total_received_gifts"],
        isOnline: json["is_online"] == null ? null : int.parse('${json["is_online"]}'),
        isLive: json["is_live"] == null ? null : int.parse('${json["is_live"]}'),
        image: json["image"] == null ? null : json["image"],
        followed: json["followed"] == null ? null : json["followed"],
        levelHost: json["level_host"] == null ? null : Level.fromJson(json["level_host"]),
        levelUser: json["level_user"] == null ? null : Level.fromJson(json["level_user"]),
        apiToken: json["api_token"] == null ? null : json["api_token"],
        followers: json["followers"] == null ? null : List<Profile>.from(json["followers"].map((x) => Profile.fromJson(x))),
        followeds: json["followeds"] == null ? null : List<Profile>.from(json["followeds"].map((x) => Profile.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "phone": phone == null ? null : phone,
        "salary": salary == null ? null : salary,
        "balance_in_coins": balanceInCoins == null ? null : balanceInCoins,
        "diamonds": diamonds == null ? null : diamonds,
        "total_received_gifts": totalReceivedGifts == null ? null : totalReceivedGifts,
        "is_online": isOnline == null ? null : isOnline,
        "is_live": isLive == null ? null : isLive,
        "image": image == null ? null : image,
        "followed": followed == null ? null : followed,
        "level_host": levelHost == null ? null : levelHost.toJson(),
        "level_user": levelUser == null ? null : levelUser.toJson(),
        "api_token": apiToken == null ? null : apiToken,
        "followers": followers == null ? null : List<dynamic>.from(followers.map((x) => x.toJson())),
        "followeds": followeds == null ? null : List<dynamic>.from(followeds.map((x) => x.toJson())),
      };
}
