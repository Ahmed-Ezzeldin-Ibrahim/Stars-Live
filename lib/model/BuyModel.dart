


class BuyInfo {
  String status;
  String msg;

  BuyInfo(
      {
        this.status,
        this.msg,
      }
      );

  factory BuyInfo.fromJson(Map<String, dynamic> json) {
    return BuyInfo(
      status: json["status"],
      msg: json["msg"],
    );
  }


}