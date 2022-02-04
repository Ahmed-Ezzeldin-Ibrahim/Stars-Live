class Gifts {
  Gifts({
    this.status,
    this.data,
    this.msg,
    this.errors,
  });

  String status;
  List<GiftsData> data;
  String msg;
  List<dynamic> errors;

  factory Gifts.fromJson(Map<String, dynamic> json) => Gifts(
        status: json["status"],
        data: List<GiftsData>.from(json["data"].map((x) => GiftsData.fromJson(x))),
        msg: json["msg"],
        errors: List<dynamic>.from(json["errors"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "msg": msg,
        "errors": List<dynamic>.from(errors.map((x) => x)),
      };
}

class GiftsData {
  GiftsData({
    this.id,
    this.name,
    this.title,
    this.description,
    this.image,
    this.videoLink,
    this.valueInCoins,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String title;
  String description;
  String image;
  String videoLink;
  int valueInCoins;
  DateTime createdAt;
  DateTime updatedAt;

  factory GiftsData.fromJson(Map<String, dynamic> json) => GiftsData(
        id: json["id"],
        name: json["name"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        image: json["image"] == null ? null : json["image"],
        videoLink: json["video_link"] == null ? null : json["video_link"],
        valueInCoins: json["value_in_coins"] == null ? null : int.parse('${json["value_in_coins"]}'),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "image": image == null ? null : image,
        "video_link": videoLink == null ? null : videoLink,
        "value_in_coins": valueInCoins,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
