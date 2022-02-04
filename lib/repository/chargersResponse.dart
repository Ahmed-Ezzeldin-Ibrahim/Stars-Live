// To parse this JSON data, do
//
//     final chargersResponse = chargersResponseFromJson(jsonString);

import 'dart:convert';

ChargersResponse chargersResponseFromJson(String str) => ChargersResponse.fromJson(json.decode(str));

String chargersResponseToJson(ChargersResponse data) => json.encode(data.toJson());

class ChargersResponse {
    ChargersResponse({
        this.status,
        this.data,
        this.msg,
    });

    final String status;
    final List<SingleCharger> data;
    final String msg;

    factory ChargersResponse.fromJson(Map<String, dynamic> json) => ChargersResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : List<SingleCharger>.from(json["data"].map((x) => SingleCharger.fromJson(x))),
        msg: json["msg"] == null ? null : json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
        "msg": msg == null ? null : msg,
    };
}

class SingleCharger {
    SingleCharger({
        this.name,
        this.whats,
        this.avatar,
    });

    final String name;
    final String whats;
    final String avatar;

    factory SingleCharger.fromJson(Map<String, dynamic> json) => SingleCharger(
        name: json["name"] == null ? null : json["name"],
        whats: json["whats"] == null ? null : json["whats"],
        avatar: json["avatar"] == null ? null : json["avatar"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "whats": whats == null ? null : whats,
        "avatar": avatar == null ? null : avatar,
    };
}
