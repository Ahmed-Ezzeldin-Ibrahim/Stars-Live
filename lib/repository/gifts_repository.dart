import 'dart:convert';

import 'package:http/http.dart' as http;
import '../constant/contant.dart';
import '../model/gifts.dart';
import 'user_repository.dart';

Future<Gifts> getGifts() async {
  final String url = '${baseLinkApi}gifts/all';
  var response = await http.post(Uri.parse(url), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${currentUser.value.apiToken}"
      }),
      decodedBody = jsonDecode(response.body);
  print(response.body);
  print("User Token is ${currentUser.value.apiToken}");
  Gifts gifts = Gifts.fromJson(decodedBody);
  print("THIS GIFTS *******");
  print(response.body);
  return gifts;
}

Future<void> sendGifts({dynamic recieverId, dynamic giftId}) async {
  final String url = '${baseLinkApi}user/send_gift';
  var response = await http.post(Uri.parse(url), body: {
    "receiver_id": recieverId,
    "gift_id": giftId,
    "gift_number": "1",
  }, headers: {
    "Accept": "application/json",
    "Authorization": "Bearer ${currentUser.value.apiToken}"
  });
  var decodedBody = jsonDecode(response.body);
  print(decodedBody['msg']);
  if (response.statusCode == 200) {}
}
