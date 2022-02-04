import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import '../constant/contant.dart';
import '../model/live_user.dart';
import '../repository/user_repository.dart';

class GetLiveUsers extends ChangeNotifier {
  GetLiveUsers() {
    getItems();
  }

  getItems() async {
    await getLiveUsers();
  }

  LiveRoomsResponse liveuser;
  bool isLoading = false;
  Future<LiveRoomsResponse> getLiveUsers() async {
    var decodedBody;  

    final String url = '${baseLinkApi}user/on_live';
    try {
      isLoading = true;
      var response = await http.post(
        Uri.parse(url),
        body: {
          "live": "1",
        },
        headers: {
          "Accept": 'application/json',
          "Bearer": "${currentUser.value.apiToken}",
          "Authorization": "Bearer ${currentUser.value.apiToken}",
        },
      );
      isLoading = false;
      decodedBody = json.decode(response.body);
      print("Data ********");
      print(response.body);
      print("Data Content ********");

      if (decodedBody.length == 0) {
        return null;
      }
      liveuser = LiveRoomsResponse.fromJson(decodedBody);

      // print("Provider Done");

      notifyListeners();
    } catch (error) {
      isLoading = false;
      notifyListeners();
      print(error.toString());
    }
    return liveuser;
  }
}
