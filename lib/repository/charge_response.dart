import 'dart:convert';

ChargeResponse chargeResponseFromJson(String str) => ChargeResponse.fromJson(json.decode(str));

String chargeResponseToJson(ChargeResponse data) => json.encode(data.toJson());

class ChargeResponse {
  ChargeResponse({
    this.status,
    this.msg,
  });

  final String status;
  final String msg;

  factory ChargeResponse.fromJson(Map<String, dynamic> json) => ChargeResponse(
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
      };
}
