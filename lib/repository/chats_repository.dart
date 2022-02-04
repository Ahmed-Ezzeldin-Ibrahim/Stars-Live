import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constant/contant.dart';
import '../model/ChatModel.dart';
import 'user_repository.dart';

Future<Chat> getMessagesData() async {
  String url = 'http://starslive.club/public/api/chat/get_msgs';
  print('sss');
  Chat chat;
  var response = await http.get(
    Uri.parse(url),
    headers: {"Accept": "application/json", "Authorization": "Bearer ${currentUser.value.apiToken}"},
  );
  try {
    if (response.statusCode == 200) {
      Map<String, dynamic> m = jsonDecode(response.body);
      chat = Chat.fromJson(m);
      return chat;
    } else {
      print("response.statusCode :${response.statusCode}");
    }
  } catch (e) {
    print('Errrorr : ${e}');
  }
  return chat;
}

Future<Chat> sendMessagesData(String message, int receiver_id) async {
  String url = '$baseLinkApi/send_msg';
  print('sss');
  Chat chat;
  var response = await http.post(
    Uri.parse(url),
    body: {
      'message': message,
      'receiver_id': "$receiver_id",
    },
    headers: {"Accept": "application/json", "Authorization": "Bearer ${currentUser.value.apiToken}"},
  );
  try {
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print(body);
      print('here');
      chat = Chat.fromJson(body);
    } else {
      print("response.statusCode :${response.statusCode}");
    }
  } catch (e) {
    print('Errrorr : ${e}');
  }
  return chat;
}
