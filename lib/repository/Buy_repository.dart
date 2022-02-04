




import 'dart:convert';

import '../constant/contant.dart';
import '../model/BuyModel.dart';
import '../model/User.dart';
import 'package:http/http.dart' as http;
import 'user_repository.dart';


Future<BuyInfo> getStatusofBuy({String receiver_id , String usd}) async {
  final String url = '${baseLinkApi}user/send_coins';
  var response = await http.post(Uri.parse(url), body: <String, dynamic>{
    'usd' : usd,
    'receiver_id': receiver_id,
  }, headers: {
    "Accept": 'application/json',
    "Authorization": "Bearer ${currentUser.value.apiToken}",
  });
  try {
    if (response.statusCode == 200) {
      //Map<String, dynamic> m = jsonDecode(response.body);
      if(response.body.isNotEmpty) {
        var body2 = json.decode(response.body);
        var body = jsonDecode(response.body);
        print(body);
        print(body2);
      }

      //BuyInfo user = BuyInfo(status: body["status"], msg: body["msg"],);
      //print(user.status);
      //BuyInfo user = BuyInfo.fromJson(m);
      //return user ;
    }
    else {
      print("response.statusCode :${response.statusCode}");
      print("response.statusCode :${response.body.toString()}");
    }
  } catch (e) {
    print('Errrorr : ${e}');
  }
}