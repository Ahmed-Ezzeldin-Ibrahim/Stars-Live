import 'dart:convert';

import '../constant/contant.dart';
import '../model/top_users.dart';

import 'package:http/http.dart' as http;
import 'user_repository.dart';

Future<TopUsers> giftSenders(String time) async {
  final String url = '${baseLinkApi}top/giftsenders';
  final response = await http.post(Uri.parse(url), body: {
    "time": time,
  }, headers: {
    "Accept": "application/json",
    "Authorization": "Bearer ${currentUser.value.apiToken}"
  });
  var decodedBody = jsonDecode(response.body);
  print(response.body);
  TopUsers topUsers = TopUsers.fromJson(decodedBody);
  return topUsers;
}

Future<TopUsers> giftRecievers(String time) async {
  final String url = '${baseLinkApi}top/giftreceivers';
  final response = await http.post(Uri.parse(url), body: {
    "time": time,
  }, headers: {
    "Accept": "application/json",
    "Authorization": "Bearer ${currentUser.value.apiToken}"
  });
  var decodedBody = jsonDecode(response.body);
  print(response.body);
  TopUsers topUsers = TopUsers.fromJson(decodedBody);
  return topUsers;
}

Future<TopUsers> getSupporters(String time) async {
  final String url = '${baseLinkApi}top/mysupporters';
  final response = await http.post(Uri.parse(url), body: {
    "time": time,
  }, headers: {
    "Accept": "application/json",
    "Authorization": "Bearer ${currentUser.value.apiToken}"
  });
  var decodedBody = jsonDecode(response.body);
  print(response.body);
  TopUsers topUsers = TopUsers.fromJson(decodedBody);
  return topUsers;
}
