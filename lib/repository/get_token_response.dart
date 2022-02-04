// To parse this JSON data, do
//
//     final getTokenResponse = getTokenResponseFromJson(jsonString);

import 'dart:convert';

GetTokenResponse getTokenResponseFromJson(String str) => GetTokenResponse.fromJson(json.decode(str));

String getTokenResponseToJson(GetTokenResponse data) => json.encode(data.toJson());

class GetTokenResponse {
    GetTokenResponse({
        this.status,
        this.data,
        this.msg,
    });

    final String status;
    final Data data;
    final String msg;

    factory GetTokenResponse.fromJson(Map<String, dynamic> json) => GetTokenResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        msg: json["msg"] == null ? null : json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : data.toJson(),
        "msg": msg == null ? null : msg,
    };
}

class Data {
    Data({
        this.liveToken,
    });

    final String liveToken;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        liveToken: json["live_token"] == null ? null : json["live_token"],
    );

    Map<String, dynamic> toJson() => {
        "live_token": liveToken == null ? null : liveToken,
    };
}
