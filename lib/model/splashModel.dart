
/*

class BannerModel {
  BannerModel({
    this.status,
    this.data,
    this.msg,
    this.errors,
  });

  String status;
  List<Datum> data;
  String msg;
  List<dynamic> errors;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
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

class Datum {
  Datum({
    this.id,
    this.name,
    this.title,
    this.description,
    this.status,
    this.type,
    this.place,
    this.duration,
    this.ordering,
    this.image,
    this.video,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String title;
  String description;
  String status;
  String type;
  String place;
  int duration;
  int ordering;
  String image;
  dynamic video;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        title: json["title"],
        description: json["description"],
        status: json["status"],
        type: json["type"],
        place: json["place"],
        duration: json["duration"],
        ordering: json["ordering"] == null ? null : json["ordering"],
        image: json["image"],
        video: json["video"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "title": title,
        "description": description,
        "status": status,
        "type": type,
        "place": place,
        "duration": duration,
        "ordering": ordering == null ? null : ordering,
        "image": image,
        "video": video,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
*/


class splash {
  String status;
  List<Item>data;
  String msg;
  List<dynamic> errors;

  splash(
      {
        this.status,
        this.data,
        this.msg,
        this.errors,
      }
      );

  factory splash.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Item> itemsList = list.map((i) => Item.fromJson(i)).toList();
    return splash(
      status: json["status"],
      //data: List<Item>.from(json["data"].map((x) => Item.fromJson(x))),
      data: itemsList,
      msg: json["msg"],
      //errors: List<dynamic>.from(json["errors"].map((x) => x)),
    );
  }


}
class Item {
  Item({
    this.id,
    this.name,
    this.title,
    this.description,
    this.type,
    this.image,
    this.status,
    this.duration,
    this.ordering,
    this.video,
    this.place,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String title;
  String description;
  String type;
  String place;
  String status;
  int duration;
  int ordering;
  String image;
  dynamic video;
  DateTime createdAt;
  DateTime updatedAt;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    name: json["name"],
    title: json["title"],
    description: json["description"],
    type: json["type"],
    place: json["place"],
    status: json["status"],
    duration: json["duration"],
    ordering: json["ordering"],
    image: json["image"],
    video: json["video"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

// Map<String, dynamic> toJson() => {
//   "id": id,
//   "from_id": fromId,
//   "to_id": toId,
//   "read": read,
//   "message": message,
//   "created_at": createdAt.toIso8601String(),
//   "updated_at": updatedAt.toIso8601String(),
// };
}