import 'dart:convert';

import 'package:http/http.dart' as http;
import '../constant/contant.dart';
import '../repository/user_repository.dart';

class Messages {
  String status;
  String messsage;
  int id;
  String from_id;
  String to_id;
  String read;
  DateTime createdAt;
  DateTime updatedAt;

  Future<void> getMessagesData() async {
    String url = '$baseLinkApi/chat/get_msgs';

    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${currentUser.value.apiToken}",
      },
    );
    try {
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        var s = json.decode(body);
        print(body);
        fromJson(s);
      } else {
        print("response.statusCode :${response.statusCode}");
      }
    } catch (e) {
      print('Errrorr : ${e}');
    }
  }

  Future<void> sendMessage(int recieverId, String message) async {
    String url = '$baseLinkApi/chat/send_msg';

    var response = await http.post(
      Uri.parse(url),
      body: {
        "receiver_id": recieverId,
        "message": message,
      },
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${currentUser.value.apiToken}",
      },
    );
    try {
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        var s = json.decode(body);
        print(body);
        toJson();
      } else {
        print("response.statusCode :${response.statusCode}");
      }
    } catch (e) {
      print('Errrorr : ${e}');
    }
  }

  void fromJson(Map<String, dynamic> json) {
    status:
    json["status"];
    messsage:
    json["msg"];
    id:
    json["data"]["id"];
    from_id:
    json["data"]["from_id"];
    to_id:
    json["data"]["to_id"];
    read:
    json["data"]["read"];
    createdAt:
    DateTime.parse(json["data"]["created_at"]);
    updatedAt:
    DateTime.parse(json["data"]["updated_at"]);
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "id": id,
        "from_id": from_id,
        "to_id": to_id,
        "read": read,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
